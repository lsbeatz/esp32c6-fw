#include <errno.h>
#include <stddef.h>
#include <sys/types.h>

static int fail_enosys(void)
{
	errno = ENOSYS;
	return -1;
}

void _exit(int status)
{
	(void)status;
	for (;;) {
	}
}

int raise(int sig)
{
	(void)sig;
	return fail_enosys();
}

int times(void *buf)
{
	(void)buf;
	return fail_enosys();
}

int gettimeofday(void *tv, void *tz)
{
	(void)tv;
	(void)tz;
	return fail_enosys();
}

int getentropy(void *buf, size_t n)
{
	(void)buf;
	(void)n;
	return fail_enosys();
}

int open(const char *path, int flags, ...)
{
	(void)path;
	(void)flags;
	return fail_enosys();
}

int close(int fd)
{
	(void)fd;
	return fail_enosys();
}

off_t lseek(int fd, off_t off, int whence)
{
	(void)fd;
	(void)off;
	(void)whence;
	errno = ENOSYS;
	return (off_t)-1;
}

int unlink(const char *path)
{
	(void)path;
	return fail_enosys();
}

int fork(void)
{
	return fail_enosys();
}

int execve(const char *path, char *const argv[], char *const envp[])
{
	(void)path;
	(void)argv;
	(void)envp;
	return fail_enosys();
}

int waitpid(int pid, int *status, int options)
{
	(void)pid;
	(void)status;
	(void)options;
	return fail_enosys();
}

int pipe(int fds[2])
{
	(void)fds;
	return fail_enosys();
}

int dup2(int oldfd, int newfd)
{
	(void)oldfd;
	(void)newfd;
	return fail_enosys();
}

int regcomp(void *preg, const char *pattern, int cflags)
{
	(void)preg;
	(void)pattern;
	(void)cflags;
	return -1;
}

int regexec(const void *preg, const char *str, size_t nmatch, void *pmatch, int eflags)
{
	(void)preg;
	(void)str;
	(void)nmatch;
	(void)pmatch;
	(void)eflags;
	return -1;
}

void regfree(void *preg)
{
	(void)preg;
}
