srcs-y += $(addprefix ${PATH_LIB}/stub/, \
		sbrk.c                           \
		syscalls.c                       \
		io.c                             \
		math.c                           \
	)

INCLUDES += ${PATH_LIB}/stub
