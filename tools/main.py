import serial
import struct
import time

# SLIP
SLIP_END = 0xC0
SLIP_ESC = 0xDB
SLIP_ESC_END = 0xDC
SLIP_ESC_ESC = 0xDD

# ROM_COMMAND
ROM_COMMAND_SYNC = 0x08
ROM_COMMAND_WRITE_REG = 0x09
ROM_COMMAND_READ_REG = 0x0A
ROM_COMMAND_FLASH_BEGIN = 0x02
ROM_COMMAND_FLASH_DATA = 0x03
ROM_COMMAND_FLASH_END = 0x04
ROM_COMMAND_MEM_BEGIN = 0x05
ROM_COMMAND_MEM_DATA = 0x07
ROM_COMMAND_MEM_END = 0x08
ROM_COMMAND_SPI_SET_PARAMS = 0x0B
ROM_COMMAND_SPI_ATTACH = 0x0D

# ROM DIRECTION
ROM_DIRECTION_REQUEST = 0x00
ROM_DIRECTION_RESPONSE = 0x01

# ROM_HDR_FORMAT
ROM_HDR_FORMAT_COMMAND = "<BBHI"  # DIR | CMD | SIZE | CHECKSUM
ROM_HDR_FORMAT_RESPONSE = "<BBHI"  # DIR | CMD | SIZE | VALUE


class ESP32C6RomProtocol:
    def __init__(self, port, baudrate=115200, timeout=1):
        self.ser = serial.Serial(port, baudrate, timeout=timeout)
        self.packet_sequence = 0

    def slip_encode(self, data):
        encoded_data = bytearray()
        for b in data:
            if b == SLIP_END:
                encoded_data.append(SLIP_ESC)
                encoded_data.append(SLIP_ESC_END)
            elif b == SLIP_ESC:
                encoded_data.append(SLIP_ESC)
                encoded_data.append(SLIP_ESC_ESC)
            else:
                encoded_data.append(b)
        return encoded_data

    def slip_decode(self, data):
        decoded_data = bytearray()
        i = 0
        while i < len(data):
            if data[i] == SLIP_ESC:
                i += 1
                if data[i] == SLIP_ESC_END:
                    decoded_data.append(SLIP_END)
                elif data[i] == SLIP_ESC_ESC:
                    decoded_data.append(SLIP_ESC)
            else:
                decoded_data.append(data[i])
            i += 1
        return decoded_data

    def calculate_checksum(self, data):
        checksum = 0xEF

        for byte in data:
            checksum ^= byte

        return checksum & 0xFF

    def send_command(self, cmd, data=b"", checksum=0):
        header = struct.pack(
            ROM_HDR_FORMAT_COMMAND, ROM_DIRECTION_REQUEST, cmd, len(data), checksum
        )
        packet = self.slip_encode(header + data)

        self.ser.write(bytearray([SLIP_END]))
        self.ser.write(packet)
        self.ser.write(bytearray([SLIP_END]))

    def check_response(self, packet, cmd):
        # print("".join(f"0x{b:02X} " for b in packet))

        if len(packet) < 8:
            raise ValueError(f"Invalid response length: {len(packet)}")

        if packet[0] != ROM_DIRECTION_RESPONSE:
            raise ValueError(f"Invalid response direction: {packet[0]}")

        if packet[1] != cmd:
            raise ValueError(f"Invalid response cmd({cmd}): {packet[1]}")

        size = struct.unpack("<H", packet[2:4])[0]
        if len(packet) != 8 + size:
            raise ValueError(f"Invalid response size({size}): {len(packet)} ")

    def recv_response(self, cmd):
        resp = bytearray()

        while True:
            byte = self.ser.read()
            if not byte:
                return None
            if byte != bytes([SLIP_END]):
                resp.extend(byte)
                break

        while True:
            byte = self.ser.read()
            if not byte:
                raise serial.SerialTimeoutException("Failed to find end of packet")
            if byte == bytes([SLIP_END]):
                break
            resp.extend(byte)

        packet = self.slip_decode(resp)

        self.check_response(packet, cmd)

        return packet

    def enter_download_mode(self):
        print("====== ENTER DOWNLOAD MODE START ======")

        self.ser.dtr = False
        self.ser.rts = False
        time.sleep(0.1)
        self.ser.dtr = True
        self.ser.rts = False
        time.sleep(0.1)
        self.ser.rts = True
        self.ser.dtr = False
        time.sleep(0.1)
        self.ser.rts = True
        self.ser.rts = False

        print("====== ENTER DOWNLOAD MODE END ======")

    def reset(self):
        print("====== CHIP RESET START ======")

        self.ser.dtr = False
        self.ser.rts = False
        time.sleep(0.1)
        self.ser.rts = True
        self.ser.rts = False

        print("====== CHIP RESET END ======")

    def flush(self):
        while True:
            line = self.ser.readline()
            if line:
                decoded_line = line.decode("utf-8", "ignore").strip()
                print(decoded_line)
            else:
                break

    def sync(self):
        print("====== SYNC START ======")

        data = bytearray(
            [
                0x07,
                0x07,
                0x12,
                0x20,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
                0x55,
            ]
        )

        self.send_command(ROM_COMMAND_SYNC, data)

        while True:
            resp = self.recv_response(ROM_COMMAND_SYNC)
            if not resp:
                break

            status = resp[8]
            error = resp[9]

            if status != 0:
                print(f"SYNC ERROR CODE: {error}")

        print("====== SYNC SUCCESS ======")

        return True

    def write_reg(self, address, value, mask=0xFFFFFFFF):
        print("====== WRITE_REG START ======")

        data = struct.pack("<IIII", address, value, mask, 1)

        self.send_command(ROM_COMMAND_WRITE_REG, data)
        resp = self.recv_response(ROM_COMMAND_WRITE_REG)
        if not resp:
            print("WRITE_REG TIMEOUT")
            return False

        status = resp[8]
        error = resp[9]

        if status != 0:
            print(f"READ_REG ERROR CODE: {error}")
            return False

        print(
            f"====== WRITE_REG SUCCESS: ADDR({hex(address)}) VALUE({hex(value)}) ======"
        )

        return True

    def read_reg(self, address):
        print("====== READ_REG START ======")

        data = struct.pack("<I", address)
        self.send_command(ROM_COMMAND_READ_REG, data)

        resp = self.recv_response(ROM_COMMAND_READ_REG)
        if not resp:
            print("READ_REG TIMEOUT")
            return False

        value = struct.unpack("<I", resp[4:8])[0]
        status = resp[8]
        error = resp[9]

        if status != 0:
            print(f"READ_REG ERROR CODE: {error}")
            return False

        print(
            f"====== READ_REG SUCCESS: ADDR({hex(address)}) VALUE({hex(value)}) ======"
        )

        return True

    def flash_begin(self, eraze_size, nr_blocks, block_size, offset, encrypt=0):
        print("====== FLASH_BEGIN START ======")

        data = struct.pack("<IIIII", eraze_size, nr_blocks, block_size, offset, encrypt)
        self.send_command(ROM_COMMAND_FLASH_BEGIN, data)

        resp = self.recv_response(ROM_COMMAND_FLASH_BEGIN)
        if not resp:
            print("FLASH_BEGIN TIMEOUT")
            return False

        print("====== FLASH_BEGIN SUCCESS ======")

        return True

    def flash_data(self, block_size, seq, payload):
        print("====== FLASH_DATA START ======")

        metadata = struct.pack("<IIII", block_size, seq, 0, 0)
        checksum = self.calculate_checksum(payload)

        data = metadata + payload
        self.send_command(ROM_COMMAND_FLASH_DATA, data, checksum)

        resp = self.recv_response(ROM_COMMAND_FLASH_DATA)
        if not resp:
            print("FLASH_DATA TIMEOUT")
            return False

        print("====== FLASH_DATA SUCCESS ======")

        return True

    def flash_end(self, reboot=True):
        print("====== FLASH_END START ======")
        reboot_flag = 0x01 if reboot else 0x00

        data = struct.pack("<I", reboot_flag)
        self.send_command(ROM_COMMAND_FLASH_END, data)

        resp = self.recv_response(ROM_COMMAND_FLASH_END)
        if not resp:
            print("FLASH_END TIMEOUT")
            return False

        print("====== FLASH_END SUCCESS ======")

        return True

    def mem_begin(self, total_size, nr_blocks, block_size, offset):
        print("====== MEM_BEGIN START ======")

        data = struct.pack("<IIII", total_size, nr_blocks, block_size, offset)
        self.send_command(ROM_COMMAND_MEM_BEGIN, data)

        resp = self.recv_response(ROM_COMMAND_MEM_BEGIN)
        if not resp:
            print("MEM_BEGIN TIMEOUT")
            return False

        status = resp[8]
        error = resp[9]

        if status != 0:
            print(f"MEM_BEGIN ERROR CODE: {error}")
            return False

        print("====== MEM_BEGIN SUCCESS ======")

        return True

    def mem_data(self, block_size, seq, payload):
        print("====== MEM_DATA START ======")

        metadata = struct.pack("<IIII", block_size, seq, 0, 0)
        checksum = self.calculate_checksum(payload)
        data = metadata + payload
        self.send_command(ROM_COMMAND_MEM_DATA, data, checksum)

        resp = self.recv_response(ROM_COMMAND_MEM_DATA)
        if not resp:
            print("MEM_DATA TIMEOUT")
            return False

        status = resp[8]
        error = resp[9]

        if status != 0:
            print(f"MEM_DATA ERROR CODE: {error}")
            return False

        print("====== MEM_DATA SUCCESS ======")

        return True

    def mem_end(self, execute_flag, entry_point):
        print("====== MEM_END START ======")

        data = struct.pack("<II", execute_flag, entry_point)
        self.send_command(ROM_COMMAND_MEM_END, data)

        resp = self.recv_response(ROM_COMMAND_MEM_END)
        if not resp:
            print("MEM_END TIMEOUT")
            return False

        status = resp[8]
        error = resp[9]

        if status != 0:
            print(f"MEM_END ERROR CODE: {error}")
            return False

        print("====== MEM_END SUCCESS ======")

        return True

    def spi_set_params(self, total_size):
        print("====== SPI_SET_PARAMS START ======")

        fl_id = 0
        block_size = 64 * 1024
        sector_size = 4 * 1024
        page_size = 256
        status_mask = 0xFFFF

        data = struct.pack(
            "<IIIIII",
            fl_id,
            total_size,
            block_size,
            sector_size,
            page_size,
            status_mask,
        )
        self.send_command(ROM_COMMAND_SPI_SET_PARAMS, data)

        rsep = self.recv_response(ROM_COMMAND_SPI_SET_PARAMS)
        if not resp:
            print("SPI_SET_PARAMS TIMEOUT")
            return False

        status = resp[8]
        error = resp[9]

        if status != 0:
            print(f"SPI_SET_PARAMS ERROR CODE: {error}")
            return False

        print("====== SPI_SET_PARAMS SUCCESS ======")

        return True

    def spi_attach(self, spi_if=0):
        print("====== SPI_ATTACH START ======")

        data = struct.pack("<II", spi_if, 0)
        self.send_command(ROM_COMMAND_SPI_ATTACH, data)

        resp = self.recv_response(ROM_COMMAND_SPI_ATTACH)
        if not resp:
            print("SPI_ATTACH TIMEOUT")
            return False

        status = resp[8]
        error = resp[9]

        if status != 0:
            print(f"SPI_ATTACH ERROR CODE: {error}")
            return False

        print("====== SPI_ATTACH SUCCESS ======")

        return True

    def close(self):
        self.ser.close()


if __name__ == "__main__":
    try:
        protocol = ESP32C6RomProtocol(port="/dev/ttyACM0")

        protocol.enter_download_mode()
        protocol.flush()
        protocol.sync()

        eraze_size = 0x8000
        nr_blocks = 8
        block_size = 0x1000
        offset = 0x0

        protocol.spi_attach(0)
        # protocol.spi_set_params(eraze_size)

        protocol.flash_begin(eraze_size, nr_blocks, block_size, offset)
        for seq in range(0, nr_blocks):
            payload = block_size * b"\x00"
            protocol.flash_data(block_size, seq, payload)
        protocol.flash_end(True)

    except serial.SerialException as e:
        print(f"SERIAL EXCEPTION: {e}")
    except ValueError as e:
        print(f"PROTOCOL ERROR: {e}")
    finally:
        protocol.reset()
        while True:
            protocol.flush()

        if "protocol" in locals():
            protocol.close()
            print("Serial Closed")
