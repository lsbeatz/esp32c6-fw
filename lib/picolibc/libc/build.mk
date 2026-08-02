PATH_LIB_PICOLIBC_LIBC := ${PATH_LIB}/picolibc/libc

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_ARGZ},y)
PATH_LIB_PICOLIBC_LIBC_ARGZ := ${PATH_LIB_PICOLIBC_LIBC}/argz

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_ARGZ}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_ARGZ}/, \
		argz_add.c \
		argz_add_sep.c \
		argz_append.c \
		argz_count.c \
		argz_create.c \
		argz_create_sep.c \
		argz_delete.c \
		argz_extract.c \
		argz_insert.c \
		argz_next.c \
		argz_replace.c \
		argz_stringify.c \
		buf_findstr.c \
		envz_add.c \
		envz_entry.c \
		envz_get.c \
		envz_merge.c \
		envz_remove.c \
		envz_strip.c \
	)
endif # CONFIG_LIB_PICOLIBC_LIBC_ARGZ

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_CTYPE},y)
PATH_LIB_PICOLIBC_LIBC_CTYPE := ${PATH_LIB_PICOLIBC_LIBC}/ctype

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_CTYPE}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_CTYPE}/, \
		caseconv.c \
		ctype_.c \
		ctype_class.c \
		ctype_table.c \
		ctype_wide.c \
		isalnum.c \
		isalnum_l.c \
		isalpha.c \
		isalpha_l.c \
		isascii.c \
		isascii_l.c \
		isblank.c \
		isblank_l.c \
		iscntrl.c \
		iscntrl_l.c \
		isdigit.c \
		isdigit_l.c \
		isgraph.c \
		isgraph_l.c \
		islower.c \
		islower_l.c \
		isprint.c \
		isprint_l.c \
		ispunct.c \
		ispunct_l.c \
		isspace.c \
		isspace_l.c \
		isupper.c \
		isupper_l.c \
		iswalnum.c \
		iswalnum_l.c \
		iswalpha.c \
		iswalpha_l.c \
		iswblank.c \
		iswblank_l.c \
		iswcntrl.c \
		iswcntrl_l.c \
		iswctype.c \
		iswctype_l.c \
		iswdigit.c \
		iswdigit_l.c \
		iswgraph.c \
		iswgraph_l.c \
		iswlower.c \
		iswlower_l.c \
		iswprint.c \
		iswprint_l.c \
		iswpunct.c \
		iswpunct_l.c \
		iswspace.c \
		iswspace_l.c \
		iswupper.c \
		iswupper_l.c \
		iswxdigit.c \
		iswxdigit_l.c \
		isxdigit.c \
		isxdigit_l.c \
		toascii.c \
		toascii_l.c \
		tolower.c \
		tolower_l.c \
		toupper.c \
		toupper_l.c \
		towctrans.c \
		towctrans_l.c \
		towlower.c \
		towlower_l.c \
		towupper.c \
		towupper_l.c \
		wctrans.c \
		wctrans_l.c \
		wctype.c \
		wctype_l.c \
	)
endif # CONFIG_LIB_PICOLIBC_LIBC_CTYPE

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_ERRNO},y)
PATH_LIB_PICOLIBC_LIBC_ERRNO := ${PATH_LIB_PICOLIBC_LIBC}/errno

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_ERRNO}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_ERRNO}/, \
		errno.c \
	)
endif # CONFIG_LIB_PICOLIBC_LIBC_ERRNO

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_LOCALE},y)
PATH_LIB_PICOLIBC_LIBC_LOCALE := ${PATH_LIB_PICOLIBC_LIBC}/locale

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_LOCALE}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_LOCALE}/, \
		duplocale.c \
		freelocale.c \
		getlocalename_l.c \
		localeconv.c \
		localedata.c \
		locale_ctype_ptr.c \
		locale_ctype_ptr_l.c \
		locale_mb_cur_max.c \
		locale_names.c \
		newlocale.c \
		nl_langinfo.c \
		setlocale.c \
		timedata.c \
		uselocale.c \
	)
endif # CONFIG_LIB_PICOLIBC_LIBC_LOCALE

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_MACHINE},y)
# TBD
endif # CONFIG_LIB_PICOLIBC_LIBC_MACHINE

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_MISC},y)
PATH_LIB_PICOLIBC_LIBC_MISC := ${PATH_LIB_PICOLIBC_LIBC}/misc

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_MISC}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_MISC}/, \
		dso_handle.c \
		getauxval.c \
		ffs.c \
		fini.c \
		init.c \
		inittls.c \
		lock.c \
		unctrl.c \
	)
endif # CONFIG_LIB_PICOLIBC_LIBC_MISC

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_SSP},y)
PATH_LIB_PICOLIBC_LIBC_SSP := ${PATH_LIB_PICOLIBC_LIBC}/ssp

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_SSP}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_SSP}/, \
		chk_fail.c \
		gets_chk.c \
		memcpy_chk.c \
		memmove_chk.c \
		mempcpy_chk.c \
		memset_chk.c \
		snprintf_chk.c \
		sprintf_chk.c \
		stack_protector.c \
		stpcpy_chk.c \
		stpncpy_chk.c \
		strcat_chk.c \
		strcpy_chk.c \
		strncat_chk.c \
		strncpy_chk.c \
		vsnprintf_chk.c \
		vsprintf_chk.c \
	)
endif # CONFIG_LIB_PICOLIBC_LIBC_SSP

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_STDIO},y)
PATH_LIB_PICOLIBC_LIBC_STDIO := ${PATH_LIB_PICOLIBC_LIBC}/stdio

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_STDIO}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_STDIO}/, \
		asnprintf.c \
		asprintf.c \
		atold_engine.c \
		atomic_load.c \
		atomic_store.c \
		bufio.c \
		bufio_close.c \
		bufio_close_nf.c \
		bufio_exit_flush.c \
		bufio_setvbuf.c \
		clearerr.c \
		compare_exchange.c \
		dprintf.c \
		dtox_engine.c \
		ecvt.c \
		ecvtf.c \
		ecvtf_r.c \
		ecvtl.c \
		ecvtl_r.c \
		ecvt_r.c \
		exchange.c \
		fclose.c \
		fcvt.c \
		fcvtf.c \
		fcvtf_r.c \
		fcvtl.c \
		fcvtl_r.c \
		fcvt_r.c \
		fdevopen.c \
		fdopen.c \
		feof.c \
		ferror.c \
		fflush.c \
		fgetc.c \
		fgets.c \
		fgetwc.c \
		fgetws.c \
		fileno.c \
		filestrget.c \
		filestrputalloc.c \
		filestrput.c \
		filewstrget.c \
		flockfile.c \
		fmemopen.c \
		open_memstream.c \
		fopen.c \
		fprintf.c \
		fputc.c \
		fputs.c \
		fputwc.c \
		fputws.c \
		fread.c \
		freopen.c \
		fscanf.c \
		fseek.c \
		fseeko.c \
		ftell.c \
		ftello.c \
		ftox_engine.c \
		ftrylockfile.c \
		funlockfile.c \
		fopencookie.c \
		funopen.c \
		fwide.c \
		fwprintf.c \
		fwrite.c \
		fwscanf.c \
		gcvt.c \
		gcvtf.c \
		gcvtl.c \
		getchar.c \
		getdelim.c \
		getline.c \
		gets.c \
		getwchar.c \
		ldtoa_engine.c \
		ldtox_engine.c \
		matchcaseprefix.c \
		mktemp.c \
		pclose.c \
		perror.c \
		popen.c \
		printf.c \
		putchar.c \
		puts.c \
		putwchar.c \
		remove.c \
		rewind.c \
		scanf.c \
		setbuf.c \
		setbuffer.c \
		setlinebuf.c \
		setvbuf.c \
		sflags.c \
		snprintf.c \
		snprintfd.c \
		snprintff.c \
		sprintf.c \
		sprintfd.c \
		sprintff.c \
		sscanf.c \
		strfromd.c \
		strfromf.c \
		strfroml.c \
		strtod.c \
		strtod_l.c \
		strtof.c \
		strtof_l.c \
		strtoimax.c \
		strtoimax_l.c \
		strtol.c \
		strtold.c \
		strtold_l.c \
		strtol_l.c \
		strtoll.c \
		strtoll_l.c \
		strtoul.c \
		strtoul_l.c \
		strtoull.c \
		strtoull_l.c \
		strtoumax.c \
		strtoumax_l.c \
		swprintf.c \
		swprintfd.c \
		swscanf.c \
		tmpfile.c \
		tmpnam.c \
		ungetc.c \
		ungetwc.c \
		vasnprintf.c \
		vasprintf.c \
		vdprintf.c \
		vffprintf.c \
		vffscanf.c \
		vfiprintf.c \
		vfiscanf.c \
		vflprintf.c \
		vflscanf.c \
		vfmprintf.c \
		vfmscanf.c \
		vfprintf.c \
		vfscanf.c \
		vfwprintf.c \
		vfwscanf.c \
		vprintf.c \
		vscanf.c \
		vsnprintf.c \
		vsprintf.c \
		vsscanf.c \
		vswprintf.c \
		vswscanf.c \
		vwprintf.c \
		vwscanf.c \
		wcstod.c \
		wcstod_l.c \
		wcstof.c \
		wcstof_l.c \
		wcstoimax.c \
		wcstoimax_l.c \
		wcstol.c \
		wcstold.c \
		wcstold_l.c \
		wcstol_l.c \
		wcstoll.c \
		wcstoll_l.c \
		wcstoul.c \
		wcstoul_l.c \
		wcstoull.c \
		wcstoull_l.c \
		wcstoumax.c \
		wcstoumax_l.c \
		wprintf.c \
		wscanf.c \
		sprintf_s.c \
		vfprintf_s.c \
		vsnprintf_s.c \
	)

ifeq (${CONFIG_LIB_PICOLIBC_IO_FLOAT_EXACT},y)
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_STDIO}/, \
		atod_ryu.c \
		atof_ryu.c \
		dtoa_ryu.c \
		ftoa_ryu.c \
		ryu_divpow2.c \
		ryu_log10.c \
		ryu_log2pow5.c \
		ryu_pow5bits.c \
		ryu_table.c \
		ryu_umul128.c \
	)
else
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_STDIO}/, \
		atod_engine.c \
		atof_engine.c \
		dtoa_engine.c \
		ftoa_engine.c \
	)
endif # CONFIG_LIB_PICOLIBC_IO_FLOAT_EXACT
endif # CONFIG_LIB_PICOLIBC_LIBC_STDIO

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_STDLIB},y)
PATH_LIB_PICOLIBC_LIBC_STDLIB := ${PATH_LIB_PICOLIBC_LIBC}/stdlib

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_STDLIB}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_STDLIB}/, \
		a64l.c \
		abort.c \
		abs.c \
		aligned_alloc.c \
		arc4random.c \
		arc4random_uniform.c \
		assert.c \
		assert_func.c \
		assert_no_arg.c \
		atof.c \
		atoff.c \
		atoi.c \
		atol.c \
		atoll.c \
		btowc.c \
		div.c \
		drand48.c \
		ejtouc.c \
		environ.c \
		eprintf.c \
		erand48.c \
		_Exit.c \
		_findenv.c \
		getenv.c \
		getopt.c \
		getsubopt.c \
		imaxabs.c \
		imaxdiv.c \
		itoa.c \
		jitouc.c \
		jrand48.c \
		l64a.c \
		labs.c \
		lcong48.c \
		ldiv.c \
		llabs.c \
		lldiv.c \
		lrand48.c \
		mblen.c \
		mbrlen.c \
		mbrtowc.c \
		mbsinit.c \
		mbsnrtowcs.c \
		mbsrtowcs.c \
		mbstowcs.c \
		mbtowc.c \
		mbtowc_r.c \
		mrand48.c \
		nrand48.c \
		putenv.c \
		rand48.c \
		rand.c \
		random.c \
		rand_r.c \
		reallocarray.c \
		reallocf.c \
		rpmatch.c \
		sb_charsets.c \
		seed48.c \
		setenv.c \
		sjtouc.c \
		srand.c \
		srand48.c \
		srandom.c \
		system.c \
		uctoji.c \
		uctoej.c \
		uctosj.c \
		unsetenv.c \
		utoa.c \
		wcrtomb.c \
		wcsnrtombs.c \
		wcsrtombs.c \
		wcstombs.c \
		wctob.c \
		wctomb.c \
		wctomb_r.c \
		atexit.c \
		exit.c \
		exitprocs.c \
		onexit.c \
		cxa-atexit.c \
		set_constraint_handler_s.c \
		ignore_handler_s.c \
	)
ifeq (${CONFIG_LIB_PICOLIBC_ENABLE_MALLOC},y)
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_STDLIB}/, \
		calloc.c \
		free.c \
		getpagesize.c \
		mallinfo.c \
		malloc.c \
		malloc-stats.c \
		malloc-usable-size.c \
		mallopt.c \
		memalign.c \
		posix-memalign.c \
		pvalloc.c \
		realloc.c \
		valloc.c \
	)
endif # CONFIG_LIB_PICOLIBC_ENABLE_MALLOC
endif # CONFIG_LIB_PICOLIBC_LIBC_STDLIB

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_STRING},y)
PATH_LIB_PICOLIBC_LIBC_STRING := ${PATH_LIB_PICOLIBC_LIBC}/string

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_STRING}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_STRING}/, \
		bcmp.c \
		bcopy.c \
		bzero.c \
		explicit_bzero.c \
		ffsl.c \
		ffsll.c \
		fls.c \
		flsl.c \
		flsll.c \
		gnu_basename.c \
		index.c \
		memccpy.c \
		memchr.c \
		memcmp.c \
		memcpy.c \
		memmem.c \
		memmove.c \
		mempcpy.c \
		memrchr.c \
		memset.c \
		memset_explicit.c \
		rawmemchr.c \
		rindex.c \
		stpcpy.c \
		stpncpy.c \
		strcasecmp.c \
		strcasecmp_l.c \
		strcasestr.c \
		strcat.c \
		strchr.c \
		strchrnul.c \
		strcoll.c \
		strcoll_l.c \
		strcmp.c \
		strcpy.c \
		strcspn.c \
		strdup.c \
		strerror.c \
		strerror_r.c \
		strlcat.c \
		strlcpy.c \
		strlen.c \
		strlwr.c \
		strncasecmp.c \
		strncasecmp_l.c \
		strncat.c \
		strncmp.c \
		strncpy.c \
		strndup.c \
		strnlen.c \
		strnstr.c \
		strpbrk.c \
		strrchr.c \
		strsep.c \
		strsignal.c \
		strspn.c \
		strstr.c \
		strtok.c \
		strtok_r.c \
		strupr.c \
		strverscmp.c \
		strxfrm.c \
		strxfrm_l.c \
		swab.c \
		timingsafe_bcmp.c \
		timingsafe_memcmp.c \
		wcpcpy.c \
		wcpncpy.c \
		wcscasecmp.c \
		wcscasecmp_l.c \
		wcscat.c \
		wcschr.c \
		wcscmp.c \
		wcscoll.c \
		wcscoll_l.c \
		wcscpy.c \
		wcscspn.c \
		wcsdup.c \
		wcslcat.c \
		wcslcpy.c \
		wcslen.c \
		wcsncasecmp.c \
		wcsncasecmp_l.c \
		wcsncat.c \
		wcsncmp.c \
		wcsncpy.c \
		wcsnlen.c \
		wcspbrk.c \
		wcsrchr.c \
		wcsspn.c \
		wcsstr.c \
		wcstok.c \
		wcswidth.c \
		wcsxfrm.c \
		wcsxfrm_l.c \
		wcwidth.c \
		wmemchr.c \
		wmemcmp.c \
		wmemcpy.c \
		wmemmove.c \
		wmempcpy.c \
		wmemset.c \
		xpg_strerror_r.c \
		memcpy_s.c \
		memmove_s.c \
		memset_s.c \
		strcat_s.c \
		strcpy_s.c \
		strerror_s.c \
		strerrorlen_s.c \
		strncat_s.c \
		strncpy_s.c \
		strnlen_s.c \
	)
endif # CONFIG_LIB_PICOLIBC_LIBC_STRING

ifeq (${CONFIG_LIB_PICOLIBC_LIBC_TIME},y)
PATH_LIB_PICOLIBC_LIBC_TIME := ${PATH_LIB_PICOLIBC_LIBC}/time

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC_TIME}
srcs-y += $(addprefix ${PATH_LIB_PICOLIBC_LIBC_TIME}/, \
		asctime.c \
		asctime_r.c \
		clock.c \
		ctime.c \
		ctime_r.c \
		difftime.c \
		getdate.c \
		getdate_r.c \
		gmtime.c \
		gmtime_r.c \
		lcltime.c \
		lcltime_r.c \
		lcltime_buf.c \
		mktime.c \
		month_lengths.c \
		strftime.c \
		strptime.c \
		strptime_l.c \
		time.c \
		tzcalc_limits.c \
		tzset.c \
		tzvars.c \
		wcsftime.c \
	)
endif # CONFIG_LIB_PICOLIBC_LIBC_TIME

INCLUDES += ${PATH_LIB_PICOLIBC_LIBC}/include
