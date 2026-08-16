#include <stdbool.h>

#include <aspace.h>
#include <mmio.h>

#include <usb_serial_jtag_regs.h>
#include <usb_serial_jtag.h>

static bool is_usb_serial_tx_fifo_free(void)
{
	union usb_serial_jtag_ep1_conf status;

	status.raw = mmio_read_32(USB_SERIAL_JTAG_EP1_CONF_REG(USB_SERIAL_JTAG_BASE));

	return status.in_ep_data_free == 1;
}

void usb_serial_jtag_putc(char c)
{
	union usb_serial_jtag_ep1 fifo = {
		.rdwr_byte = (uint8_t)c,
	};

	while (!is_usb_serial_tx_fifo_free()) {
		;
	}

	mmio_write_32(USB_SERIAL_JTAG_EP1_REG(USB_SERIAL_JTAG_BASE), fifo.raw);

	usb_serial_jtag_flush();
}

void usb_serial_jtag_flush(void)
{
	union usb_serial_jtag_int_raw status;

	mmio_write_32(USB_SERIAL_JTAG_EP1_CONF_REG(USB_SERIAL_JTAG_BASE), USB_SERIAL_JTAG_EP1_CONF_WR_DONE_MASK);

	do {
		status.raw = mmio_read_32(USB_SERIAL_JTAG_INT_RAW_REG(USB_SERIAL_JTAG_BASE));
	} while (!status.serial_in_empty_int_raw);

	mmio_write_32(USB_SERIAL_JTAG_INT_CLR_REG(USB_SERIAL_JTAG_BASE),
				  USB_SERIAL_JTAG_INT_CLR_JTAG_IN_FLUSH_INT_CLR_MASK);
}
