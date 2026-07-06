ARCH   := rv32imac
ABI    := ilp32
CMODEL := medlow

LDSCRIPT := $(addprefix ${PATH_ARCH}/rv32imac/, \
		lscript.ld                              \
	)

asms-y += $(addprefix ${PATH_ARCH}/rv32imac/, \
		head.S                                \
	)


INCLUDES += ${PATH_ARCH}/rv32imac
