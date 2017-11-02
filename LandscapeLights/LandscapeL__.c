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

#include <tiny861.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_mask=0x18
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
#include <sleep.h>

void init();

// Timer0 runs at 31250 Hz, this value gives us an overflow count of 3125, so
// we get interrupts at 10Hz.
#define Timer0H 0xF3
#define Timer0L 0xCA

static int timeRemainingTenths = 0;   // time before lights go off

int waitCounter = 0;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        // Reinitialize Timer 0 value - 1 second timeout...
    TCNT0H=Timer0H;
    TCNT0L=Timer0L;

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
#if test
        j = j + 1;
        if (PINB.0 == 0)
        {
            PORTA = (char) j;
        }
        else
        {
            PORTA = 0;
        }
        Wait(1);

    continue;
#endif

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
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

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
TCNT0H=Timer0H;
TCNT0L=Timer0L;
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

