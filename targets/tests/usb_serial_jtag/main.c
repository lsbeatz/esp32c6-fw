#include <stdio.h>

#include <usb_serial_jtag.h>
#include <wdt.h>

void init_wdt(void)
{
	wdt_unlock(WDT_ID_RTC);
	wdt_set_flashboot_mode(WDT_ID_RTC, false);
	wdt_disable(WDT_ID_RTC);
	wdt_lock(WDT_ID_RTC);

	wdt_unlock(WDT_ID_MAIN0);
	wdt_set_flashboot_mode(WDT_ID_MAIN0, false);
	wdt_disable(WDT_ID_MAIN0);
	wdt_lock(WDT_ID_MAIN0);

	wdt_swd_enable_auto_feed();
}

int stub_putc(char c)
{
	usb_serial_jtag_putc(c);

	return (int)c;
}

int main(void)
{
	init_wdt();

	printf("Test Usb_Serial_Jtag\n");

	return 0;
}
