ifeq (${CONFIG_DRV_UART},y)
include ${PATH_DRIVERS}/uart/build.mk
endif

ifeq (${CONFIG_DRV_USB_SERIAL_JTAG},y)
include ${PATH_DRIVERS}/usb_serial_jtag/build.mk
endif

ifeq (${CONFIG_DRV_WDT},y)
include ${PATH_DRIVERS}/wdt/build.mk
endif

ifeq (${CONFIG_DRV_TIMG},y)
include ${PATH_DRIVERS}/timg/build.mk
endif
