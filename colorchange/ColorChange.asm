; stk500 and attiny12 test

.include "tn12def.inc"

.def	Temp	=r16		; temporary register
.def	Delay	=r17		; delay variable 1
.def	Pwm		=r18		; delay variable 2

.def	OperationCount	=r19

.def	RedIncrement	=r20
.def	GreenIncrement	=r21
.def	BlueIncrement	=r22

.def	RedBrightness	=r23
.def	GreenBrightness	=r24
.def	BlueBrightness	=r25


	ser		Temp
	out		DDRB,Temp		; Set PORTB to output

L:
	ldi		Temp, $00
	out		PORTB, Temp

	ldi		Temp, $07
	out		PORTB, Temp


	rjmp	INIT	
.CSEG

dataTable:
;        .DB    255,     1,      1,      1
;        .DB    255,     255,    255,    255
		.DB	   1, 255, 255, 255
;		.DB   255, 0, 0, 0
		.DB    1, 1, 1, 1
;		.DB   255, 0, 0, 0
        .DB    0,       0,      0,      0

INIT:
	ldi	ZH, high(2 * dataTable)
	ldi ZL, low(2 * dataTable)


DECODE:
	
		; pull out the next set of operations

	lpm
	mov		OperationCount, r0
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

	cpi 	OperationCount,0
	brne	MAIN

		; Start over at the beginning of the table.
	ldi		ZH, high(2 * dataTable)
	ldi 	ZL, low(2 * dataTable)
	rjmp	DECODE

MAIN:
	
	add		RedBrightness, RedIncrement
	add 	BlueBrightness, BlueIncrement
	add 	GreenBrightness, GreenIncrement

	ldi		Pwm, $FF

PWMLOOP:

	ldi		Temp, $00

	cp		Pwm, RedBrightness
	brcs	TESTGREEN
	ori	Temp, $01

TESTGREEN:
	cp		Pwm, GreenBrightness
	brcs	TESTBLUE
	ori	Temp, $02

TESTBLUE:
	cp		Pwm, BlueBrightness
	brcs	SENDDATA
	ori	Temp, $04

SENDDATA:

    ldi		Temp, $FF
	out		PortB, Temp
	
DELAYSTART:


	dec		Delay
	brne	DELAYSTART
	
	dec		Pwm
	brne	PWMLOOP	

	ldi		Temp, $00
	out		PortB, Temp

	dec		OperationCount
	brne 	MAIN

	rjmp	DECODE

;requirements:

;* Each channel has a current brightness from 0 to 255
;* PWM code counts from 0 to 255, turns on the output bit when count > channel brightness. 
;* Animation encoded as:
;	Count, red increment, blue increment, green increment


