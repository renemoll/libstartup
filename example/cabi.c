
#include <sys/stat.h>

int _close(int file)
{
	(void) file;
	return -1;
}

int _fstat(int file, struct stat *st)
{
	(void) file;
	(void) st;
	return 0;
}

int _isatty(int file)
{
	(void) file;
	return 1;
}

int _lseek(int file, int ptr, int dir)
{
	(void) file;
	(void) ptr;
	(void) dir;
	return 0;
}

void _kill(int pid, int sig)
{
	(void) pid;
	(void) sig;
}

int _getpid(void)
{
	return -1;
}

int _write(int file, char *ptr, int len)
{
	(void) file;
	(void) ptr;
	(void) len;
	return -1;
}

int _read(int file, char *ptr, int len)
{
	(void) file;
	(void) ptr;
	(void) len;
	return -1;
}

int _gettimeofday(void *tp, void *tzp)
{
	(void) tp;
	(void) tzp;
	return -1;
}
