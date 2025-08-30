import struct
import sys
import os
import argparse

DEFAULT_ENTRY_POINT = 0x40800000

IMAGE_HEADER_FORMAT = (
    "<BBBBI"  # magic | segment_count | spi_mode | spi_speed | entry_point
)
IMAGE_HEADER_MAGIC = 0xE9

IMAGE_HEADER_SPI_MODE_QIO = 0
IMAGE_HEADER_SPI_MODE_QOUT = 1
IMAGE_HEADER_SPI_MODE_DIO = 2
IMAGE_HEADER_SPI_MODE_DOUT = 3

IMAGE_HEADER_FLASH_SIZE_1MB = 0 << 4
IMAGE_HEADER_FLASH_SIZE_2MB = 1 << 4
IMAGE_HEADER_FLASH_SIZE_4MB = 2 << 4
IMAGE_HEADER_FLASH_SIZE_8MB = 3 << 4
IMAGE_HEADER_FLASH_SIZE_16MB = 4 << 4

IMAGE_HEADER_FLASH_FREQ_80MHZ = 0
IMAGE_HEADER_FLASH_FREQ_40MHZ = 0
IMAGE_HEADER_FLASH_FREQ_20MHZ = 2

IMAGE_EXT_HEADER_FORMAT = "<IHBHHIB"

SEGMENT_HEADER_FORMAT = "<II"  # address | size


def get_checksum(input_bin):
    checksum = 0xEF

    for b in input_bin:
        checksum ^= b

    return checksum


def create_firmware_image(input_file, output_file, entry_point):
    try:
        with open(input_file, "rb") as f:
            input_bin = f.read()
    except FileNotFoundError:
        print(f"Error: '{input_file}' not found")
        return

    image_header = struct.pack(
        IMAGE_HEADER_FORMAT,
        IMAGE_HEADER_MAGIC,
        0x01,  # Number of segments
        IMAGE_HEADER_SPI_MODE_DIO,
        IMAGE_HEADER_FLASH_SIZE_2MB | IMAGE_HEADER_FLASH_FREQ_40MHZ,
        entry_point,
    )

    wp_drive = 0xEE
    chip_id = 0x0D
    min_rev = 0
    max_rev = 0x63
    hash_append = 0

    image_ext_header = struct.pack(
        IMAGE_EXT_HEADER_FORMAT, wp_drive, chip_id, 0, min_rev, max_rev, 0, hash_append
    )

    segment_size = len(input_bin)
    segment_header = struct.pack(SEGMENT_HEADER_FORMAT, entry_point, segment_size)

    total_size = len(image_header)
    total_size += len(image_ext_header)
    total_size += len(segment_header)
    total_size += len(input_bin)

    footer = bytearray()

    if total_size % 16 != 15:
        footer += (15 - (total_size % 16)) * b"\x00"

    footer.append(get_checksum(input_bin))

    with open(output_file, "wb") as f:
        f.write(image_header)
        f.write(image_ext_header)
        f.write(segment_header)
        f.write(input_bin)
        f.write(footer)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Create a firmware image file for ESP32C6 from a binary file"
    )

    parser.add_argument("input", type=str, help="Path to the input binary file")

    parser.add_argument("output", type=str, help="Path for the output image file")

    parser.add_argument(
        "--entry_point",
        type=lambda x: int(x, 16),
        default=DEFAULT_ENTRY_POINT,
        help="Entry point address",
    )

    args = parser.parse_args()

    create_firmware_image(args.input, args.output, args.entry_point)
