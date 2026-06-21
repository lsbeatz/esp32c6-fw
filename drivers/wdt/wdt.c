#include <stdbool.h>

#include <aspace.h>
#include <mmio.h>

#include <timg/timg_regs.h>

#include <wdt/wdt_regs.h>
#include <wdt/wdt.h>

#define WDT_UNLOCK_KEY (0x50D83AA1)
#define WDT_LOCK_KEY   (0x00000000)

uint32_t wdt_lock(enum wdt_id id)
{
	/* clang-format off */
	uintptr_t addrs[NR_WDT_ID] = {
		[ WDT_ID_MAIN0 ] = TIMG_WDTWPROTECT_REG(TIMG0_BASE),
		[ WDT_ID_MAIN1 ] = TIMG_WDTWPROTECT_REG(TIMG1_BASE),
		[ WDT_ID_RTC   ] = WDT_RWDT_WPROTECT_REG(RTC_WDT_BASE),
		[ WDT_ID_SUPER ] = WDT_SWD_WPROTECT_REG(RTC_WDT_BASE),
	};

	/* clang-format on */

	if (id >= NR_WDT_ID) {
		return 1;
	}

	mmio_write_32(addrs[id], WDT_LOCK_KEY);

	return 0;
}

uint32_t wdt_unlock(enum wdt_id id)
{
	/* clang-format off */
	uintptr_t addrs[NR_WDT_ID] = {
		[ WDT_ID_MAIN0 ] = TIMG_WDTWPROTECT_REG(TIMG0_BASE),
		[ WDT_ID_MAIN1 ] = TIMG_WDTWPROTECT_REG(TIMG1_BASE),
		[ WDT_ID_RTC   ] = WDT_RWDT_WPROTECT_REG(RTC_WDT_BASE),
		[ WDT_ID_SUPER ] = WDT_SWD_WPROTECT_REG(RTC_WDT_BASE),
	};

	/* clang-format on */

	if (id >= NR_WDT_ID) {
		return 1;
	}

	mmio_write_32(addrs[id], WDT_UNLOCK_KEY);

	return 0;
}

struct addr_mask {
	uintptr_t addr;
	uint32_t mask;
};

uint32_t wdt_enable(enum wdt_id id)
{
	/* clang-format off */
	struct {
		uintptr_t addr;
		uint32_t mask_en;
		uint32_t mask_update;
	} values[NR_WDT_ID] = {
		[ WDT_ID_MAIN0 ] = { TIMG_WDTCONFIG0_REG(TIMG0_BASE),    TIMG_WDTCONFIG0_EN_MASK,     TIMG_WDTCONFIG0_CONF_UPDATE_EN_MASK },
		[ WDT_ID_MAIN1 ] = { TIMG_WDTCONFIG0_REG(TIMG1_BASE),    TIMG_WDTCONFIG0_EN_MASK,     TIMG_WDTCONFIG0_CONF_UPDATE_EN_MASK },
		[ WDT_ID_RTC   ] = { WDT_RWDT_CONFIG0_REG(RTC_WDT_BASE), WDT_RWDT_CONFIG0_EN_MASK,    0x0                                 },
		[ WDT_ID_SUPER ] = { WDT_SWD_WPROTECT_REG(RTC_WDT_BASE), WDT_SWD_CONFIG_DISABLE_MASK, 0x0                                 },
	};

	/* clang-format on */

	if (id >= NR_WDT_ID) {
		return 1;
	}

	if (id == WDT_ID_SUPER) {
		mmio_clrbits_32(values[id].addr, values[id].mask_en);
	} else {
		mmio_setbits_32(values[id].addr, values[id].mask_en | values[id].mask_update);
	}

	return 0;
}

uint32_t wdt_disable(enum wdt_id id)
{
	/* clang-format off */
	struct {
		uintptr_t addr;
		uint32_t mask_en;
		uint32_t mask_update;
	} values[NR_WDT_ID] = {
		[ WDT_ID_MAIN0 ] = { TIMG_WDTCONFIG0_REG(TIMG0_BASE),    TIMG_WDTCONFIG0_EN_MASK,     TIMG_WDTCONFIG0_CONF_UPDATE_EN_MASK },
		[ WDT_ID_MAIN1 ] = { TIMG_WDTCONFIG0_REG(TIMG1_BASE),    TIMG_WDTCONFIG0_EN_MASK,     TIMG_WDTCONFIG0_CONF_UPDATE_EN_MASK },
		[ WDT_ID_RTC   ] = { WDT_RWDT_CONFIG0_REG(RTC_WDT_BASE), WDT_RWDT_CONFIG0_EN_MASK,    0x0                                 },
		[ WDT_ID_SUPER ] = { WDT_SWD_WPROTECT_REG(RTC_WDT_BASE), WDT_SWD_CONFIG_DISABLE_MASK, 0x0                                 },
	};

	/* clang-format on */

	if (id >= NR_WDT_ID) {
		return 1;
	}

	if (id == WDT_ID_SUPER) {
		mmio_setbits_32(values[id].addr, values[id].mask_en);
	} else {
		mmio_clrsetbits_32(values[id].addr, values[id].mask_en, values[id].mask_update);
	}

	return 0;
}

uint32_t wdt_set_flashboot_mode(enum wdt_id id, bool enable)
{
	/* clang-format off */
	struct {
		uintptr_t addr;
		uint32_t mask_flashboot_mod_en;
		uint32_t mask_update;
	} values[NR_WDT_ID] = {
		[ WDT_ID_MAIN0 ] = { TIMG_WDTCONFIG0_REG(TIMG0_BASE),    TIMG_WDTCONFIG0_FLASHBOOT_MOD_EN_MASK,  TIMG_WDTCONFIG0_CONF_UPDATE_EN_MASK },
		[ WDT_ID_MAIN1 ] = { TIMG_WDTCONFIG0_REG(TIMG1_BASE),    TIMG_WDTCONFIG0_FLASHBOOT_MOD_EN_MASK,  TIMG_WDTCONFIG0_CONF_UPDATE_EN_MASK },
		[ WDT_ID_RTC   ] = { WDT_RWDT_CONFIG0_REG(RTC_WDT_BASE), WDT_RWDT_CONFIG0_FLASHBOOT_MOD_EN_MASK, 0x0                                 },
	};

	/* clang-format on */

	if (id >= NR_WDT_ID || id == WDT_ID_SUPER) {
		return 1;
	}

	if (enable) {
		mmio_setbits_32(values[id].addr, values[id].mask_flashboot_mod_en | values[id].mask_update);
	} else {
		mmio_clrsetbits_32(values[id].addr, values[id].mask_flashboot_mod_en, values[id].mask_update);
	}

	return 0;
}

uint32_t wdt_feed(enum wdt_id id)
{
	/* clang-format off */
	struct {
		uintptr_t addr;
		uint32_t mask_feed;
	} values[NR_WDT_ID] = {
		[ WDT_ID_MAIN0 ] = { TIMG_WDTFEED_REG(TIMG0_BASE),     0x1                      },
		[ WDT_ID_MAIN1 ] = { TIMG_WDTFEED_REG(TIMG1_BASE),     0x1                      },
		[ WDT_ID_RTC   ] = { WDT_RWDT_FEED_REG(RTC_WDT_BASE),  WDT_RWDT_FEED_FEED_MASK  },
		[ WDT_ID_SUPER ] = { WDT_SWD_CONFIG_REG(RTC_WDT_BASE), WDT_SWD_CONFIG_FEED_MASK },
	};

	/* clang-format on */

	if (id >= NR_WDT_ID) {
		return 1;
	}

	mmio_write_32(values[id].addr, values[id].mask_feed);

	return 0;
}

void wdt_swd_enable_auto_feed(void)
{
	wdt_unlock(WDT_ID_SUPER);
	mmio_setbits_32(WDT_SWD_CONFIG_REG(RTC_WDT_BASE), WDT_SWD_CONFIG_AUTO_FEED_EN_MASK);
	wdt_lock(WDT_ID_SUPER);
}
