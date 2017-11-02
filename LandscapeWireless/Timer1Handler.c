#include <tiny2313.h>
#include <delay.h>
#include <stdio.h>  
#include "project.h"

// Tick time is 1/10th of a second (100 mSec).
// Two hour timeout

//#define TIMEOUT_IN_TICKS (10*34)
#define TIMEOUT_IN_TICKS (10 * 60 * 60 * 2)

static long int timeRemainingTicks = 0;   // time before lights go off 
static char outputState = 0;
static char outputStateLast = 0;
static char ticks = 0;

#define ALLOFF PIND.2
#define ALLON PIND.3
#define ON1 PIND.4
#define ON2 PIND.5
#define ON3 PIND.6
#define STATUS PORTB.7

void TurnOn(void)
{
    timeRemainingTicks = TIMEOUT_IN_TICKS;
}

void AllOff(void)
{
    outputState = 0;
    timeRemainingTicks = 0;
}

void AllOn(void)
{
    outputState = 30;
    TurnOn();
}


void HandleButtons()
{
    if (ALLOFF == 0)
    {
        AllOff();
    }
    else if (ALLON == 0)
    {
        AllOn();
    }
    else if (ON1 == 0)
    {
        outputState |= 1 << 1;         
        TurnOn();
    }
    else if (ON2 == 0)
    {
        outputState |= 1 << 2;         
        TurnOn();
    }
    else if (ON3 == 0)
    {
        outputState |= 1 << 3;         
        TurnOn();
    }
}

void SendString(char flash *string)
{
    while (*string != 0)
    {
        putchar(*string);
        string++;
    }
}

void SendOutputState()
{
    if (outputState == 0)
    {
        SendString("EG0\r");
    }
    else
    {
        SendString("EG1\r");
    }
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
        // Reinitialize Timer1 value
    TCNT1H=TCNT1H_VALUE;
    TCNT1L=TCNT1L_VALUE;

    HandleButtons();
    
    if (timeRemainingTicks > 0)
    {
        if ((timeRemainingTicks % 600 == 0) &&
            (timeRemainingTicks <= 3000))
        {
            PORTB = 0;
        }
        else
        {     
            PORTB = outputState;
        }
        timeRemainingTicks--;  
    }
    else
    {
        outputState = 0;
        PORTB = 0;
    }

    ticks++;
    if (outputState != outputStateLast || ticks == 10)
    {
        SendOutputState();
        outputStateLast = outputState;
    }

    if (ticks == 10)
    {
        ticks = 0;
        if (outputState != 0 && timeRemainingTicks > 0)
        {
            STATUS = 1;
        }
    }
    else
    {
        STATUS = 0;
    }  
}
