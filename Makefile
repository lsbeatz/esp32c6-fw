include scripts/paths.mk
include scripts/utils.mk
include scripts/macro.mk

V ?= 0 # Verbose {0: quiet, 1: print all}
Q := $(if $(filter 1,${V}),,@)

TARGET ?= # mandatory
NAME   ?= # optional

ARCH  := rv32imac
PLAT  := esp32c6

OUT_DIR := ${PATH_OUT}/${NAME}
SRC_DIR := ${PATH_ARCH}/${ARCH}
SRC_DIR += ${PATH_PLAT}
SRC_DIR += ${PATH_DRIVERS}
SRC_DIR += ${TARGET}

TOOLCHAIN_PATH ?= /opt/riscv/bin
TOOLCHAIN_NAME ?= riscv32-unknown-elf

CC		:= ${TOOLCHAIN_PATH}/${TOOLCHAIN_NAME}-gcc
LD		:= ${TOOLCHAIN_PATH}/${TOOLCHAIN_NAME}-ld
OBJCOPY	:= ${TOOLCHAIN_PATH}/${TOOLCHAIN_NAME}-objcopy
OBJDUMP	:= ${TOOLCHAIN_PATH}/${TOOLCHAIN_NAME}-objdump

LDFLAGS  := -nostdlib
CFLAGS   := -Wall -ffreestanding
CFLAGS   += -march=${ARCH} -mabi=ilp32 -mcmodel=medlow
CFLAGS   += ${addprefix -I,${SRC_DIR}}
ASMFLAGS := -march=${ARCH}_zicsr
OBJFLAGS := -j .init -j .text* -j .*data
MACROS   := -DARCH=${ARCH}
MACROS   += -DPLAT=${PLAT}

LSCRIPT := arch/${ARCH}/lscript.ld

SRCS := $(shell find ${SRC_DIR} -name '*.c')
ASMS := $(shell find ${SRC_DIR} -name '*.S')
OBJS := $(addprefix ${OUT_DIR}/,${SRCS:%.c=%.c.o})
OBJS += $(addprefix ${OUT_DIR}/,${ASMS:%.S=%.s.o})
ELF  := ${OUT_DIR}/out.elf
BIN  := ${OUT_DIR}/out.bin
IMG  := ${OUT_DIR}/out.img
DASM := ${OUT_DIR}/out.dasm

DIRS := $(dir ${OBJS})

.PHONY: all dir
all: dir ${BIN} ${DASM} ${IMG}

dir:
	$(call check_defined,TARGET)
	${Q} ${MKDIR} ${DIRS}

${IMG}: image

${BIN}: ${ELF}
	${Q} ${OBJCOPY} ${OBJFLAGS} -S ${ELF} -O binary $@

${DASM}: ${ELF}
	${Q} ${OBJDUMP} -D ${ELF} > $@

${ELF}: ${LSCRIPT} ${OBJS}
	${Q} ${LD} ${LDFLAGS} -T ${LSCRIPT} -o ${ELF} ${OBJS}

${OUT_DIR}/%.c.o: %.c
	${Q} ${CC} ${CFLAGS} ${MACROS} -c $< -o $@

${OUT_DIR}/%.s.o: %.S
	${Q} ${CC} ${ASMFLAGS} ${MACROS} -c $< -o $@

.PHONY: image flash
image: ${BIN}
	${Q} ${PY} tools/imager/main.py ${BIN} ${IMG}

flash: ${IMG}
	${Q} ${PY} tools/flasher/main.py ${IMG}

.PHONY: clean tags
clean:
	${Q} ${RM} ${OUT_DIR}

tags:
	@ctags -R
