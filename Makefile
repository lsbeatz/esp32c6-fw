# Check that given variables are set
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

V ?= 0 # Verbose (0: quiet, 1: print all)
Q := $(if $(filter 1,${V}),,@)

TARGET ?=
NAME   ?= default

ARCH  := rv32imac
PLAT  := esp32c6

BUILD_DIR   := out/$(NAME)
SRC_DIR     := arch/$(ARCH)
SRC_DIR     += plat
SRC_DIR     += drivers
SRC_DIR     += $(TARGET)

TOOLCHAIN_PATH ?= /opt/riscv/bin
TOOLCHAIN_NAME ?= riscv32-unknown-elf

CC		= $(TOOLCHAIN_PATH)/$(TOOLCHAIN_NAME)-gcc
LD		= $(TOOLCHAIN_PATH)/$(TOOLCHAIN_NAME)-ld
OBJCOPY	= $(TOOLCHAIN_PATH)/$(TOOLCHAIN_NAME)-objcopy
OBJDUMP	= $(TOOLCHAIN_PATH)/$(TOOLCHAIN_NAME)-objdump

LDFLAGS  := -nostdlib
CFLAGS   := -Wall -ffreestanding
CFLAGS   += -march=$(ARCH) -mabi=ilp32  -mcmodel=medlow
CFLAGS   += $(addprefix -I,$(SRC_DIR))
ASMFLAGS := -march=$(ARCH)_zicsr
OBJFLAGS := -j .init -j .text*
MACROS   := -DARCH=$(ARCH)
MACROS   += -DPLAT=$(PLAT)

LSCRIPT = arch/$(ARCH)/lscript.ld

SRCS  = $(shell find $(SRC_DIR) -name '*.c')
ASMS  = $(shell find $(SRC_DIR) -name '*.S')
OBJS  = $(addprefix $(BUILD_DIR)/,$(SRCS:%.c=%.c.o))
OBJS += $(addprefix $(BUILD_DIR)/,$(ASMS:%.S=%.s.o))
ELF   = $(BUILD_DIR)/out.elf
BIN   = $(BUILD_DIR)/out.bin
DASM  = $(BUILD_DIR)/out.dasm

SUB_DIR = $(dir $(SRCS) $(ASMS))
MK_DIR  = $(addprefix $(BUILD_DIR)/,$(SUB_DIR))

all: dir $(BIN) $(DASM)

dir:
	$(call check_defined, TARGET)
	@mkdir -p $(MK_DIR)

$(BIN): $(ELF)
	$(Q) $(OBJCOPY) $(OBJFLAGS) -S $(ELF) -O binary $@

$(DASM): $(ELF)
	$(Q) $(OBJDUMP) -D $(ELF) > $@

$(ELF): $(LSCRIPT) $(OBJS)
	$(Q) $(LD) $(LDFLAGS) -T $(LSCRIPT) -o $(ELF) $(OBJS)

$(BUILD_DIR)/%.c.o: %.c
	$(Q) $(CC) $(CFLAGS) $(MACROS) -c $< -o $@

$(BUILD_DIR)/%.s.o: %.S
	$(Q) $(CC) $(ASMFLAGS) $(MACROS) -c $< -o $@

clean:
	$(Q)rm -rf $(BUILD_DIR)

tags:
	@ctags -R
