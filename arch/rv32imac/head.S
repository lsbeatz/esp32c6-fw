.section ".init"

.global __start
__start:
	csrr a0, mhartid
	li t0, 0
	bne a0, t0, hang

sp_init:
	la sp, 0x40840000

core0_start:
	jal main

hang:
	j hang
