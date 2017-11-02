/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.7a Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Landscape lights
Version : 1.0
Date    : 1/5/2010
Author  : Eric Gunnerson
Company : Bellevue WA 98008 US
Comments:


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 8.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#include <delay.h>
#include <stdio.h>

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

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



#define COMMAND_OK 1
#define COMMAND_18 2
#define COMMAND_ON 3
#define COMMAND_OFF 4

char command;
char command_ready = 0;


char state = 0;

void HandleChar(char c)
{
    switch (state)
    {
        case 0: // ready;
            if (c == 'O') state = 1;
            if (c == '1') state = 3;
            if (c == 'S') state = 5;
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

        case 3: // "1"
            if (c == '8') state = 4;
            else state = 0;
            break;

        case 4: // "18"
            if (c == '\r')
            {
                command = COMMAND_18;
                command_ready = 1;
                state = 0;
            }
            else state = 0;
            break;

        case 5: // 'S'
            if (c == '1')
            {
                state = 6;
            }
            else if (c == '0')
            {
                state = 7;
                return;
            }
            else state = 0;
            break;

        case 6: // "S1"
            if (c == '\r')
            {
                command = COMMAND_ON;
                command_ready = 1;
                state = 0;
            }
            else state = 0;
            break;

        case 7: // "S0"
            if (c == '\r')
            {
                command = COMMAND_OFF;
                command_ready = 1;
                state = 0;
            }
            else state = 0;
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

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here

void init(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTA=0x00;
DDRA=0xFF;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// Global enable interrupts
#asm("sei")
}

void D(char v)
{
    PORTA = 255 - v;
}


void SendString(char flash *string)
{
    while (*string != 0)
    {
        putchar(*string);
        string++;
    }
}

char ValidateResponse(char flash *template)
{
    char i = 0;
    while (*template != 0)
    {
        if (*template != getchar())
        {
            return 0;
        }
        template++;
        i++;
    }
    return 1;
}

void WaitCommand()
{
    while (command_ready == 0);
    command_ready = 0;
}


void FindPartner()
{
char x;

    D(0);
    delay_ms(1000);

    SendString("+++");
    WaitCommand();
    if (command == COMMAND_OK)
    {
        D(31);
    }



//    x = ValidateResponse("OK\r");


        // ask for the association mode
    while (0)
    {
    PORTA = 1;




    }

    SendString("ATCN\r");
    WaitCommand();
    //x = ValidateResponse("OK\r");
}




Handshake()
{
        PORTA = 255;
        putsf("EGHome\r");

        PORTA = 254;

        while (rx_counter == 0)
        {

        }
        PORTA = 253;
        WaitCommand();
        if (command == COMMAND_18)
        {
        }

        delay_ms(50);

        //return ValidateResponse("1804\r");
}



void main(void)
{
    char value = 0;

    init();

    FindPartner();
    while (1)
    {
        Handshake();
        putsf("Ready");

        while (1)
        {
            WaitCommand();
            if (command == COMMAND_ON)
            {
                putsf("1");
                D(255);
            }
            else if (command == COMMAND_OFF)
            {
                putsf("0");
                D(0);
            }


        }


    }



while (0)
      {

      while (0)
      {
        delay_ms(50);
        value++;
        PORTA = value;

      }

      while (0)
      {
        putchar(value);
        value++;
      }

      // Place your code here
      delay_ms(1500);
      putchar('+');
      putchar('+');
      putchar('+');
      delay_ms(1000);
      value = getchar();

      if (value == 'O')
      {
           value = getchar();

           putsf("ATCN");
           getchar();
           getchar();

           putsf("Hello");
      while (1)
      {

           value = getchar();
           PORTA = value;
           putchar(value);

      }

      while (0)
      {
        delay_ms(50);
        value++;
        PORTA = value;
        putchar(value);

      }

      }

      PORTA=value;

    delay_ms(1000000000);



      };
}
