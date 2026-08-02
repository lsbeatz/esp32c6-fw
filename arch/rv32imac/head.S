.section ".init"

.global __start
__start:
	csrr a0, mhartid
	li t0, 0
	bne a0, t0, hang

sp_init:
	la sp, 0x40840000

bss_init:
	la   t0, __bss_start__
	la   t1, __bss_end__
1:
	bgeu t0, t1, core0_start
	sw   zero, 0(t0)
	addi t0, t0, 4
	j    1b

core0_start:
	jal main

hang:
	j hang
