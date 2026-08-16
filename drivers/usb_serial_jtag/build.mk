srcs-y += $(addprefix ${PATH_DRIVERS}/usb_serial_jtag/, \
		usb_serial_jtag.c                               \
	)

INCLUDES += ${PATH_DRIVERS}/usb_serial_jtag
