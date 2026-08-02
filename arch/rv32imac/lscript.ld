ENTRY(__start)

MEMORY
{
	ROM   (rx)  : ORIGIN = 0x40000000, LENGTH = 320K
	RAM   (rwx) : ORIGIN = 0x40800000, LENGTH = 512K
	FLASH (rx)  : ORIGIN = 0x42000000, LENGTH = 16M
}

SECTIONS
{
	.init :
	{
		KEEP(*(.init))
	} > RAM

	.text :
	{
		*(.text .text.*)
	} > RAM

	.rodata :
	{
		*(.rodata .rodata.*)
	} > RAM

	.sdata :
	{
		*(.sdata .sdata.*)
	} > RAM

	.data :
	{
		*(.data .data.*)
	} > RAM

	. = ALIGN(0x10);
	.bss (NOLOAD) :
	{
		__bss_start__ = .;
		*(.bss .bss.*)
		. = ALIGN(0x4);
		__bss_end__ = .;
	} > RAM

	. = ALIGN(0x10);
	.heap (NOLOAD) :
	{
		__heap_start__ = .;
		*(.heap .heap.*)
		__heap_end__ = .;
	} > RAM

	PROVIDE(__stack_end__  = 0x40840000);
}
