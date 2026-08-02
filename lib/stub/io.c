#include "stub.h"

#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <sys/types.h>

__attribute__((weak)) int stub_putc(char c)
{
	(void)c;
	return -1;
}

__attribute__((weak)) int stub_getc(void)
{
	return -1;
}

ssize_t write(int fd, const void *buf, size_t n)
{
	if (fd != 1 && fd != 2) {
		errno = ENOSYS;
		return -1;
	}

	const char *p = (const char *)buf;
	for (size_t i = 0; i < n; i++) {
		if (stub_putc(p[i]) < 0) {
			errno = EIO;
			return (ssize_t)i;
		}
	}
	return (ssize_t)n;
}

ssize_t read(int fd, void *buf, size_t n)
{
	if (fd != 0) {
		errno = ENOSYS;
		return -1;
	}

	char *p = (char *)buf;
	for (size_t i = 0; i < n; i++) {
		int c = stub_getc();
		if (c < 0) {
			return (ssize_t)i;
		}
		p[i] = (char)c;
	}
	return (ssize_t)n;
}

static int stdio_put(char c, FILE *f)
{
	(void)f;
	return stub_putc(c);
}

static int stdio_get(FILE *f)
{
	(void)f;
	return stub_getc();
}

static FILE __stdin	 = FDEV_SETUP_STREAM(NULL, stdio_get, NULL, _FDEV_SETUP_READ);
static FILE __stdout = FDEV_SETUP_STREAM(stdio_put, NULL, NULL, _FDEV_SETUP_WRITE);
static FILE __stderr = FDEV_SETUP_STREAM(stdio_put, NULL, NULL, _FDEV_SETUP_WRITE);

FILE *const stdin  = &__stdin;
FILE *const stdout = &__stdout;
FILE *const stderr = &__stderr;
