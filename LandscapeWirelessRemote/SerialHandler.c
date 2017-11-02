#include <tiny2313.h>
#include <delay.h>  
#include <stdio.h>
#include "project.h"

//#define RXB8 1
//#define TXB8 0
//#define UPE 2
#define OVR 3
//#define FE 4
//#define UDRE 5
//#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif


char command;
char command_ready = 0;
 

char state = 0;

// Receive EG0 (off) or EG1 (on) commands from the base station...

void HandleChar(char c)
{
    putchar(c);
    switch (state)
    {
        case 0: // ready;
            if (c == 'O') state = 1;
            if (c == 'E') state = 3;
            break;
            
        case 1: // "O"   
            if (c == 'K') state = 2;
            else state = 0;
            break;
            
        case 2: // "OK"
            if (c == '\r')
            {
                command = COMMAND_OK;
                command_ready = 1;
                state = 0;   
            }
            else state = 0;
            break;

        case 3: // "E"   
            if (c == 'G') state = 4;
            else state = 0;
            break;

           
        case 4: // 'EG'
            if (c == '1')
            {
                SetLightState(1);
                LinkDetected();
            }
            else if (c == '0') 
            {
                SetLightState(0);
                LinkDetected();
            }
            state = 0;
            break;
    }
}

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
   if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };  

      HandleChar(data);

   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif