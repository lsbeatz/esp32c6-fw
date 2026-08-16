#ifndef USB_SERIAL_JTAG_H
#define USB_SERIAL_JTAG_H

#include <stdint.h>

void usb_serial_jtag_putc(char c);
void usb_serial_jtag_flush(void);

#endif /* USB_SERIAL_JTAG_H */
