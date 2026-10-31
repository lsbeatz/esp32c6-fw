TARGET ?= # mandatory
CONFIG ?= # mandatory
NAME   ?= # optional

V ?= 0 # Verbose {0: quiet, 1: print all}
Q := $(if $(filter 1,${V}),,@)

MAKEFLAGS += -j$(shell nproc)

include scripts/paths.mk
include scripts/utils.mk
include scripts/macro.mk

include ${CONFIG}

include ${PATH_CHIP}/build.mk
include ${PATH_ARCH}/build.mk
include ${PATH_DRIVERS}/build.mk
include ${PATH_LIB}/build.mk
ifneq (${TARGET},)
include ${TARGET}/build.mk
endif

DIR_OUT := $(if ${NAME},${PATH_OUT}/${NAME},${PATH_OUT})

TOOLCHAIN_PATH ?= /opt/riscv/bin
TOOLCHAIN_NAME ?= riscv32-unknown-elf

CC		:= ${TOOLCHAIN_PATH}/${TOOLCHAIN_NAME}-gcc
LD		:= ${TOOLCHAIN_PATH}/${TOOLCHAIN_NAME}-ld
OBJCOPY	:= ${TOOLCHAIN_PATH}/${TOOLCHAIN_NAME}-objcopy
OBJDUMP	:= ${TOOLCHAIN_PATH}/${TOOLCHAIN_NAME}-objdump

LDFLAGS  := -nostdlib -Wl,--gc-sections
CFLAGS   := -Wall -ffreestanding -O2 -ffunction-sections -fdata-sections
CFLAGS   += -march=${ARCH}_zicsr
CFLAGS   += -mabi=${ABI}
CFLAGS   += -mcmodel=${CMODEL}
CFLAGS   += ${addprefix -I,${INCLUDES}}
ASMFLAGS := -march=${ARCH}_zicsr -ffunction-sections -fdata-sections
OBJFLAGS := -j .init -j .text* -j .*data*

OBJS := $(addprefix ${DIR_OUT}/,${srcs-y:%.c=%.c.o})
OBJS += $(addprefix ${DIR_OUT}/,${asms-y:%.S=%.s.o})
ELF  := ${DIR_OUT}/out.elf
BIN  := ${DIR_OUT}/out.bin
PAD  := ${DIR_OUT}/out.bin.pad
IMG  := ${DIR_OUT}/out.img
DASM := ${DIR_OUT}/out.dasm

DIRS := $(sort $(dir ${OBJS}))

.PHONY: all dir check
all: check dir ${BIN} ${PAD} ${DASM} ${IMG}

check:
	$(call check_defined,TARGET)
	$(call check_defined,CONFIG)

dir:
	${Q} ${MKDIR} ${DIRS}

${PAD}: ${BIN}
	${Q} cp $< $@
	${Q} filesize=$$(stat -c%s $@);                         \
	remainder=$$(($$filesize % 16));                        \
	if [ $$remainder -ne 0 ]; then                          \
		pad=$$( Make=1 expr 16 - $$remainder );             \
		dd if=/dev/zero bs=1 count=$$pad >> $@ status=none; \
	fi

${BIN}: ${ELF}
	${Q} ${OBJCOPY} ${OBJFLAGS} -S ${ELF} -O binary $@

${DASM}: ${ELF}
	${Q} ${OBJDUMP} -D ${ELF} > $@

${ELF}: ${OBJS}
	${Q} ${CC} ${LDFLAGS} -T ${LDSCRIPT} -o ${ELF} ${OBJS} -lgcc

${DIR_OUT}/%.c.o: %.c
	${Q} ${CC} ${CFLAGS} ${MACROS} -c $< -o $@

${DIR_OUT}/%.s.o: %.S
	${Q} ${CC} ${ASMFLAGS} ${MACROS} -c $< -o $@

${IMG}: ${PAD}
	${Q} ${UV} run tools/imager/main.py ${PAD} ${IMG}

.PHONY: image flash monitor
image: ${IMG}

flash: ${IMG}
	${Q} ${UV} run tools/espctl/espctl.py flash ${IMG}

monitor:
	${Q} ${UV} run tools/espctl/espctl.py monitor

.PHONY: docs docs-regs
docs: docs-regs

docs-regs:
	${Q} cat docs/regs/docskit.cmds | while read -r line; do \
		${UV} run tools/docskit/main.py $$line; \
	done

.PHONY: clean tags
clean:
	${Q} ${RM} ${DIR_OUT}

tags:
	@ctags -R
