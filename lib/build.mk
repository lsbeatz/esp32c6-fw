ifeq (${CONFIG_LIB_PICOLIBC},y)
include ${PATH_LIB}/picolibc/build.mk
endif

ifeq (${CONFIG_LIB_STUB},y)
include ${PATH_LIB}/stub/build.mk
endif
