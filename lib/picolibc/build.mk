ifeq (${CONFIG_LIB_PICOLIBC_LIBC},y)
include ${PATH_LIB}/picolibc/libc/build.mk
endif

INCLUDES += ${PATH_LIB}/picolibc
