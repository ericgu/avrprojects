/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.7a Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Ring of Fire
Version : 1.0
Date    : 12/2/2007
Author  : Eric Gunnerson                  
Company : Bellevue WA 98008 US            
Comments: 


Chip type           : ATtiny861
Clock frequency     : 20.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 128
*****************************************************/

#include <tiny861.h>  

char g_currentValue[16];
char g_deltaValue[16];
char g_deltaCount = 32;

char g_deltaValueNext[16];
char g_deltaCountNext;

char g_pwmCounter = 0;

void SetOutputPorts()
{
    int i;
    char portA = 0;
    char portB = 0;
    
    for (i = 7; i >= 0; i--)
    {
        if (g_pwmCounter < g_currentValue[i])
        {
            portA |= 1;
        }
        if (i != 0)
        {
            portA <<= 1;
        } 
    }
    

    for (i = 15; i >= 8; i--)
    {
        if (g_pwmCounter < g_currentValue[i])
        {
            portB |= 1;
        }
        if (i != 8)
        {
            portB <<= 1;
        } 
    }
    
    PORTA = portA;
    PORTB = portB;
}

// Timer 0 output compare A interrupt service routine   
interrupt [TIM0_COMPA] void timer0_compa_isr(void)
{
    int i;
 
#ifdef TEST_INTERRUPT_SPEED
    static int c = 0;
    c++;
    PORTA = c;
    return;
#endif
 
 
    SetOutputPorts();
  
    g_pwmCounter++;
                 
        // When the counter is 17, we've completed this PWM cycle. 
        // That means we need to update the deltaCount
    if (g_pwmCounter == 17)
    {
        g_pwmCounter = 0;
        
        for (i = 0; i < 16; i++)
        {
            g_currentValue[i] += g_deltaValue[i];
        }    
        g_deltaCount--;
        
            // When the deltaCount is zero, we're done with this specific
            // atom. We'll get the next one and tell the main loop to generate
            // the next atom...
        
        if (g_deltaCount == 0)
        {
            for (i = 0; i < 16; i++)
            {
                g_deltaValue[i] = g_deltaValueNext[i];
            }
            g_deltaCount = g_deltaCountNext;

            g_deltaCountNext = 0;
       }        
    }    
}

void SpinWait()
{
    while (g_deltaCountNext != 0)
    {
    }
}

SpinWaitClearAndPause(char pauseCount)
{
    int i;
    
    SpinWait();
    for (i = 0; i < 16; i++)
    {
        g_deltaValueNext[i] = 0;
    }
    g_deltaCountNext = pauseCount;
}


        void Rotate()
        {
            int current = 0;
            int last1 = 15;
            int last2 = 14;
            int last3 = 13;
            int last4 = 12;
            int loopCount;
            
            SpinWaitClearAndPause(1);

            g_deltaValueNext[15] = 4 * 4;
            g_deltaValueNext[14] = 4 * 3;
            g_deltaValueNext[13] = 4 * 2;
            g_deltaValueNext[12] = 4 * 1;
            g_deltaCountNext = 1;
            SpinWait();

            for (loopCount = 0; loopCount < 128; loopCount++)
            {
                g_deltaValueNext[current] = 4 * 4;
                g_deltaValueNext[last1] = 256 - 4; ;
                g_deltaValueNext[last2] = 256 - 4;
                g_deltaValueNext[last3] = 256 - 4;
                g_deltaValueNext[last4] = 256 - 4;
                g_deltaCountNext = 1;
                SpinWaitClearAndPause(16);
                SpinWait();

                current = (current + 1) % 16;
                last1 = (last1 + 1) % 16;
                last2 = (last2 + 1) % 16;
                last3 = (last3 + 1) % 16;
                last4 = (last4 + 1) % 16;
            }

            g_deltaValueNext[last1] = 256 - 4 * 4;
            g_deltaValueNext[last2] = 256 - 3 * 4;
            g_deltaValueNext[last3] = 256 - 2 * 4;
            g_deltaValueNext[last4] = 256 - 1 * 4;
            g_deltaCountNext = 1;
        }

        void Clock(int step, int pauseCount)
        {
            int add;
            int loopCount;
            int i;
            int current = 0;
            int last = 15;
            int l;
            int c;
            
            SpinWaitClearAndPause(1);

            for (add = 0; add < 16; add += step)
            {
                i = (add + 15) % 16;
                g_deltaValueNext[i] = 16;
                g_deltaCountNext = 1;
            }

            SpinWait();
            for (loopCount = 0; loopCount < 16; loopCount++)
            {
                for (add = 0; add < 16; add += step)
                {
                    l = (last + add) % 16;
                    c = (current + add) % 16;
                    g_deltaValueNext[l] = 256 - 16;
                    g_deltaValueNext[c] = 16;
                    g_deltaCountNext = 1;
                }

                SpinWaitClearAndPause(pauseCount);

                SpinWait();

                current = (current + 1) % 16;
                last = (last + 1) % 16;
            }
            for (add = 0; add < 16; add += step)
            {
                l = (last + add) % 16; 
                g_deltaValueNext[l] = 256 - 16;
                g_deltaCountNext = 1;
            }
        }


        void Chase()
        {
            int i;
            int current = 0;
            int last = 15;
            int outer;
            int loopCount;

            for (i = 0; i < 16; i++)
            {
                g_deltaValueNext[0] = 0;
            }

            SpinWait();
            g_deltaValueNext[14] = 16;
            g_deltaValueNext[15] = 16;
            g_deltaCountNext = 1;

            SpinWaitClearAndPause(1);

            SpinWait();

            for (outer = 0; outer < 48; outer++)
            {
                for (loopCount = 0; loopCount < 14; loopCount++)
                {
                    g_deltaValueNext[last] = 256 - 16;
                    g_deltaValueNext[current] = 16;
                    g_deltaCountNext = 1;

                    SpinWaitClearAndPause(4);

                    SpinWait();

                    current = (current + 1) % 16;
                    last = (last + 1) % 16;
                }
                current = (current + 1) % 16;
                last = (last + 1) % 16;
            }
            g_deltaValueNext[last] = 256 - 16;
            last = (last + 15) % 16;
            g_deltaValueNext[last] = 256 - 16;
            g_deltaCountNext = 1;
        }

        void HalfAndHalf(int pauseCount)
        {
            int i;
            int j;

            SpinWait();
            for (i = 0; i < 16; i++)
            {
                if (i % 2 == 0)
                {
                    g_deltaValueNext[i] = 16;
                }
                else
                {

                }
            }
            g_deltaCountNext = 1;
            SpinWaitClearAndPause(pauseCount);

            for (j = 0; j < 16; j++)
            {
                SpinWait();
                for (i = 0; i < 16; i++)
                {
                    if (i % 2 == 0)
                    {
                        g_deltaValueNext[i] = 256 - 16;
                    }
                    else
                    {
                        g_deltaValueNext[i] = 16;
                    }
                }
                g_deltaCountNext = 1;
                SpinWaitClearAndPause(pauseCount);

                SpinWait();
                for (i = 0; i < 16; i++)
                {
                    if (i % 2 == 0)
                    {
                        g_deltaValueNext[i] = 16;
                    }
                    else
                    {
                        g_deltaValueNext[i] = 256 - 16;
                    }
                }
                g_deltaCountNext = 1;
                SpinWaitClearAndPause(pauseCount);
            }

            for (i = 0; i < 16; i++)
            {
                if (i % 2 == 0)
                {
                    g_deltaValueNext[i] = 256 - 16;
                }
                else
                {

                }
            }
            g_deltaCountNext = 1;
            SpinWaitClearAndPause(pauseCount);
        }

        void Streak(int start)
        {
            int i;
            int current1 = start;
            int current2 = (start + 1) % 16;
            int last1 = 0;
            int last2 = 0;

            SpinWaitClearAndPause(1);

            for (i = 0; i < 9; i++)
            {
                SpinWait();

                if (i != 0)
                {
                    g_deltaValueNext[last1] = 256 - 16;
                    g_deltaValueNext[last2] = 256 - 16;
                }

                if (i != 8)
                {
                    g_deltaValueNext[current1] = 16;
                    g_deltaValueNext[current2] = 16;
                }
                last1 = current1;
                last2 = current2;

                current1 = (current1 + 15) % 16;
                current2 = (current2 + 1) % 16;
                g_deltaCountNext = 1;

                SpinWaitClearAndPause(2);
            }
        }

        void DimRandom()
        {
            int v[] = { 4, 5, 0, 12, 9, 13, 14, 6, 7, 1, 8, 3, 11, 15, 2, 10 };
            int i;
            int j;

            SpinWaitClearAndPause(1);

            for (i = 0; i < 16; i++)
            {
                for (j = 0; j < 4; j++)
                {
                    if (i != 0)
                    {
                        g_deltaValueNext[v[i - 1]] = 256 - 4;
                    }

                    if (i != 15)
                    {
                        g_deltaValueNext[v[i]] = 4;
                    }
                    g_deltaCountNext = 4;

                    SpinWait();
                }

                if (i != 0)
                {
                    g_deltaValueNext[v[i - 1]] = 0;
                }
            }
            g_deltaCountNext = 1;
        }

        void HandleSide(int spotIncrement, int pauseCount, int index)
        {
            g_deltaValueNext[index] = spotIncrement;
            g_deltaCountNext = 1;

            SpinWaitClearAndPause(pauseCount);

            SpinWait();
        }

        void BounceTrail(int pauseCount)
        {
            int distance;
            int index;

            SpinWaitClearAndPause(1);

            for (distance = 8; distance > 0; distance--)
            {
                for (index = 0; index < distance; index++)
                {
                    HandleSide(16, pauseCount, index);
                }

                for (index = distance - 1; index >= 0; index--)
                {
                    HandleSide(256 - 16, pauseCount, index);
                }

                for (index = 15; index > 15 - distance; index--)
                {
                    HandleSide(16, pauseCount, index);
                }

                for (index = 8 + (8 - distance); index < 16; index++)
                {
                    HandleSide(256 - 16, pauseCount, index);
                }
            }

            g_deltaCountNext = 1;
        }

        void AnimationThread()
        {
            int i;
            int v[] = { 4, 5, 0, 12, 9, 13, 14, 6, 7, 1, 8, 3, 11, 15, 2, 10 };

            BounceTrail(4);

            for (i = 0; i < 8; i++)
            {
                DimRandom();
            }

            {

                for (i = 0; i < 16; i++)
                {
                    Streak(v[i]);
                    SpinWaitClearAndPause(34);
                }
            }

            {
                for (i = 4; i < 128; i *= 2)
                {
                    HalfAndHalf(i);
                }
            }

            {
                Chase();
            }

            for (i = 0; i < 4; i++)
            {
                //Bounce(4);
            }

            {
                char step = 8;
                while (step >= 2)
                {
                    Clock(step, 16);
                    step /= 2;
                }
            }

            {
                Rotate();
            }

            //AllOnOff();
        }




void main(void)
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
// Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTA=0x00;
DDRA=0xFF;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 2500.000 kHz
// Mode: 8bit CTC top=OCR0A
TCCR0A=0x01;
TCCR0B=0x03;    // speed = 8 / 64 MHz = 125 KHz
TCNT0H=0x00;
TCNT0L=0x00;
OCR0A=0x4E;
OCR0B=0x00;
TIFR=0x10;      // turn on output compare flag 0 a - 

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
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
TCCR1B=0x00;
TCCR1C=0x00;
TCCR1D=0x00;
TCCR1E=0x00;
TC1H=0x00;
TCNT1=0x00;
OCR1A=0x00;
OCR1B=0x00;
OCR1C=0x00;
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
TIMSK=0x10;

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

while (1)
{
    AnimationThread();
}

}
