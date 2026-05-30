import serial
import struct
import time
import argparse

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
    def __init__(self, port, baudrate=115200, timeout=0.1):
        self.ser = serial.Serial(port, baudrate, timeout=timeout)

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
        header = struct.pack(ROM_HDR_FORMAT_COMMAND, ROM_DIRECTION_REQUEST, cmd, len(data), checksum)
        packet = self.slip_encode(header + data)

        self.ser.write(bytearray([SLIP_END]))
        self.ser.write(packet)
        self.ser.write(bytearray([SLIP_END]))

    def check_response(self, packet, cmd):
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
                raise serial.SerialTimeoutException(f"Failed to get end of packet: cmd({cmd})")
            if byte == bytes([SLIP_END]):
                break
            resp.extend(byte)

        packet = self.slip_decode(resp)

        self.check_response(packet, cmd)

        return packet

    def enter_download_mode(self):
        self.ser.dtr = False  # RTS=?, DTR=0 | Initialize to know values
        self.ser.rts = False  # RTS=0, DTR=0 | -
        self.ser.dtr = True  # RTS=0, DTR=1 | Set download mode flag
        self.ser.rts = False  # RTS=0, DTR=1 | Propagete DTR
        self.ser.rts = True  # RTS=1, DTR=1 | -
        self.ser.dtr = False  # RTS=1, DTR=0 | Reset SoC
        self.ser.rts = True  # RTS=1, DTR=0 | Propagete DTR
        self.ser.rts = False  # RTS=0, DTR=0 | Clear download flag

    def reset(self):
        self.ser.dtr = False  # RTS=?, DTR=0 | -
        self.ser.rts = False  # RTS=0, DTR=0 | Clear download flag
        self.ser.rts = True  # RTS=1, DTR=0 | Reset SoC
        self.ser.rts = False  # RTS=0, DTR=0 | Exit Reset

    def flush(self):
        while True:
            line = self.ser.readline()
            if line:
                decoded_line = line.decode("utf-8", "ignore").strip()
                print(decoded_line)
            else:
                break

    def sync(self):
        data = bytearray([0x07, 0x07, 0x12, 0x20] + [0x55] * 32)

        for i in range(10):
            try:
                self.send_command(ROM_COMMAND_SYNC, data)
                resp = self.recv_response(ROM_COMMAND_SYNC)
                if resp:
                    status = resp[8]
                    error = resp[9]

                    if status != 0:
                        print(f"SYNC ERROR CODE: {error}")
                    else:
                        while True:
                            resp = self.recv_response(ROM_COMMAND_SYNC)
                            if not resp:
                                break
                        return True
            except SerialTimeoutException:
                print(f"SYNC Retrying...({i})")

        raise RuntimeError("Failed to sync with ESP32C6 ROM Loader")

    def write_reg(self, address, value, mask=0xFFFFFFFF):
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

        print(f"====== WRITE_REG SUCCESS: ADDR({hex(address)}) VALUE({hex(value)}) ======")

        return True

    def read_reg(self, address):
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

        print(f"====== READ_REG SUCCESS: ADDR({hex(address)}) VALUE({hex(value)}) ======")

        return True

    def flash_begin(self, erase_size, nr_blocks, block_size, offset, encrypt=0):
        data = struct.pack("<IIIII", erase_size, nr_blocks, block_size, offset, encrypt)
        self.send_command(ROM_COMMAND_FLASH_BEGIN, data)

        resp = self.recv_response(ROM_COMMAND_FLASH_BEGIN)
        if not resp:
            print("FLASH_BEGIN TIMEOUT")
            return False

        return True

    def flash_data(self, block_size, seq, payload):
        metadata = struct.pack("<IIII", block_size, seq, 0, 0)
        checksum = self.calculate_checksum(payload)

        data = metadata + payload
        self.send_command(ROM_COMMAND_FLASH_DATA, data, checksum)

        resp = self.recv_response(ROM_COMMAND_FLASH_DATA)
        if not resp:
            print("FLASH_DATA TIMEOUT")
            return False

        return True

    def flash_end(self, reboot=False):
        reboot_flag = 0x01 if reboot else 0x00

        data = struct.pack("<I", reboot_flag)
        self.send_command(ROM_COMMAND_FLASH_END, data)

        resp = self.recv_response(ROM_COMMAND_FLASH_END)
        if not resp:
            print("FLASH_END TIMEOUT")
            return False

        return True

    def mem_begin(self, total_size, nr_blocks, block_size, offset):
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

        return True

    def mem_data(self, block_size, seq, payload):
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

        return True

    def mem_end(self, execute_flag, entry_point):
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

        return True

    def spi_set_params(self, total_size):
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

        return True

    def spi_attach(self, spi_if=0):
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

        return True

    def close(self):
        self.ser.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Load image to ESP32C6 flash")
    parser.add_argument("input", type=str, help="Path to input image file")

    args = parser.parse_args()

    input_file = args.input

    try:
        with open(input_file, "rb") as f:
            input_bin = f.read()
    except FileNotFoundError:
        print(f"Error: '{input_file}' not found")
        exit()

    try:
        protocol = ESP32C6RomProtocol(port="/dev/ttyACM0")

        protocol.enter_download_mode()
        protocol.flush()
        protocol.sync()

        erase_size = len(input_bin)
        nr_blocks = 1
        block_size = len(input_bin)
        offset = 0x0

        protocol.spi_attach(0)
        # protocol.spi_set_params(erase_size)

        protocol.flash_begin(erase_size, nr_blocks, block_size, offset)
        for seq in range(0, nr_blocks):
            payload = input_bin
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
