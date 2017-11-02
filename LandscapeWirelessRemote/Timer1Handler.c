#include <tiny2313.h>
#include <delay.h>
#include <stdio.h>  
#include "project.h"

char currentLightState = 0;
char linkDetectedTimeout = 0;
char buttonPressed = 0;

static char tenths = 0;

#define BUTTON PIND.2
#define LED_POWER PORTB.0
#define LED_LINK PORTB.1
#define LED_LIGHTS PORTB.2

#define LED_ON 1
#define LED_OFF 0

void SetLightState(char lightState)
{
    currentLightState = lightState;
}

void LinkDetected()
{
    linkDetectedTimeout = 20;  // 10 seconds
}

void SendString(char flash *string)
{
    while (*string != 0)
    {
        putchar(*string);
        string++;
    }
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
        // Reinitialize Timer1 value
    TCNT1H=0xF3CA >> 8;
    TCNT1L=0xF3CA & 0xff;
    
    if (linkDetectedTimeout > 0)
    {
        linkDetectedTimeout--;
        LED_LINK = LED_ON;    
    }
    else
    {
        LED_LINK = LED_OFF;
        LED_LIGHTS = LED_OFF;
        currentLightState = 0;
    }
    
    if (currentLightState == 1)
    {
        LED_LIGHTS = LED_ON;
    }
    else
    {
        LED_LIGHTS = LED_OFF;
    }
    
    if (BUTTON == 0)
    {
        if (!buttonPressed)
        {
            buttonPressed = 1;
            if (currentLightState == 1)
            {
                SendString("S0");
            }
            else
            {
                SendString("S1");
            }
        }
    }
    else
    {
        buttonPressed = 0;
    }
    
    tenths++;
    if (tenths == 10)
    {
        tenths = 0;
        LED_POWER = LED_ON;
    }
    else
    {
        LED_POWER = LED_OFF; 
    }  
}
