/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.7a Standard
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
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

// (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.


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

//const int LEVELS_TO_SKIP = 2;
//eeprom int g_timerDelays[] = { 1390, 590, 480, 420, 390, 360, 360, 350, 360, 370, 380, 420, 480, 600, 1390};

const int LEVELS_TO_SKIP = 4;
eeprom int g_timerDelays[] = { 960, 400, 320, 270, 240, 230, 210, 200, 190, 180, 190, 170, 180, 170, 170, 170, 170, 180, 170, 180, 180, 180, 200, 200, 210, 220, 240, 280, 310, 410, 960};

//const int LEVELS_TO_SKIP = 16;
//eeprom short int g_timerDelays[] = {670, 280, 217, 184, 164, 149, 139, 130, 123, 118, 113, 109, 106, 102, 100, 98, 97, 94, 93, 91, 91, 89, 89, 87, 87, 86, 85, 85, 85, 85, 85, 84, 85, 84, 85, 85, 85, 87, 87, 87, 89, 89, 91, 91, 93, 95, 95, 98, 101, 103, 105, 109, 113, 118, 123, 130, 139, 149, 165, 184, 217, 280, 677 };

const char SLOWDOWN_FACTOR = 10;
char g_slowdownCounter;  

char g_count = 0;


char g_deltaCount;

char g_deltaCountNext = 255;

//#define INTERRUPT_TO_ACTUAL_ZC_COUNT 160
// 33 K / 4.4K value  

void UpdateDimValues();
void Twinkle();
void ColorSwitch();
void WaveUp();
void LeftRight();
void CopyValuesToOutput();
void InitValues();                         
void SpinWaitClearAndPause(char pauseCount);

 * Note: The zero-crossing signal is from a switching power supply and is therefore more than a bit noisy. The code therefore turns off the zc interrupt until the end of the 
 * dimming cycle and then turns it back on again. 
*/

interrupt [3] void ext_int1_isr(void)
{
        
    TCNT0 = 0xFF - 50;
    TIFR = 0x02;    // clear Bit 1 � TOV0: Timer/Counter0 Overflow Flag
    
//    PORTB = 0XFF;
}    

interrupt [7] void timer0_ovf_isr(void)
{
    int i;
    


    TIFR = 0x80;    // clear bit 7 - TOV1: Timer/counter1 overflow Flag
    TIMSK &= ~(0x02);   // turn off timer 0 interrupt
    TIMSK |= 0x80;   // interrupt on timer 1 only...     

    
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
    
}

interrupt [6] void timer1_ovf_isr(void)
{
    #asm("cli")
    g_timerDelayIndex--;
    
    if (g_timerDelayIndex == LEVELS_TO_SKIP)
    {
            // reset watchdog timer 
        #asm("wdr")
    
        TIMSK &= ~(0x80);
        GIMSK = 0x80;   // turn on external zero-crossing interrupt again...
        EIFR = 0x80;   // clear the interrupt bit so it doesn't trigger right now...
          
        UpdateDimValues();
    }
    else
    {
        //TurnOnChannels();
        
        CopyValuesToOutput();
    }

}


{
    int i;
    
    if (g_slowdownCounter < SLOWDOWN_FACTOR)
    {
        return;
    }
    
        
    {
        g_currentValue[i] += g_deltaValue[i];
    }    
    g_deltaCount--;
        
        // atom. We'll get the next one and tell the main loop to generate
        // the next atom...
        
    {
        for (i = 0; i < 15; i++)
        {
            g_deltaValue[i] = g_deltaValueNext[i];
        }
        g_deltaCount = g_deltaCountNext;

   }  
}

{

    // We use PB0-PB7 (8 bits)
    // PD0-PD2 (3 bits)
    // PD4-PD6 (3 bits)
    // PA0 (1 bit)
    // (next time pick a chip with more ports!
    
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

{    
    // We need 15 bits.
    // We use PB0-PB7 (8 bits)
    // PD0-PD2 (3 bits)
    // PD4-PD6 (3 bits)
    // PA0 (1 bit)
    // (next time pick a chip with more ports!
    
    PORTD.0 = 0;
    PORTD.1 = 0;
    PORTD.4 = 0;
    PORTD.5 = 0;
    PORTD.6 = 0;
    PORTA.0 = 0;
    PORTA.1 = 0;
}
// Declare your global variables here

{
// Declare your local variables here

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

TIMSK=0x80;

// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// Port A initialization
// Func2=Out Func1=Out Func0=Out 
// State2=0 State1=0 State0=0 
PORTA=0x07;
DDRA=0x03;
PORTA=0x07;

// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=Out 
// State6=0 State5=0 State4=0 State3=T State2=T State1=0 State0=0 
PORTD=0x00;
DDRD=0x73;
PORTD=0XFF; 

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

// INT0: Off
// INT1: On
// INT1 Mode: Falling Edge
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x80;
MCUCR=0x0C;
EIFR=0x80;  

// Watchdog Timer Prescaler: OSC/128k
// Watchdog Timer interrupt: Off
#pragma optsize-
WDTCR=0x1E;
WDTCR=0x0E;
#pragma optsize+


#asm("sei")

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

{
    char i;
    
    {
        g_currentValue[i] = 0;
        g_deltaValue[i] = 0;
        g_deltaValueNext[i] = 0;
    }
    g_deltaCount = 10;
    g_deltaCountNext = 5; 
                     

{
    while (g_deltaCountNext != 0)
    {
    }
}

{
    char i;
    
    for (i = 0; i < 15; i++)
    {
        g_deltaValueNext[i] = 0;
    }
    g_deltaCountNext = pauseCount;
}


{
    if (index < 0 || index > 14)
    {
        return;
    }

}

{
    char i;
    for (i = 0; i < count; i++)
    {
        g_deltaValueNext[pArray[i]] = dimValue;    
    }
}

        // left right
        // flash & decay

        {
            SpinWaitClearAndPause(waitCount);
            SpinWait();

            SetDimSet(pIndexSecond, lengthSecond, (31));
            g_deltaCountNext = 1;
        }

        {
            char onOne[] = { 10, 11, 13, 14 };
            char onTwo[] = { 1, 12 };
            char onThree[] = { 4, 8 };
            char onFour[] = { 2, 5, 6, 9 };
            char onFive[] = { 3, 7 };
            
            char repeat;


            g_deltaValueNext[0] = (31);
            SetDimSet(onOne, 4, (31));
            g_deltaCountNext = 1;

            {
                LeftRightOneMove(waitCount, onOne, 4, onTwo, 2);
                LeftRightOneMove(waitCount, onTwo, 2, onThree, 2);
                LeftRightOneMove(waitCount, onThree, 2, onFour, 4);
                LeftRightOneMove(waitCount, onFour, 4, onFive, 2);
                LeftRightOneMove(waitCount, onFive, 2, onFour, 4);
                LeftRightOneMove(waitCount, onFour, 4, onThree, 2);
                LeftRightOneMove(waitCount, onThree, 2, onTwo, 2);
                LeftRightOneMove(waitCount, onTwo, 2, onOne, 4);

                {
                    waitCount--;
                }
            }


            g_deltaValueNext[0] = (256 - 31)  ;
            SetDimSet(onOne, 4, (256 - 31)  );
            g_deltaCountNext = 1;
        }
        
        void WaveUp()
        {
            char deltaIndex;
            char dimDelta;
            char dimCount;
            char i;

            g_deltaCountNext = 1;

            {
                dimDelta = WaveUpDeltaValues[deltaIndex];
                dimCount = (char) ( 10 / dimDelta);       // 10 because each does 3, and our max count is 31. 

                for (i = 0; i < 18; i++)
                {
                    SpinWait();

                    SetDeltaIfValid(i - 1, (dimDelta));
                    SetDeltaIfValid(i - 2, (dimDelta));
                    SetDeltaIfValid(i - 3, 0);
                    g_deltaCountNext = dimCount;
                }

                for (i = 0; i < 18; i++)
                {
                    SpinWait();

                    SetDeltaIfValid(i - 1, (256 - dimDelta)  );
                    SetDeltaIfValid(i - 2, (256 - dimDelta)  );
                    SetDeltaIfValid(i - 3, 0);
                    g_deltaCountNext = dimCount;
                }
            }

            g_deltaCountNext = 1;
        }

        {
            g_deltaValueNext[4] = dimValue;
            g_deltaValueNext[9] = dimValue;
            g_deltaValueNext[14] = dimValue;
            g_deltaCountNext = 15;            
        } 
        
        {
            char loop;
            char color;
            char last;
            char item;


            FirstPanelUpDown((2));

            {
                for (color = 0; color < 5; color++)
                {
                    SpinWaitClearAndPause(24);
                    SpinWait();  
                    last = (char) ((color + 4) % 5);

                    {
                        g_deltaValueNext[last + item * 5] = (256 - 2)  ;
                        g_deltaValueNext[color + item * 5] = (2);
                    }
                    g_deltaCountNext = 15;
                }
            }


            FirstPanelUpDown((256 - 2)  );
        }


        {
            char i;
            char loopCount;


            {
                g_deltaValueNext[i] = (5);
            }
            g_deltaCountNext = 6;

            {
                for (i = 0; i < 15; i++)
                {
                    SpinWaitClearAndPause(15);

                    g_deltaCountNext = 4;
                    SpinWait();

                    g_deltaCountNext = 4;
                }
            }


            {
                g_deltaValueNext[i] = (256 - 5)  ;
            }
            g_deltaCountNext = 6;

        }

         
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
