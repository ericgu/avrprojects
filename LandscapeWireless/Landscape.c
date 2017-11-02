#include <tiny2313.h>
#include <delay.h>  
#include <stdio.h>
#include "project.h"

#if 0
void D(char v)
{
    PORTB = 255 - v;
}
#endif


void main(void)
{                 
    init();
    
    while (1)
    {
        delay_ms(1000);
    }
}

