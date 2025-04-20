#ifndef UART_H
#define UART_H

void uart_init(void);
void uart_send(char c);
void uart_puts(const char *s);
void printf(const char *fmt, ...);

#endif
