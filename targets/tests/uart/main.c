#include <uart.h>
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

int main(void)
{
	char str[12] = "Hello World\n";

	init_wdt();

	uart_init(0);

	for (int i = 0; i < 12; i++) {
		uart_tx_char(0, str[i]);
	}

	uart_exit(0);

	return 0;
}
