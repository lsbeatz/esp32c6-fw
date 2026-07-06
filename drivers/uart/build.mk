srcs-y += $(addprefix ${PATH_DRIVERS}/uart/, \
		uart.c                               \
	)

INCLUDES += ${PATH_DRIVERS}/uart
