#include <stdbool.h>
#include "mmio.h"

#define USB_SERIAL_JTAG_BASE (0x6000F000)

#define USB_SERIAL_JTAG_EP1_REG				 (USB_SERIAL_JTAG_BASE + 0x0000)
#define USB_SERIAL_JTAG_EP1_CONF_REG		 (USB_SERIAL_JTAG_BASE + 0x0004)
#define USB_SERIAL_JTAG_INT_RAW_REG			 (USB_SERIAL_JTAG_BASE + 0x0008)
#define USB_SERIAL_JTAG_INT_ST_REG			 (USB_SERIAL_JTAG_BASE + 0x000C)
#define USB_SERIAL_JTAG_INT_ENA_REG			 (USB_SERIAL_JTAG_BASE + 0x0010)
#define USB_SERIAL_JTAG_INT_CLR_REG			 (USB_SERIAL_JTAG_BASE + 0x0014)
#define USB_SERIAL_JTAG_CONF0_REG			 (USB_SERIAL_JTAG_BASE + 0x0018)
#define USB_SERIAL_JTAG_TEST_REG			 (USB_SERIAL_JTAG_BASE + 0x001C)
#define USB_SERIAL_JTAG_JFIFO_ST_REG		 (USB_SERIAL_JTAG_BASE + 0x0020)
#define USB_SERIAL_JTAG_FRAM_NUM_REG		 (USB_SERIAL_JTAG_BASE + 0x0024)
#define USB_SERIAL_JTAG_IN_EP0_ST_REG		 (USB_SERIAL_JTAG_BASE + 0x0028)
#define USB_SERIAL_JTAG_IN_EP1_ST_REG		 (USB_SERIAL_JTAG_BASE + 0x002C)
#define USB_SERIAL_JTAG_IN_EP2_ST_REG		 (USB_SERIAL_JTAG_BASE + 0x0030)
#define USB_SERIAL_JTAG_IN_EP3_ST_REG		 (USB_SERIAL_JTAG_BASE + 0x0034)
#define USB_SERIAL_JTAG_OUT_EP0_ST_REG		 (USB_SERIAL_JTAG_BASE + 0x0038)
#define USB_SERIAL_JTAG_OUT_EP1_ST_REG		 (USB_SERIAL_JTAG_BASE + 0x003C)
#define USB_SERIAL_JTAG_OUT_EP2_ST_REG		 (USB_SERIAL_JTAG_BASE + 0x0040)
#define USB_SERIAL_JTAG_MISC_CONF_REG		 (USB_SERIAL_JTAG_BASE + 0x0044)
#define USB_SERIAL_JTAG_MEM_CONF_REG		 (USB_SERIAL_JTAG_BASE + 0x0048)
#define USB_SERIAL_JTAG_CHIP_RST_REG		 (USB_SERIAL_JTAG_BASE + 0x004C)
#define USB_SERIAL_JTAG_SET_LINE_CODE_W0_REG (USB_SERIAL_JTAG_BASE + 0x0050)
#define USB_SERIAL_JTAG_SET_LINE_CODE_W1_REG (USB_SERIAL_JTAG_BASE + 0x0054)
#define USB_SERIAL_JTAG_GET_LINE_CODE_W0_REG (USB_SERIAL_JTAG_BASE + 0x0058)
#define USB_SERIAL_JTAG_GET_LINE_CODE_W1_REG (USB_SERIAL_JTAG_BASE + 0x005C)
#define USB_SERIAL_JTAG_CONFIG_UPDATE_REG	 (USB_SERIAL_JTAG_BASE + 0x0060)
#define USB_SERIAL_JTAG_SER_AFIFO_CONFIG_REG (USB_SERIAL_JTAG_BASE + 0x0064)
#define USB_SERIAL_JTAG_BUS_RESET_ST_REG	 (USB_SERIAL_JTAG_BASE + 0x0068)
#define USB_SERIAL_JTAG_DATE_REG			 (USB_SERIAL_JTAG_BASE + 0x0080)

union usb_serial_jtag_ep1 {
	uint32_t raw;

	struct {
		uint32_t rdwr_bytes : 8;
		uint32_t rsvd0		: 24;
	};
};

union usb_serial_jtag_ep1_conf {
	uint32_t raw;

	struct {
		uint32_t wr_done		   : 1;
		uint32_t in_ep_data_free   : 1;
		uint32_t out_ep_data_avail : 1;
		uint32_t rsvd0			   : 29;
	};
};

union usb_serial_jtag_int_raw {
	uint32_t raw;

	struct {
		uint32_t jtag_in_flush_int		  : 1;
		uint32_t sof_int				  : 1;
		uint32_t serial_out_recv_pkt_int  : 1;
		uint32_t serial_in_empty_int	  : 1;
		uint32_t pid_err_int			  : 1;
		uint32_t crc5_err_int			  : 1;
		uint32_t crc16_err_int			  : 1;
		uint32_t stuff_err_int			  : 1;
		uint32_t in_token_rec_in_ep1_int  : 1;
		uint32_t usb_bus_reset_int		  : 1;
		uint32_t out_ep1_zero_payload_int : 1;
		uint32_t out_ep2_zero_payload_int : 1;
		uint32_t rts_chg_int			  : 1;
		uint32_t dtr_chg_int			  : 1;
		uint32_t get_line_code_int		  : 1;
		uint32_t set_line_code_int		  : 1;
		uint32_t rsvd0					  : 16;
	};
};

union usb_serial_jtag_int_clr {
	uint32_t raw;

	struct {
		uint32_t jtag_in_flush_int		  : 1;
		uint32_t sof_int				  : 1;
		uint32_t serial_out_recv_pkt_int  : 1;
		uint32_t serial_in_empty_int	  : 1;
		uint32_t pid_err_int			  : 1;
		uint32_t crc5_err_int			  : 1;
		uint32_t crc16_err_int			  : 1;
		uint32_t stuff_err_int			  : 1;
		uint32_t in_token_rec_in_ep1_int  : 1;
		uint32_t usb_bus_reset_int		  : 1;
		uint32_t out_ep1_zero_payload_int : 1;
		uint32_t out_ep2_zero_payload_int : 1;
		uint32_t rts_chg_int			  : 1;
		uint32_t dtr_chg_int			  : 1;
		uint32_t get_line_code_int		  : 1;
		uint32_t set_line_code_int		  : 1;
		uint32_t rsvd0					  : 16;
	};
};

bool is_serial_in_empty(void)
{
	union usb_serial_jtag_int_raw status;
	bool rc = false;

	status.raw = mmio_read_32(USB_SERIAL_JTAG_INT_RAW_REG);

	if (status.serial_in_empty_int) {
		mmio_write_32(USB_SERIAL_JTAG_INT_CLR_REG, status.raw);
		rc = true;
	}

	return rc;
}

bool is_tx_free(void)
{
	union usb_serial_jtag_ep1_conf status;

	status.raw = mmio_read_32(USB_SERIAL_JTAG_EP1_CONF_REG);

	return status.in_ep_data_free == 1;
}

void flush(void)
{
	union usb_serial_jtag_ep1_conf status = { 0 };

	status.wr_done = 0x1;
	mmio_write_32(USB_SERIAL_JTAG_EP1_CONF_REG, status.raw);
}

void send(char c)
{
	union usb_serial_jtag_ep1 fifo = { 0 };

	while (is_serial_in_empty()) {
		;
	}

	while (!is_tx_free()) {
		;
	}

	fifo.rdwr_bytes = (uint32_t)c;
	mmio_write_32(USB_SERIAL_JTAG_EP1_REG, fifo.raw);

	flush();
}

void print(const char *str)
{
	char *c = (char *)str;

	while (*c) {
		send(*c++);
	}
}

#include <aspace.h>

#define TIMG0_WDT_WP_ADDR	   (TIMG0_BASE + 0x0064)
#define TIMG0_WDT_CONFIG0_ADDR (TIMG0_BASE + 0x0048)

#define LP_WDT_WP_ADDR		(RTC_WDT_BASE + 0x0018)
#define LP_WDT_CONFIG0_ADDR (RTC_WDT_BASE + 0x0000)

void init_wdt(void)
{
	uint32_t raw;

	raw = mmio_read_32(TIMG0_WDT_WP_ADDR);
	if (raw != 0x50D83AA1) {
		print("timeg0 Wkey value is not 0x50D83AA1\n");
	}

	mmio_write_32(TIMG0_WDT_WP_ADDR, 0x50D83AA1);

	raw = mmio_read_32(TIMG0_WDT_CONFIG0_ADDR);
	if (raw & (1 << 14)) {
		print("timg0 flashboot_mode_en is enabled\n");
	}

	if (raw & (1 << 31)) {
		print("timg0 wdt_en is enabled\n");
	}

	raw &= ~(1 << 14);
	raw &= ~(1 << 31);
	raw &= (1 << 22);

	mmio_write_32(TIMG0_WDT_CONFIG0_ADDR, raw);
	mmio_write_32(TIMG0_WDT_WP_ADDR, 0);

	raw = mmio_read_32(LP_WDT_WP_ADDR);
	if (raw != 0x50D83AA1) {
		print("LP Wkey value is not 0x50D83AA1\n");
	}

	mmio_write_32(LP_WDT_WP_ADDR, 0x50D83AA1);

	raw = mmio_read_32(LP_WDT_CONFIG0_ADDR);
	if (raw & (1 << 12)) {
		print("LP flashboot_mode_en is enabled\n");
	}

	if (raw & (1 << 31)) {
		print("LP wdt_en is enabled\n");
	}

	raw &= ~(1 << 12);
	raw &= ~(1 << 31);

	mmio_write_32(LP_WDT_CONFIG0_ADDR, raw);

	mmio_write_32(LP_WDT_WP_ADDR, 0);
}

int main(void)
{
	int cnt = 0;

	init_wdt();

	print("Hello World\n");

	while (!is_serial_in_empty()) {
		cnt++;
	}

	while (cnt--) {
		print("c\n");
	}

	return 0;
}
