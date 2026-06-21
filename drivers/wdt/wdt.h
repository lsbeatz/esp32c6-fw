#ifndef WDT_H
#define WDT_H

#include <stdint.h>
#include <stdbool.h>

enum wdt_id {
	WDT_ID_MAIN0,
	WDT_ID_MAIN1,
	WDT_ID_RTC,
	WDT_ID_SUPER,
	NR_WDT_ID,
};

/* Basic WDT Operations */
uint32_t wdt_lock(enum wdt_id id);
uint32_t wdt_unlock(enum wdt_id id);
uint32_t wdt_enable(enum wdt_id id);
uint32_t wdt_disable(enum wdt_id id);
uint32_t wdt_set_flashboot_mode(enum wdt_id id, bool enable);
uint32_t wdt_feed(enum wdt_id id);

void wdt_swd_enable_auto_feed(void);

#endif /* WDT_H */
