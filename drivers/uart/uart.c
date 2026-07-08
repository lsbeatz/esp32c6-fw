#include <stdbool.h>

#include <mmio.h>
#include <aspace.h>

#include <uart_regs.h>
#include <uart.h>

static bool initialized = false;

static uintptr_t uart_bases[NR_UART_CH] = {
	UART0_BASE,
	UART1_BASE,
};

static void wait_for_update(int ch)
{
	union UART_REG_UPDATE REG_UPDATE;

	do {
		REG_UPDATE.raw = mmio_read_32(UART_REG_UPDATE_REG(uart_bases[ch]));
	} while (REG_UPDATE.UPDATE);
}

int uart_init(int ch)
{
	wait_for_update(ch);

	initialized = true;

	return 0;
}

int uart_exit(int ch)
{
	initialized = false;

	return 0;
}

int uart_tx_char(int ch, char c)
{
	union UART_INT_ST INT_ST;

	wait_for_update(ch);

	mmio_clrbits_32(UART_INT_ENA_REG(uart_bases[ch]), 0x2); // TXFIFO_EMPTY_INT_ENA
	mmio_write_32(UART_FIFO_REG(uart_bases[ch]), c & 0xFF);
	mmio_setbits_32(UART_INT_CLR_REG(uart_bases[ch]), 0x2); // TXFIFO_EMPTY_INT_CLR
	mmio_setbits_32(UART_INT_ENA_REG(uart_bases[ch]), 0x2); // TXFIFO_EMPTY_INT_ENA

	do {
		INT_ST.raw = mmio_read_32(UART_INT_ST_REG(uart_bases[ch]));
	} while (!INT_ST.TXFIFO_EMPTY_INT_ST);

	return 0;
}
