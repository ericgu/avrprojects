
#pragma used+
sfrb DIDR=1;
sfrb UBRRH=2;
sfrb UCSRC=3;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb GPIOR0=0x13;
sfrb GPIOR1=0x14;
sfrb GPIOR2=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb PCMSK=0x20;
sfrb WDTCR=0x21;
sfrb TCCR1C=0x22;
sfrb GTCCR=0x23;
sfrb ICR1L=0x24;
sfrb ICR1H=0x25;
sfrw ICR1=0x24;   
sfrb CLKPR=0x26;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;   
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;   
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb TCCR0A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0B=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb OCR0A=0x36;
sfrb SPMCSR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb EIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb OCR0B=0x3c;
sfrb SPL=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

char rx_buffer[8];

unsigned char rx_wr_index,rx_rd_index,rx_counter;

char command;
char command_ready = 0;

char state = 0;

void HandleChar(char c)
{
switch (state)
{
case 0: 
if (c == 'O') state = 1;
if (c == '1') state = 3;
if (c == 'S') state = 5;
break;

case 1: 
if (c == 'K') state = 2;
else state = 0;
break;

case 2: 
if (c == '\r')
{
command = 1;
command_ready = 1;
state = 0;   
}
else state = 0;
break;

case 3: 
if (c == '8') state = 4;
else state = 0;
break;

case 4: 
if (c == '\r')
{
command = 2;
command_ready = 1;
state = 0;
}
else state = 0;
break;  

case 5: 
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

case 6: 
if (c == '\r')
{
command = 3;
command_ready = 1;
state = 0;
}
else state = 0;
break;

case 7: 
if (c == '\r')
{
command = 4;
command_ready = 1;
state = 0;
}
else state = 0;
break;
}
}

bit rx_buffer_overflow;

interrupt [8] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer[rx_wr_index]=data;
if (++rx_wr_index == 8) rx_wr_index=0;
if (++rx_counter == 8)
{
rx_counter=0;
rx_buffer_overflow=1;
};  

HandleChar(data);

};
}

#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == 8) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-

void init(void)
{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0xFF;

PORTD=0x00;
DDRD=0x00;

TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

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

GIMSK=0x00;
MCUCR=0x00;

TIMSK=0x00;

USICR=0x00;

UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x33;

ACSR=0x80;

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
if (command == 1)
{
D(31);
}

while (0)
{
PORTA = 1;

}

SendString("ATCN\r");
WaitCommand();

}

void Handshake()
{
PORTA = 255;
putsf("EGHome\r");

PORTA = 254;

while (rx_counter == 0)
{

}
PORTA = 253;
WaitCommand();
if (command == 2)
{
}

delay_ms(50);

}

void main(void)
{                 
char value = 0;

init();  

while (1)
{
value++;
PORTB = value;
delay_ms(50);

}

FindPartner();
while (1)
{
Handshake();
putsf("Ready");

while (1)
{
WaitCommand();
if (command == 3)
{
putsf("1");
D(255);
}
else if (command == 4)
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
