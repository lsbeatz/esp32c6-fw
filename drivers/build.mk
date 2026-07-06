ifeq (${CONFIG_DRV_UART},y)
include ${PATH_DRIVERS}/uart/build.mk
endif

ifeq (${CONFIG_DRV_WDT},y)
include ${PATH_DRIVERS}/wdt/build.mk
endif

ifeq (${CONFIG_DRV_TIMG},y)
include ${PATH_DRIVERS}/timg/build.mk
endif
