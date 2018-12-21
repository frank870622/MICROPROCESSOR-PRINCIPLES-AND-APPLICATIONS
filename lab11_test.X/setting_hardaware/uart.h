#ifndef _UART_H
#define _UART_H
      
void UART_Initialize(void);
char * WriteBuffer();
void PrintChar(unsigned char a);
void PrintBuffer(char* str);
void MyusartRead();

#endif