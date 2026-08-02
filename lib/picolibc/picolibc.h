#ifndef PICOLIBC_H
#define PICOLIBC_H

/* The newlib major version number. */
#define __NEWLIB__ 4

/* The newlib minor version number. */
#define __NEWLIB_MINOR__ 3

/* The newlib patch level. */
#define __NEWLIB_PATCHLEVEL__ 0

/* The newlib version in string format. */
#define _NEWLIB_VERSION "4.3.0"

/* The Picolibc major version number. */
#define __PICOLIBC__ 1

/* The Picolibc minor version number. */
#define __PICOLIBC_MINOR__ 8

/* The Picolibc patch level. */
#define __PICOLIBC_PATCHLEVEL__ 11

/* The Picolibc version in string format. */
#define __PICOLIBC_VERSION__ "1.8.11"

/* Use atomics for fgetc/ungetc for re-entrancy */
#ifdef CONFIG_LIB_PICOLIBC_ATOMIC_UNGETC
#define __ATOMIC_UNGETC
#endif /* CONFIG_LIB_PICOLIBC_ATOMIC_UNGETC */

/* Always optimize strcmp for performance */
#define __FAST_STRCMP

/* use global errno variable */
#define __GLOBAL_ERRNO

/* use function to get errno address */
#undef __PICOLIBC_ERRNO_FUNCTION

/* Turn on mmu in picocrt startup code */
#undef __PICOCRT_ENABLE_MMU

/* use thread local storage */
#undef __THREAD_LOCAL_STORAGE

/* use thread local storage for stack protection canary */
#undef __THREAD_LOCAL_STORAGE_STACK_GUARD

/* Use posix apis for console too */
#undef POSIX_CONSOLE

/* Optimize for space over speed */
#define __PREFER_SIZE_OVER_SPEED

#define __TINY_STDIO

#undef _ATEXIT_DYNAMIC_ALLOC

#undef __FSEEK_OPTIMIZATION

#undef __FVWRITE_IN_STREAMIO

#undef __strong_reference

/* Use bitfields in packed structs */
#define __HAVE_BITFIELDS_IN_PACKED_STRUCTS

/* Compiler flag to prevent detecting memcpy/memset patterns */
#define __HAVE_CC_INHIBIT_LOOP_TO_LIBCALL

/* Compiler supports _Complex */
#define __HAVE_COMPLEX

#undef __HAVE_FCNTL

/* IEEE fp funcs available */
#undef __IEEEFP_FUNCS

/* compiler supports INIT_ARRAY sections */
#undef __INIT_FINI_ARRAY

/* Support _init() and _fini() functions */
#undef __INIT_FINI_FUNCS

/* _set_tls and _init_tls functions available */
#undef __THREAD_LOCAL_STORAGE_API

/* Semihost APIs supported */
#define __SEMIHOST

/* math library does not set errno (offering only ieee semantics) */
#define __IEEE_LIBM

#define __IO_FLOAT_EXACT

#define __IO_SMALL_ULTOA

#undef __IO_PERCENT_N

#undef __IO_PERCENT_B

#undef __IO_WCHAR

#define _LITE_EXIT

#define __MALLOC_SMALL_BUCKET 0

#undef __MB_CAPABLE

#undef __MB_EXTENDED_CHARSETS_ALL

#undef __MB_EXTENDED_CHARSETS_UCS

#undef __MB_EXTENDED_CHARSETS_ISO

#undef __MB_EXTENDED_CHARSETS_WINDOWS

#undef __MB_EXTENDED_CHARSETS_JIS

#define __NANO_FORMATTED_IO

#define __NANO_MALLOC

#define _GLOBAL_ATEXIT

#define __SINGLE_THREAD

#define __UNBUF_STREAM_OPT

#define __IO_C99_FORMATS

#undef __IO_LONG_LONG

#undef __IO_LONG_DOUBLE

#undef __IO_MINIMAL_LONG_LONG

#undef __IO_POS_ARGS

#define __IO_DEFAULT 'd'

/* math library sets errno */
#undef __MATH_ERRNO

#undef _WANT_REGISTER_FINI

#define __WIDE_ORIENT

/* chatty assert */
#define __ASSERT_VERBOSE

/* elix level */
#define __ELIX_LEVEL 4

/* Use old math code */
#undef __OBSOLETE_MATH_FLOAT

#undef __OBSOLETE_MATH_DOUBLE

/* Compute static memory area sizes at runtime instead of link time */
#undef __PICOCRT_RUNTIME_SIZE

#endif /* PICOLIBC_H */
