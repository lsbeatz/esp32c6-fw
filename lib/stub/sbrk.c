#include "sbrk.h"

#include <errno.h>
#include <stdint.h>

extern char __heap_end__[];
extern char __stack_end__[];

#ifdef CONFIG_LIB_STUB_HEAP_SIZE
#define STUB_HEAP_SIZE CONFIG_LIB_STUB_HEAP_SIZE
#else
#define STUB_HEAP_SIZE (32 * 1024)
#endif

void *sbrk(ptrdiff_t incr)
{
	static char *brk = __heap_end__;

	char *limit = __heap_end__ + STUB_HEAP_SIZE;
	if (limit > __stack_end__) {
		limit = __stack_end__;
	}

	if (brk + incr > limit) {
		errno = ENOMEM;
		return (void *)-1;
	}

	char *prev = brk;
	brk += incr;
	return prev;
}
