/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.7a Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Tree lights
Version : 1.0
Date    : 11/26/2008
Author  : Eric Gunnerson                  
Company : Bellevue WA 98008 US            
Comments: 
15-channel 5 color tree lights.


Chip type           : ATtiny2313V
Clock frequency     : 8.000000 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 32
*****************************************************/
// CodeVisionAVR C Compiler
// (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATtiny2313
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
sfrw ICR1=0x24;   // 16 bit access
sfrb CLKPR=0x26;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;   // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;   // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
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
// Interrupt vectors definitions
// for compatibility with the interrupt vector names from Atmel's datasheet
// Needed by the power management functions (sleep.h)
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
//const int DIM_LEVELS = 16;
//const int LEVELS_TO_SKIP = 2;
//eeprom int g_timerDelays[] = { 1390, 590, 480, 420, 390, 360, 360, 350, 360, 370, 380, 420, 480, 600, 1390};
const int DIM_LEVELS = 32;
const int LEVELS_TO_SKIP = 4;
eeprom int g_timerDelays[] = { 960, 400, 320, 270, 240, 230, 210, 200, 190, 180, 190, 170, 180, 170, 170, 170, 170, 180, 170, 180, 180, 180, 200, 200, 210, 220, 240, 280, 310, 410, 960};
//const int DIM_LEVELS = 64;
//const int LEVELS_TO_SKIP = 16;
//eeprom short int g_timerDelays[] = {670, 280, 217, 184, 164, 149, 139, 130, 123, 118, 113, 109, 106, 102, 100, 98, 97, 94, 93, 91, 91, 89, 89, 87, 87, 86, 85, 85, 85, 85, 85, 84, 85, 84, 85, 85, 85, 87, 87, 87, 89, 89, 91, 91, 93, 95, 95, 98, 101, 103, 105, 109, 113, 118, 123, 130, 139, 149, 165, 184, 217, 280, 677 };
char g_timerDelayIndex;
const char SLOWDOWN_FACTOR = 10;
char g_slowdownCounter;  
//char g_portBValue = 0;
char g_count = 0;
char g_currentValue[15];
char g_deltaValue[15];
char g_deltaCount;
char g_deltaValueNext[15];
char g_deltaCountNext = 255;
// 33 K / 2.2K value
//#define INTERRUPT_TO_ACTUAL_ZC_COUNT 160
// 33 K / 4.4K value  
void AllOff();
void UpdateDimValues();
void Twinkle();
void ColorSwitch();
void WaveUp();
void LeftRight();
void CopyValuesToOutput();
void InitValues();                         
void SpinWaitClearAndPause(char pauseCount);
/*
 * Note: The zero-crossing signal is from a switching power supply and is therefore more than a bit noisy. The code therefore turns off the zc interrupt until the end of the 
 * dimming cycle and then turns it back on again. 
*/
// External interrupt from zero-crossing signal...
interrupt [3] void ext_int1_isr(void)
{
                // Wait until we get to actual zero cross. 
    TCNT0 = 0xFF - 50;
    TIFR = 0x02;    // clear Bit 1 – TOV0: Timer/Counter0 Overflow Flag
        TIMSK |= 0x02;   // Turn on timer 0 interrupt.
//    PORTB = 0XFF;
}    
// Timer 0 overflow denotes actual zero crossing...
interrupt [7] void timer0_ovf_isr(void)
{
    int i;
        #asm("cli")
//    PORTB = 0x00;
    TCNT1 = 0XFFFF - g_timerDelays[0];
    TIFR = 0x80;    // clear bit 7 - TOV1: Timer/counter1 overflow Flag
    TIMSK &= ~(0x02);   // turn off timer 0 interrupt
    TIMSK |= 0x80;   // interrupt on timer 1 only...     
    g_timerDelayIndex = 31; 
        g_count = (g_count + 1) % 16;
    if (g_count == 0)
    {
        for (i = 0; i < 15; i++)
        {    
            //g_currentValue[i] = (g_currentValue[i] + 1) % (DIM_LEVELS);
        }
        //g_portBValue = (g_portBValue + 1) % (DIM_LEVELS - LEVELS_TO_SKIP);
    }
    //TurnOnChannels();
    CopyValuesToOutput();
        #asm("sei")
}
// Timer 1 overflow handles dimming levels. 
interrupt [6] void timer1_ovf_isr(void)
{
    #asm("cli")
    g_timerDelayIndex--;
                    // if done, we're done.
    if (g_timerDelayIndex == LEVELS_TO_SKIP)
    {
            // reset watchdog timer 
        #asm("wdr")
               // turn everything off...
        TIMSK &= ~(0x80);
        GIMSK = 0x80;   // turn on external zero-crossing interrupt again...
        EIFR = 0x80;   // clear the interrupt bit so it doesn't trigger right now...
                  AllOff();
        UpdateDimValues();
    }
    else
    {
        //TurnOnChannels();
                TCNT1 = 0XFFFF - g_timerDelays[g_timerDelayIndex];
        CopyValuesToOutput();
    }
    #asm("sei")
}
// 
void UpdateDimValues()
{
    int i;
        g_slowdownCounter++;
    if (g_slowdownCounter < SLOWDOWN_FACTOR)
    {
        return;
    }
        g_slowdownCounter = 0;
            for (i = 0; i < 15; i++)
    {
        g_currentValue[i] += g_deltaValue[i];
    }    
    g_deltaCount--;
                // When the deltaCount is zero, we're done with this specific
        // atom. We'll get the next one and tell the main loop to generate
        // the next atom...
            if (g_deltaCount == 0)
    {
        for (i = 0; i < 15; i++)
        {
            g_deltaValue[i] = g_deltaValueNext[i];
        }
        g_deltaCount = g_deltaCountNext;
        g_deltaCountNext = 0;
   }  
}
                                    void CopyValuesToOutput()
{
    // We need 15 bits.
    // We use PB0-PB7 (8 bits)
    // PD0-PD2 (3 bits)
    // PD4-PD6 (3 bits)
    // PA0 (1 bit)
    // (next time pick a chip with more ports!
        PORTA.0 = ((g_currentValue[0] == g_timerDelayIndex) ? 1 : 0);
    PORTD.4 = ((g_currentValue[1] == g_timerDelayIndex) ? 1 : 0);
    PORTD.5 = ((g_currentValue[2] == g_timerDelayIndex) ? 1 : 0);
    PORTD.6 = ((g_currentValue[3] == g_timerDelayIndex) ? 1 : 0);
    PORTB.0 = ((g_currentValue[4] == g_timerDelayIndex) ? 1 : 0);
    PORTB.1 = ((g_currentValue[5] == g_timerDelayIndex) ? 1 : 0);
    PORTB.2 = ((g_currentValue[6] == g_timerDelayIndex) ? 1 : 0);
    PORTB.3 = ((g_currentValue[7] == g_timerDelayIndex) ? 1 : 0);
    PORTB.4 = ((g_currentValue[8] == g_timerDelayIndex) ? 1 : 0);
    PORTB.5 = ((g_currentValue[9] == g_timerDelayIndex) ? 1 : 0);
    PORTB.6 = ((g_currentValue[10] == g_timerDelayIndex) ? 1 : 0);
    PORTB.7 = ((g_currentValue[11] == g_timerDelayIndex) ? 1 : 0);
    PORTD.0 = ((g_currentValue[12] == g_timerDelayIndex) ? 1 : 0);
    PORTD.1 = ((g_currentValue[13] == g_timerDelayIndex) ? 1 : 0);
    PORTA.1 = ((g_currentValue[14] == g_timerDelayIndex) ? 1 : 0);
}
void AllOff()
{    
    // We need 15 bits.
    // We use PB0-PB7 (8 bits)
    // PD0-PD2 (3 bits)
    // PD4-PD6 (3 bits)
    // PA0 (1 bit)
    // (next time pick a chip with more ports!
        PORTB = 0x00;
    PORTD.0 = 0;
    PORTD.1 = 0;
    PORTD.4 = 0;
    PORTD.5 = 0;
    PORTD.6 = 0;
    PORTA.0 = 0;
    PORTA.1 = 0;
}
// Declare your global variables here
void main(void)
{
// Declare your local variables here
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x80;
// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
// Input/Output Ports initialization
// Port A initialization
// Func2=Out Func1=Out Func0=Out 
// State2=0 State1=0 State0=0 
PORTA=0x07;
DDRA=0x03;
PORTA=0x07;
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;
// Port D initialization
// Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=Out 
// State6=0 State5=0 State4=0 State3=T State2=T State1=0 State0=0 
PORTD=0x00;
DDRD=0x73;
PORTD=0XFF; 
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x03;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x02;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
// External Interrupt(s) initialization
// INT0: Off
// INT1: On
// INT1 Mode: Falling Edge
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x80;
MCUCR=0x0C;
EIFR=0x80;  
// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/128k
// Watchdog Timer interrupt: Off
#pragma optsize-
WDTCR=0x1E;
WDTCR=0x0E;
#pragma optsize+
InitValues();
// Global enable interrupts
#asm("sei")
    while (1)
    {
        //DimRandom();
        Twinkle();     
        SpinWaitClearAndPause(12);
        ColorSwitch();
        SpinWaitClearAndPause(12);
        WaveUp();
        SpinWaitClearAndPause(12);
        LeftRight();
        SpinWaitClearAndPause(12);
    }
}             
void InitValues()
{
    char i;
        for (i = 0; i < 15; i++)
    {
        g_currentValue[i] = 0;
        g_deltaValue[i] = 0;
        g_deltaValueNext[i] = 0;
    }
    g_deltaCount = 10;
    g_deltaCountNext = 5; 
                     } 
void SpinWait()
{
    while (g_deltaCountNext != 0)
    {
    }
}
void SpinWaitClearAndPause(char pauseCount)
{
    char i;
        SpinWait();
    for (i = 0; i < 15; i++)
    {
        g_deltaValueNext[i] = 0;
    }
    g_deltaCountNext = pauseCount;
}
eeprom char vOrdered[] = { 14, 9, 8, 13, 7, 12, 6, 5, 11, 4, 3, 10, 2, 1, 0 };
void SetDeltaIfValid(int index, char dimValue)
{
    if (index < 0 || index > 14)
    {
        return;
    }
   g_deltaValueNext[vOrdered[index]] = dimValue;
}
void SetDimSet(char* pArray, int count, char dimValue)
{
    char i;
    for (i = 0; i < count; i++)
    {
        g_deltaValueNext[pArray[i]] = dimValue;    
    }
}
        // ideas
        // left right
        // flash & decay
        void LeftRightOneMove(int waitCount, char* pIndexFirst, int lengthFirst, char* pIndexSecond, int lengthSecond)
        {
            SpinWaitClearAndPause(waitCount);
            SpinWait();
            SetDimSet(pIndexFirst, lengthFirst, (256 - 31)  );
            SetDimSet(pIndexSecond, lengthSecond, (31));
            g_deltaCountNext = 1;
        }
        void LeftRight()
        {
            char onOne[] = { 10, 11, 13, 14 };
            char onTwo[] = { 1, 12 };
            char onThree[] = { 4, 8 };
            char onFour[] = { 2, 5, 6, 9 };
            char onFive[] = { 3, 7 };
                        char waitCount = 5;
            char repeat;
            SpinWaitClearAndPause(1);
            // Top light is always on for this one...
            g_deltaValueNext[0] = (31);
            SetDimSet(onOne, 4, (31));
            g_deltaCountNext = 1;
            for (repeat = 0; repeat < 20; repeat++)
            {
                LeftRightOneMove(waitCount, onOne, 4, onTwo, 2);
                LeftRightOneMove(waitCount, onTwo, 2, onThree, 2);
                LeftRightOneMove(waitCount, onThree, 2, onFour, 4);
                LeftRightOneMove(waitCount, onFour, 4, onFive, 2);
                LeftRightOneMove(waitCount, onFive, 2, onFour, 4);
                LeftRightOneMove(waitCount, onFour, 4, onThree, 2);
                LeftRightOneMove(waitCount, onThree, 2, onTwo, 2);
                LeftRightOneMove(waitCount, onTwo, 2, onOne, 4);
                if (repeat % 4 == 1)
                {
                    waitCount--;
                }
            }
            SpinWaitClearAndPause(waitCount);
            // Turn off remainders
            g_deltaValueNext[0] = (256 - 31)  ;
            SetDimSet(onOne, 4, (256 - 31)  );
            g_deltaCountNext = 1;
        }
                eeprom char WaveUpDeltaValues[] = { 1, 2, 3, 5, 10 };
        void WaveUp()
        {
            char deltaIndex;
            char dimDelta;
            char dimCount;
            char i;
            SpinWaitClearAndPause(1);
            g_deltaCountNext = 1;
            for (deltaIndex = 0; deltaIndex < 4; deltaIndex++)
            {
                dimDelta = WaveUpDeltaValues[deltaIndex];
                dimCount = (char) ( 10 / dimDelta);       // 10 because each does 3, and our max count is 31. 
                // wave up all lights...
                for (i = 0; i < 18; i++)
                {
                    SpinWait();
                    SetDeltaIfValid(i, (dimDelta));
                    SetDeltaIfValid(i - 1, (dimDelta));
                    SetDeltaIfValid(i - 2, (dimDelta));
                    SetDeltaIfValid(i - 3, 0);
                    g_deltaCountNext = dimCount;
                }
                // and wave them off...
                for (i = 0; i < 18; i++)
                {
                    SpinWait();
                    SetDeltaIfValid(i, (256 - dimDelta)  );
                    SetDeltaIfValid(i - 1, (256 - dimDelta)  );
                    SetDeltaIfValid(i - 2, (256 - dimDelta)  );
                    SetDeltaIfValid(i - 3, 0);
                    g_deltaCountNext = dimCount;
                }
            }
            SpinWaitClearAndPause(1);
            g_deltaCountNext = 1;
        }
        void FirstPanelUpDown(char dimValue)
        {
            g_deltaValueNext[4] = dimValue;
            g_deltaValueNext[9] = dimValue;
            g_deltaValueNext[14] = dimValue;
            g_deltaCountNext = 15;            
        } 
                void ColorSwitch()
        {
            char loop;
            char color;
            char last;
            char item;
            SpinWaitClearAndPause(1);
            // Dim up the last panel
            FirstPanelUpDown((2));
            for (loop = 1; loop < 8; loop++)
            {
                for (color = 0; color < 5; color++)
                {
                    SpinWaitClearAndPause(24);
                    SpinWait();  
                    last = (char) ((color + 4) % 5);
                    for (item = 0; item < 3; item++)
                    {
                        g_deltaValueNext[last + item * 5] = (256 - 2)  ;
                        g_deltaValueNext[color + item * 5] = (2);
                    }
                    g_deltaCountNext = 15;
                }
            }
            SpinWaitClearAndPause(0);
            // Dim down the last panel
            FirstPanelUpDown((256 - 2)  );
        }
       eeprom char twinkleArray[] = { 4, 5, 0, 12, 9, 13, 14, 6, 7, 1, 8, 3, 11, 10, 2 };
       void Twinkle()
        {
            char i;
            char loopCount;
            SpinWaitClearAndPause(1);
            for (i = 0; i < 15; i++)
            {
                g_deltaValueNext[i] = (5);
            }
            g_deltaCountNext = 6;
            for (loopCount = 0; loopCount < 4; loopCount++)
            {
                for (i = 0; i < 15; i++)
                {
                    SpinWaitClearAndPause(15);
                    g_deltaValueNext[twinkleArray[i]] = (256 - 4)  ;
                    g_deltaCountNext = 4;
                    SpinWait();
                    g_deltaValueNext[twinkleArray[i]] = (4);
                    g_deltaCountNext = 4;
                }
            }
            SpinWaitClearAndPause(1);
            for (i = 0; i < 15; i++)
            {
                g_deltaValueNext[i] = (256 - 5)  ;
            }
            g_deltaCountNext = 6;
            SpinWaitClearAndPause(1);
        }
/*
         
timerDelays[16] - array of count delays between dim levels.   
   
   
INTERRUPT:

ZC interrupt happens before actual ZC

1) Set up timer for first interrupt just after ZC
2) Set timerDelayIndex to 0
3) Turn off all channels
4) Update delta dim levels, copy to dimValues array. Invert values so that 15 is the dimmest and 0 is the brightest. 

Counter 1 overflow handler.

1) Set up timer for timerDelays[timerDelayIndex]. Increment timerDelayIndex.
2) Walk through channels. If dimValues[channel] == 0, turn on channel. If not, decrement it.    









*/
