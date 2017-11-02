/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.7a Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Landscape Lighting System
Version : 
Date    : 9/7/2009
Author  : Eric Gunnerson                  
Company : Bellevue WA 98008 US            
Comments: 


Chip type           : ATtiny861
Clock frequency     : 8.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 128
*****************************************************/
// CodeVisionAVR C Compiler
// (C) 1998-2006 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATtiny861(V)
#pragma used+
sfrb TCCR1E=0;
sfrb DIDR0=1;
sfrb DIDR1=2;
sfrb ADCSRB=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSRA=8;
sfrb ACSRB=9;
sfrb GPIOR0=0xa;
sfrb GPIOR1=0xb;
sfrb GPIOR2=0xc;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb USIBR=0x10;
sfrb USIPP=0x11;
sfrb OCR0B=0x12;
sfrb OCR0A=0x13;
sfrb TCNT0H=0x14;
sfrb TCCR0A=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrb DWDR=0x20;
sfrb WDTCR=0x21;
sfrb PCMSK1=0x22;
sfrb PCMSK0=0x23;
sfrb DT1=0x24;
sfrb TC1H=0x25;
sfrb TCCR1D=0x26;
sfrb TCCR1C=0x27;
sfrb CLKPR=0x28;
sfrb PLLCSR=0x29;
sfrb OCR1D=0x2a;
sfrb OCR1C=0x2b;
sfrb OCR1B=0x2c;
sfrb OCR1A=0x2d;
sfrb TCNT1=0x2e;
sfrb TCCR1B=0x2f;
sfrb TCCR1A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0L=0x32;
sfrb TCCR0B=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb PRR=0x36;
sfrb SPMCSR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb SP=0x3d;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// Needed by the power management functions (sleep.h)
#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_mask=0x18
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
#endasm
/*
  CodeVisionAVR C Compiler
  (C) 1998-2007 Pavel Haiduc, HP InfoTech S.R.L.

  Prototypes for power management functions
*/
// CodeVisionAVR C Compiler
// (C) 1998-2007 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions
// CodeVisionAVR C Compiler
// (C) 1998-2006 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATtiny861(V)
									#pragma used+
#pragma used+
void sleep_enable(void);
void sleep_disable(void);
void idle(void);
void powerdown(void);
void standby(void);
#pragma used-
#pragma library sleep.lib
void init();
// Timer0 runs at 31250 Hz, this value gives us an overflow count of 3125, so
// we get interrupts at 10Hz. 
static int timeRemainingTenths = 0;   // time before lights go off 
int waitCounter = 0;
// Timer 0 overflow interrupt service routine
interrupt [7] void timer0_ovf_isr(void)
{
        // Reinitialize Timer 0 value - 1 second timeout... 
    TCNT0H=0xF3;
    TCNT0L=0xCA;    
        waitCounter++;
              if (timeRemainingTenths > 0)
    {
        if ((timeRemainingTenths % 150 == 0) &&
            (timeRemainingTenths <= 3000))
    	{            
        	PORTA.2 = 0;
    	}
	    else
    	{
        	PORTA.2 = 1;
    	}
	    timeRemainingTenths--;  
    }
    else
    {
        PORTA.2 = 0;
    }
}
void Wait(int seconds)
{
    waitCounter = 0;
        while (waitCounter < seconds * 10)
    {
        ;
    }
}
// Declare your global variables here
void main(void)
{
    int j = 0;
    init();
    while (1)
    {
                                                                                                                            if (PINB.0 == 0)
        {
            PORTA.2 = 1;
    		timeRemainingTenths = 60 * 60 * 10; // 1 hour 
            timeRemainingTenths = 59 * 10;
            Wait(1);
                // Held down, turn off lights...
    		if (PINB.0 == 0)
	    	{
		    	timeRemainingTenths = 0;
                PORTA.2 = 0;
		    			Wait(2); 
	    	}    
        }
    };
} 
void init(void)
{
// Declare your local variables here
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=P 
PORTA=0x02;
DDRA=0xFF; //0x04;
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P 
PORTB=0x0F;
DDRB=0x00;
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 31.250 kHz
// Mode: 16bit top=FFFFh
TCCR0A=0x80;
TCCR0B=0x04;
TCNT0H=0xF3;
TCNT0L=0xCA; 
OCR0A=0x00;
OCR0B=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 0.488 kHz
// Mode: Normal top=OCR1C
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Fault Protection Mode: Off
// Fault Protection Noise Canceler: Off
// Fault Protection triggered on Falling Edge
// Fault Protection triggered by the Analog Comparator: Off
// Timer 1 Overflow Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare D Match Interrupt: Off
// Fault Protection Interrupt: Off
PLLCSR=0x00;
TCCR1A=0x00;
TCCR1B=0x0F;
TCCR1C=0x00;
TCCR1D=0x00;
TCCR1E=0x00;
TC1H=0x00;
TCNT1=0xEF;
OCR1A=0x00;
OCR1B=0x00;
OCR1C=0xFF;
OCR1D=0x00;
DT1=0x00;
// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7, 12-15: Off
// Interrupt on any change on pins PCINT8-11: Off
MCUCR=0x00;
GIMSK=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x02;
// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;
// Analog Comparator initialization
// Analog Comparator: Off
ACSRA=0x80;
// Hysterezis level: 0 mV
ACSRB=0x00;
// Global enable interrupts
#asm("sei")    
}
