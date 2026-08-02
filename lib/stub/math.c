#include <stdint.h>

double ldexp(double x, int n)
{
	union {
		double d;
		uint64_t u;
	} v = { .d = x };

	int e = (int)((v.u >> 52) & 0x7ff);
	if (e == 0 || e == 0x7ff) {
		return x;
	}

	e += n;
	if (e >= 0x7ff) {
		v.u = (v.u & (1ULL << 63)) | ((uint64_t)0x7ff << 52);
		return v.d;
	}
	if (e <= 0) {
		v.u &= (1ULL << 63);
		return v.d;
	}

	v.u = (v.u & ~((uint64_t)0x7ff << 52)) | ((uint64_t)e << 52);
	return v.d;
}

double frexp(double x, int *ep)
{
	union {
		double d;
		uint64_t u;
	} v = { .d = x };

	int e = (int)((v.u >> 52) & 0x7ff);
	if (e == 0 || e == 0x7ff) {
		*ep = 0;
		return x;
	}

	*ep = e - 1022;
	v.u = (v.u & ~((uint64_t)0x7ff << 52)) | ((uint64_t)1022 << 52);
	return v.d;
}

long double frexpl(long double x, int *ep)
{
	return (long double)frexp((double)x, ep);
}

int finitef(float x)
{
	union {
		float f;
		uint32_t u;
	} v = { .f = x };

	return ((v.u >> 23) & 0xff) != 0xff;
}
