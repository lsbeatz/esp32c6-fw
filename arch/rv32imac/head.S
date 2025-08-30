.section ".init"

.global __start
__start:
	csrr a0, mhartid
	li t0, 0
	bne a0, t0, hang

sp_init:
	la sp, 0x40840000

core0_start:
	la a0, __bss_start__
	la a1, __bss_end__

	jal main

hang:
	wfi
	j hang
