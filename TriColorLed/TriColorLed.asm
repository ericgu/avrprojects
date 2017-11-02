.include "tn12def.inc"

.def	RedIncrement	=r7
.def	GreenIncrement	=r8
.def	BlueIncrement	=r9

.def	RedBrightness = r10
.def	GreenBrightness = r11
.def	BlueBrightness = r12

.def	Temp = r16
.def	PortValue = r17

.def	Counter = r18

.def	RedValue = r19
.def	GreenValue = r20
.def	BlueValue = r21

.def	OperationCount	=r22

.def	CycleCount		=r23
.def	CurrentCycle = r24

.equ 	TimerDelay = $FF

.ORG $0000				; interrupt vectors...

	rjmp		Start
	reti					; external interrupt
	reti					; pin change interrupt
	rjmp		TimerInt	; timer interrupt

.CSEG

dataTable:
			; White on, then pause

        .DB	     31,		1,      8,    8,    8, 		0
        .DB	     31,		1,      248,248,  248, 		0
        .DB	     63,		1,      4,    4,    4, 		0
        .DB	     63,		1,      252,252,  252, 		0
        .DB	    127,		1,      2,    2,    2, 		0
        .DB	    127,		1,      254,254,  254, 		0
        .DB	    255,		1,      1,    1,    1, 		0

			; Ramp down from white to red
        .DB	    255,	2,      0,      255,      255, 		0
        .DB	    255,		1,      0,    0,    0, 		0

			;  Cross ramp to green...
        .DB	    255,	2,      255,      1,      0, 		0
        .DB	    255,		1,      0,    0,    0, 		0

			;  Cross ramp to blue...
        .DB	    255,	2,      0,      255,      1, 		0
        .DB	    255,		1,      0,    0,    0, 		0

			;  Cross ramp to yellow
        .DB	    255,	4,      1,      1,      255, 		0
        .DB	    255,		1,      0,    0,    0, 		0

			;  Cross ramp to cyan
        .DB	    255,	4,      255,    0,      1, 		0
        .DB	    255,		1,      0,    0,    0, 		0

			;  Cross ramp to purple
        .DB	    255,	4,      1,    255,    0, 		0
        .DB	    255,		1,      0,    0,    0, 		0


        .DB	    255,	1,      255,    0,    255, 		0
			; Quick cycle

        .DB	    1,		1,      255,    0,    0, 		0		; red
        .DB	    25,		1,      0,    0,    0, 		0
        .DB	    1,		1,      1,    255,    0, 		0		; green
        .DB	    25,		1,      0,    0,    0, 		0
        .DB	    1,		1,      0,    	1,  255, 		0		; blue
        .DB	    25,		1,      0,    0,    0, 		0
        .DB	    1,		1,      255,    0,    0, 		0		; yellow
        .DB	    25,		1,      0,    0,    0, 		0
        .DB	    1,		1,      1,    255,    0, 		0		; cyan
        .DB	    25,		1,      0,    0,    0, 		0
        .DB	    1,		1,      255,    1,  255, 		0		; purple
        .DB	    25,		1,      0,    0,    0, 		0


        .DB	    0, 0    


Start:
	ldi		ZH, high(2 * dataTable)
	ldi 	ZL, low(2 * dataTable)

	ldi		Counter, $01
	ldi		Temp, $01
	mov		CurrentCycle, Temp

	ldi		Temp, $FF
	out		DDRB, Temp			; Set port b to output

	ldi		Temp, $01
	out		TCCR0, Temp			; no prescaler on the timer interrupt

	ldi		Temp, TimerDelay
	out		TCNT0, Temp			; set initial value in the counter..

	ldi		Temp, $02
	out		TIMSK, Temp			; Turn on the timer interrupt

	clr		RedBrightness
	clr		GreenBrightness
	clr		BlueBrightness
	clr		OperationCount

	sei							; Enable interrupts

Loop:
	rjmp	Loop				; Just go back


TimerInt:

	dec		Counter
	cpi		Counter, $00

	brne	Normal

		; counter at zero
		; See if we've done enough cycles. 

	dec		CurrentCycle
	cpi		CurrentCycle, $00
	breq	CycleDone
	rjmp	NormalNextCycle		; start next cycle

CycleDone:
	mov		CurrentCycle, CycleCount

	cpi 	OperationCount, $00
	brne	UpdateBrightness


Decode:
		; Decode the next set of instructions
	lpm
	mov		OperationCount, r0
	inc		r30

	cpi		OperationCount, $00
	brne	Decode2

	ldi		ZH, high(2 * dataTable)
	ldi 	ZL, low(2 * dataTable)

	clr		RedBrightness
	clr		GreenBrightness
	clr		BlueBrightness

	rjmp	Decode

Decode2:
	lpm
	mov		CycleCount, r0
	inc		r30

	lpm
	mov		RedIncrement, r0
	inc		r30

	lpm
	mov		GreenIncrement, r0
	inc		r30

	lpm
	mov		BlueIncrement, r0
	inc		r30

	inc		r30

	mov		CurrentCycle, CycleCount

UpdateBrightness:

	dec		OperationCount

	add		RedBrightness, RedIncrement
	add		GreenBrightness, GreenIncrement
	add		BlueBrightness, BlueIncrement

NormalNextCycle:
		; 
	mov		RedValue, RedBrightness
	mov		GreenValue, GreenBrightness
	mov		BlueValue, BlueBrightness

Normal:
		; Check each color...
	ldi		PortValue, $00

RedCheck:

	cpi		RedValue, $00

	brne	RedDec
	ori		PortValue, $01
	rjmp	GreenCheck

RedDec:
	dec		RedValue

GreenCheck:

	cpi		GreenValue, $00

	brne	GreenDec
	ori		PortValue, $02
	rjmp	BlueCheck

GreenDec:
	dec		GreenValue

BlueCheck:

	cpi		BlueValue, $00

	brne	BlueDec
	ori		PortValue, $04
	rjmp	SendOut

BlueDec:
	dec		BlueValue

SendOut:	

	out		PortB, PortValue

	ldi		Temp, TimerDelay
	out		TCNT0, Temp			; set initial value in the counter..

	reti
