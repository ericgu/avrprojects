
;CodeVisionAVR C Compiler V1.25.7a Standard
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATtiny2313V
;Clock frequency        : 8.000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 50 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313V
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "TreeLights.vec"
	.INCLUDE "TreeLights.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	LDI  R30,__GPIOR1_INIT
	OUT  GPIOR1,R30
	LDI  R30,__GPIOR2_INIT
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x92)
	LDI  R29,HIGH(0x92)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x92
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.25.7a Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project : Tree lights
;       9 Version : 1.0
;      10 Date    : 11/26/2008
;      11 Author  : Eric Gunnerson
;      12 Company : Bellevue WA 98008 US
;      13 Comments:
;      14 15-channel 5 color tree lights.
;      15 
;      16 
;      17 Chip type           : ATtiny2313V
;      18 Clock frequency     : 8.000000 MHz
;      19 Memory model        : Tiny
;      20 External SRAM size  : 0
;      21 Data Stack size     : 32
;      22 *****************************************************/
;      23 
;      24 #define DISABLE_OUTPUT 0
;      25 #define ZC_DISABLE_INT 0
;      26 
;      27 #include <tiny2313.h>
;      28 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      29 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      30 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;      31 	.EQU __sm_mask=0x50
	.EQU __sm_mask=0x50
;      32 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;      33 	.EQU __sm_standby=0x40
	.EQU __sm_standby=0x40
;      34 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      35 	#endif
	#endif
;      36 #define byte char
;      37 
;      38 //const int DIM_LEVELS = 16;
;      39 //const int LEVELS_TO_SKIP = 2;
;      40 //eeprom int g_timerDelays[] = { 1390, 590, 480, 420, 390, 360, 360, 350, 360, 370, 380, 420, 480, 600, 1390};
;      41 
;      42 const int DIM_LEVELS = 32;

	.CSEG
;      43 const int LEVELS_TO_SKIP = 4;
;      44 eeprom int g_timerDelays[] = { 960, 400, 320, 270, 240, 230, 210, 200, 190, 180, 190, 170, 180, 170, 170, 170, 170, 180, 170, 180, 180, 180, 200, 200, 210, 220, 240, 280, 310, 410, 960};

	.ESEG
_g_timerDelays:
	.DW  0x3C0
	.DW  0x190
	.DW  0x140
	.DW  0x10E
	.DW  0xF0
	.DW  0xE6
	.DW  0xD2
	.DW  0xC8
	.DW  0xBE
	.DW  0xB4
	.DW  0xBE
	.DW  0xAA
	.DW  0xB4
	.DW  0xAA
	.DW  0xAA
	.DW  0xAA
	.DW  0xAA
	.DW  0xB4
	.DW  0xAA
	.DW  0xB4
	.DW  0xB4
	.DW  0xB4
	.DW  0xC8
	.DW  0xC8
	.DW  0xD2
	.DW  0xDC
	.DW  0xF0
	.DW  0x118
	.DW  0x136
	.DW  0x19A
	.DW  0x3C0
;      45 
;      46 //const int DIM_LEVELS = 64;
;      47 //const int LEVELS_TO_SKIP = 16;
;      48 //eeprom short int g_timerDelays[] = {670, 280, 217, 184, 164, 149, 139, 130, 123, 118, 113, 109, 106, 102, 100, 98, 97, 94, 93, 91, 91, 89, 89, 87, 87, 86, 85, 85, 85, 85, 85, 84, 85, 84, 85, 85, 85, 87, 87, 87, 89, 89, 91, 91, 93, 95, 95, 98, 101, 103, 105, 109, 113, 118, 123, 130, 139, 149, 165, 184, 217, 280, 677 };
;      49 
;      50 
;      51 char g_timerDelayIndex;
;      52 const char SLOWDOWN_FACTOR = 10;

	.CSEG
;      53 char g_slowdownCounter;
;      54 
;      55 //char g_portBValue = 0;
;      56 char g_count = 0;
;      57 
;      58 char g_currentValue[15];

	.DSEG
_g_currentValue:
	.BYTE 0xF
;      59 
;      60 char g_deltaValue[15];
_g_deltaValue:
	.BYTE 0xF
;      61 char g_deltaCount;
;      62 
;      63 char g_deltaValueNext[15];
_g_deltaValueNext:
	.BYTE 0xF
;      64 char g_deltaCountNext = 255;
;      65 
;      66 // 33 K / 2.2K value
;      67 //#define INTERRUPT_TO_ACTUAL_ZC_COUNT 160
;      68 // 33 K / 4.4K value
;      69 #define INTERRUPT_TO_ACTUAL_ZC_COUNT 50
;      70 
;      71 #define HALF_WAVE_COUNT 4170
;      72 
;      73 void AllOff();
;      74 void UpdateDimValues();
;      75 void Twinkle();
;      76 void ColorSwitch();
;      77 void WaveUp();
;      78 void LeftRight();
;      79 void CopyValuesToOutput();
;      80 void InitValues();
;      81 void SpinWaitClearAndPause(char pauseCount);
;      82 
;      83 /*
;      84  * Note: The zero-crossing signal is from a switching power supply and is therefore more than a bit noisy. The code therefore turns off the zc interrupt until the end of the
;      85  * dimming cycle and then turns it back on again.
;      86 */
;      87 
;      88 // External interrupt from zero-crossing signal...
;      89 interrupt [EXT_INT1] void ext_int1_isr(void)
;      90 {

	.CSEG
_ext_int1_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;      91 #if ZC_DISABLE_INT
;      92     GIMSK=0x00;    // turn off zero-crossing until we need it again...
;      93 #endif
;      94 
;      95         // Wait until we get to actual zero cross.
;      96     TCNT0 = 0xFF - INTERRUPT_TO_ACTUAL_ZC_COUNT;
	LDI  R30,LOW(205)
	OUT  0x32,R30
;      97     TIFR = 0x02;    // clear Bit 1 – TOV0: Timer/Counter0 Overflow Flag
	LDI  R30,LOW(2)
	OUT  0x38,R30
;      98 
;      99     TIMSK |= 0x02;   // Turn on timer 0 interrupt.
	IN   R30,0x39
	ORI  R30,2
	OUT  0x39,R30
;     100 //    PORTB = 0XFF;
;     101 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     102 
;     103 // Timer 0 overflow denotes actual zero crossing...
;     104 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     105 {
_timer0_ovf_isr:
	RCALL SUBOPT_0x0
;     106     int i;
;     107 
;     108     #asm("cli")
	RCALL __SAVELOCR2
;	i -> R16,R17
	cli
;     109 
;     110 //    PORTB = 0x00;
;     111 
;     112     TCNT1 = 0XFFFF - g_timerDelays[0];
	LDI  R26,LOW(_g_timerDelays)
	LDI  R27,HIGH(_g_timerDelays)
	RCALL SUBOPT_0x1
;     113     TIFR = 0x80;    // clear bit 7 - TOV1: Timer/counter1 overflow Flag
	LDI  R30,LOW(128)
	OUT  0x38,R30
;     114     TIMSK &= ~(0x02);   // turn off timer 0 interrupt
	IN   R30,0x39
	ANDI R30,0xFD
	OUT  0x39,R30
;     115     TIMSK |= 0x80;   // interrupt on timer 1 only...
	IN   R30,0x39
	ORI  R30,0x80
	OUT  0x39,R30
;     116 
;     117     g_timerDelayIndex = 31;
	LDI  R30,LOW(31)
	MOV  R3,R30
;     118 
;     119     g_count = (g_count + 1) % 16;
	MOV  R26,R5
	SUBI R26,-LOW(1)
	MOV  R30,R26
	ANDI R30,LOW(0xF)
	MOV  R5,R30
;     120     if (g_count == 0)
	TST  R5
	BRNE _0x4
;     121     {
;     122         for (i = 0; i < 15; i++)
	__GETWRN 16,17,0
_0x6:
	RCALL SUBOPT_0x2
	BRGE _0x7
;     123         {
;     124             //g_currentValue[i] = (g_currentValue[i] + 1) % (DIM_LEVELS);
;     125         }
	__ADDWRN 16,17,1
	RJMP _0x6
_0x7:
;     126         //g_portBValue = (g_portBValue + 1) % (DIM_LEVELS - LEVELS_TO_SKIP);
;     127     }
;     128     //TurnOnChannels();
;     129     CopyValuesToOutput();
_0x4:
	RCALL _CopyValuesToOutput
;     130 
;     131     #asm("sei")
	sei
;     132 }
	RCALL __LOADLOCR2P
	RCALL SUBOPT_0x3
	RETI
;     133 
;     134 // Timer 1 overflow handles dimming levels.
;     135 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     136 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x0
;     137     #asm("cli")
	cli
;     138     g_timerDelayIndex--;
	DEC  R3
;     139 
;     140 
;     141             // if done, we're done.
;     142     if (g_timerDelayIndex == LEVELS_TO_SKIP)
	LDI  R30,LOW(_LEVELS_TO_SKIP*2)
	LDI  R31,HIGH(_LEVELS_TO_SKIP*2)
	RCALL __GETW1PF
	MOV  R26,R3
	RCALL SUBOPT_0x4
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x8
;     143     {
;     144             // reset watchdog timer
;     145         #asm("wdr")
	wdr
;     146 
;     147            // turn everything off...
;     148         TIMSK &= ~(0x80);
	IN   R30,0x39
	ANDI R30,0x7F
	OUT  0x39,R30
;     149         GIMSK = 0x80;   // turn on external zero-crossing interrupt again...
	LDI  R30,LOW(128)
	OUT  0x3B,R30
;     150         EIFR = 0x80;   // clear the interrupt bit so it doesn't trigger right now...
	OUT  0x3A,R30
;     151 
;     152         AllOff();
	RCALL _AllOff
;     153         UpdateDimValues();
	RCALL _UpdateDimValues
;     154     }
;     155     else
	RJMP _0x9
_0x8:
;     156     {
;     157         //TurnOnChannels();
;     158 
;     159         TCNT1 = 0XFFFF - g_timerDelays[g_timerDelayIndex];
	MOV  R30,R3
	LDI  R26,LOW(_g_timerDelays)
	LDI  R27,HIGH(_g_timerDelays)
	RCALL SUBOPT_0x5
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x1
;     160         CopyValuesToOutput();
	RCALL _CopyValuesToOutput
;     161     }
_0x9:
;     162 
;     163     #asm("sei")
	sei
;     164 }
	RCALL SUBOPT_0x3
	RETI
;     165 
;     166 //
;     167 
;     168 void UpdateDimValues()
;     169 {
_UpdateDimValues:
;     170     int i;
;     171 
;     172     g_slowdownCounter++;
	RCALL __SAVELOCR2
;	i -> R16,R17
	INC  R2
;     173     if (g_slowdownCounter < SLOWDOWN_FACTOR)
	LDI  R30,LOW(_SLOWDOWN_FACTOR*2)
	LDI  R31,HIGH(_SLOWDOWN_FACTOR*2)
	LPM  R30,Z
	CP   R2,R30
	BRLO _0x77
;     174     {
;     175         return;
;     176     }
;     177 
;     178     g_slowdownCounter = 0;
	CLR  R2
;     179 
;     180     for (i = 0; i < 15; i++)
	__GETWRN 16,17,0
_0xC:
	RCALL SUBOPT_0x2
	BRGE _0xD
;     181     {
;     182         g_currentValue[i] += g_deltaValue[i];
	MOVW R30,R16
	SUBI R30,-LOW(_g_currentValue)
	MOV  R0,R30
	LD   R30,Z
	MOV  R26,R30
	MOVW R30,R16
	SUBI R30,-LOW(_g_deltaValue)
	LD   R30,Z
	ADD  R30,R26
	MOV  R26,R0
	ST   X,R30
;     183     }
	__ADDWRN 16,17,1
	RJMP _0xC
_0xD:
;     184     g_deltaCount--;
	DEC  R4
;     185 
;     186         // When the deltaCount is zero, we're done with this specific
;     187         // atom. We'll get the next one and tell the main loop to generate
;     188         // the next atom...
;     189 
;     190     if (g_deltaCount == 0)
	TST  R4
	BRNE _0xE
;     191     {
;     192         for (i = 0; i < 15; i++)
	__GETWRN 16,17,0
_0x10:
	RCALL SUBOPT_0x2
	BRGE _0x11
;     193         {
;     194             g_deltaValue[i] = g_deltaValueNext[i];
	MOVW R30,R16
	SUBI R30,-LOW(_g_deltaValue)
	MOV  R26,R30
	MOVW R30,R16
	SUBI R30,-LOW(_g_deltaValueNext)
	LD   R30,Z
	ST   X,R30
;     195         }
	__ADDWRN 16,17,1
	RJMP _0x10
_0x11:
;     196         g_deltaCount = g_deltaCountNext;
	MOV  R4,R7
;     197 
;     198         g_deltaCountNext = 0;
	CLR  R7
;     199    }
;     200 }
_0xE:
_0x77:
	RCALL __LOADLOCR2P
	RET
;     201 
;     202 #ifdef fred
;     203 void TurnOnChannels()
;     204 {
;     205         if (g_timerDelayIndex == g_portBValue)
;     206         {
;     207             PORTB.0 = 1;
;     208         }
;     209 }
;     210 #endif
;     211 
;     212 #define GetChannelValue(index) ((g_currentValue[index] == g_timerDelayIndex) ? 1 : 0)
;     213 
;     214 void CopyValuesToOutput()
;     215 {
_CopyValuesToOutput:
;     216 #if DISABLE_OUTPUT
;     217 return;
;     218 #endif
;     219 
;     220     // We need 15 bits.
;     221     // We use PB0-PB7 (8 bits)
;     222     // PD0-PD2 (3 bits)
;     223     // PD4-PD6 (3 bits)
;     224     // PA0 (1 bit)
;     225     // (next time pick a chip with more ports!
;     226 
;     227     PORTA.0 = GetChannelValue(0);
	LDS  R26,_g_currentValue
	CP   R3,R26
	BRNE _0x12
	LDI  R30,LOW(1)
	RJMP _0x13
_0x12:
	LDI  R30,LOW(0)
_0x13:
	RCALL __BSTB1
	IN   R26,0x1B
	BLD  R26,0
	OUT  0x1B,R26
;     228     PORTD.4 = GetChannelValue(1);
	__GETB2MN _g_currentValue,1
	CP   R3,R26
	BRNE _0x15
	LDI  R30,LOW(1)
	RJMP _0x16
_0x15:
	LDI  R30,LOW(0)
_0x16:
	RCALL SUBOPT_0x6
	BLD  R26,4
	OUT  0x12,R26
;     229     PORTD.5 = GetChannelValue(2);
	__GETB2MN _g_currentValue,2
	CP   R3,R26
	BRNE _0x18
	LDI  R30,LOW(1)
	RJMP _0x19
_0x18:
	LDI  R30,LOW(0)
_0x19:
	RCALL SUBOPT_0x6
	BLD  R26,5
	OUT  0x12,R26
;     230     PORTD.6 = GetChannelValue(3);
	__GETB2MN _g_currentValue,3
	CP   R3,R26
	BRNE _0x1B
	LDI  R30,LOW(1)
	RJMP _0x1C
_0x1B:
	LDI  R30,LOW(0)
_0x1C:
	RCALL SUBOPT_0x6
	BLD  R26,6
	OUT  0x12,R26
;     231     PORTB.0 = GetChannelValue(4);
	__GETB2MN _g_currentValue,4
	CP   R3,R26
	BRNE _0x1E
	LDI  R30,LOW(1)
	RJMP _0x1F
_0x1E:
	LDI  R30,LOW(0)
_0x1F:
	RCALL SUBOPT_0x7
	BLD  R26,0
	OUT  0x18,R26
;     232     PORTB.1 = GetChannelValue(5);
	__GETB2MN _g_currentValue,5
	CP   R3,R26
	BRNE _0x21
	LDI  R30,LOW(1)
	RJMP _0x22
_0x21:
	LDI  R30,LOW(0)
_0x22:
	RCALL SUBOPT_0x7
	BLD  R26,1
	OUT  0x18,R26
;     233     PORTB.2 = GetChannelValue(6);
	__GETB2MN _g_currentValue,6
	CP   R3,R26
	BRNE _0x24
	LDI  R30,LOW(1)
	RJMP _0x25
_0x24:
	LDI  R30,LOW(0)
_0x25:
	RCALL SUBOPT_0x7
	BLD  R26,2
	OUT  0x18,R26
;     234     PORTB.3 = GetChannelValue(7);
	__GETB2MN _g_currentValue,7
	CP   R3,R26
	BRNE _0x27
	LDI  R30,LOW(1)
	RJMP _0x28
_0x27:
	LDI  R30,LOW(0)
_0x28:
	RCALL SUBOPT_0x7
	BLD  R26,3
	OUT  0x18,R26
;     235     PORTB.4 = GetChannelValue(8);
	__GETB2MN _g_currentValue,8
	CP   R3,R26
	BRNE _0x2A
	LDI  R30,LOW(1)
	RJMP _0x2B
_0x2A:
	LDI  R30,LOW(0)
_0x2B:
	RCALL SUBOPT_0x7
	BLD  R26,4
	OUT  0x18,R26
;     236     PORTB.5 = GetChannelValue(9);
	__GETB2MN _g_currentValue,9
	CP   R3,R26
	BRNE _0x2D
	LDI  R30,LOW(1)
	RJMP _0x2E
_0x2D:
	LDI  R30,LOW(0)
_0x2E:
	RCALL SUBOPT_0x7
	BLD  R26,5
	OUT  0x18,R26
;     237     PORTB.6 = GetChannelValue(10);
	__GETB2MN _g_currentValue,10
	CP   R3,R26
	BRNE _0x30
	LDI  R30,LOW(1)
	RJMP _0x31
_0x30:
	LDI  R30,LOW(0)
_0x31:
	RCALL SUBOPT_0x7
	BLD  R26,6
	OUT  0x18,R26
;     238     PORTB.7 = GetChannelValue(11);
	__GETB2MN _g_currentValue,11
	CP   R3,R26
	BRNE _0x33
	LDI  R30,LOW(1)
	RJMP _0x34
_0x33:
	LDI  R30,LOW(0)
_0x34:
	RCALL SUBOPT_0x7
	BLD  R26,7
	OUT  0x18,R26
;     239     PORTD.0 = GetChannelValue(12);
	__GETB2MN _g_currentValue,12
	CP   R3,R26
	BRNE _0x36
	LDI  R30,LOW(1)
	RJMP _0x37
_0x36:
	LDI  R30,LOW(0)
_0x37:
	RCALL SUBOPT_0x6
	BLD  R26,0
	OUT  0x12,R26
;     240     PORTD.1 = GetChannelValue(13);
	__GETB2MN _g_currentValue,13
	CP   R3,R26
	BRNE _0x39
	LDI  R30,LOW(1)
	RJMP _0x3A
_0x39:
	LDI  R30,LOW(0)
_0x3A:
	RCALL SUBOPT_0x6
	BLD  R26,1
	OUT  0x12,R26
;     241     PORTA.1 = GetChannelValue(14);
	__GETB2MN _g_currentValue,14
	CP   R3,R26
	BRNE _0x3C
	LDI  R30,LOW(1)
	RJMP _0x3D
_0x3C:
	LDI  R30,LOW(0)
_0x3D:
	RCALL __BSTB1
	IN   R26,0x1B
	BLD  R26,1
	OUT  0x1B,R26
;     242 }
	RET
;     243 
;     244 void AllOff()
;     245 {
_AllOff:
;     246 #if DISABLE_OUTPUT
;     247 return;
;     248 #endif
;     249     // We need 15 bits.
;     250     // We use PB0-PB7 (8 bits)
;     251     // PD0-PD2 (3 bits)
;     252     // PD4-PD6 (3 bits)
;     253     // PA0 (1 bit)
;     254     // (next time pick a chip with more ports!
;     255 
;     256     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     257     PORTD.0 = 0;
	CBI  0x12,0
;     258     PORTD.1 = 0;
	CBI  0x12,1
;     259     PORTD.4 = 0;
	CBI  0x12,4
;     260     PORTD.5 = 0;
	CBI  0x12,5
;     261     PORTD.6 = 0;
	CBI  0x12,6
;     262     PORTA.0 = 0;
	CBI  0x1B,0
;     263     PORTA.1 = 0;
	CBI  0x1B,1
;     264 }
	RET
;     265 // Declare your global variables here
;     266 
;     267 
;     268 void main(void)
;     269 {
_main:
;     270 // Declare your local variables here
;     271 
;     272 // Crystal Oscillator division factor: 1
;     273 #pragma optsize-
;     274 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
;     275 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
;     276 #ifdef _OPTIMIZE_SIZE_
;     277 #pragma optsize+
;     278 #endif
;     279 
;     280 // Timer(s)/Counter(s) Interrupt(s) initialization
;     281 TIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x39,R30
;     282 
;     283 // Universal Serial Interface initialization
;     284 // Mode: Disabled
;     285 // Clock source: Register & Counter=no clk.
;     286 // USI Counter Overflow Interrupt: Off
;     287 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;     288 
;     289 // Analog Comparator initialization
;     290 // Analog Comparator: Off
;     291 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     292 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     293 
;     294 // Input/Output Ports initialization
;     295 // Port A initialization
;     296 // Func2=Out Func1=Out Func0=Out
;     297 // State2=0 State1=0 State0=0
;     298 PORTA=0x07;
	LDI  R30,LOW(7)
	OUT  0x1B,R30
;     299 DDRA=0x03;
	LDI  R30,LOW(3)
	OUT  0x1A,R30
;     300 PORTA=0x07;
	LDI  R30,LOW(7)
	OUT  0x1B,R30
;     301 
;     302 // Port B initialization
;     303 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
;     304 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
;     305 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     306 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     307 
;     308 // Port D initialization
;     309 // Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=Out
;     310 // State6=0 State5=0 State4=0 State3=T State2=T State1=0 State0=0
;     311 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     312 DDRD=0x73;
	LDI  R30,LOW(115)
	OUT  0x11,R30
;     313 PORTD=0XFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
;     314 
;     315 // Timer/Counter 0 initialization
;     316 // Clock source: System Clock
;     317 // Clock value: 125.000 kHz
;     318 // Mode: Normal top=FFh
;     319 // OC0A output: Disconnected
;     320 // OC0B output: Disconnected
;     321 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     322 TCCR0B=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;     323 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     324 OCR0A=0x00;
	OUT  0x36,R30
;     325 OCR0B=0x00;
	OUT  0x3C,R30
;     326 
;     327 // Timer/Counter 1 initialization
;     328 // Clock source: System Clock
;     329 // Clock value: 1000.000 kHz
;     330 // Mode: Normal top=FFFFh
;     331 // OC1A output: Discon.
;     332 // OC1B output: Discon.
;     333 // Noise Canceler: Off
;     334 // Input Capture on Falling Edge
;     335 // Timer 1 Overflow Interrupt: On
;     336 // Input Capture Interrupt: Off
;     337 // Compare A Match Interrupt: Off
;     338 // Compare B Match Interrupt: Off
;     339 TCCR1A=0x00;
	OUT  0x2F,R30
;     340 TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
;     341 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;     342 TCNT1L=0x00;
	OUT  0x2C,R30
;     343 ICR1H=0x00;
	OUT  0x25,R30
;     344 ICR1L=0x00;
	OUT  0x24,R30
;     345 OCR1AH=0x00;
	OUT  0x2B,R30
;     346 OCR1AL=0x00;
	OUT  0x2A,R30
;     347 OCR1BH=0x00;
	OUT  0x29,R30
;     348 OCR1BL=0x00;
	OUT  0x28,R30
;     349 
;     350 
;     351 
;     352 // External Interrupt(s) initialization
;     353 // INT0: Off
;     354 // INT1: On
;     355 // INT1 Mode: Falling Edge
;     356 // Interrupt on any change on pins PCINT0-7: Off
;     357 GIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x3B,R30
;     358 MCUCR=0x0C;
	LDI  R30,LOW(12)
	OUT  0x35,R30
;     359 EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
;     360 
;     361 // Watchdog Timer initialization
;     362 // Watchdog Timer Prescaler: OSC/128k
;     363 // Watchdog Timer interrupt: Off
;     364 #pragma optsize-
;     365 WDTCR=0x1E;
	LDI  R30,LOW(30)
	OUT  0x21,R30
;     366 WDTCR=0x0E;
	LDI  R30,LOW(14)
	OUT  0x21,R30
;     367 #ifdef _OPTIMIZE_SIZE_
;     368 #pragma optsize+
;     369 #endif
;     370 
;     371 InitValues();
	RCALL _InitValues
;     372 
;     373 // Global enable interrupts
;     374 #asm("sei")
	sei
;     375 
;     376     while (1)
_0x3F:
;     377     {
;     378         //DimRandom();
;     379         Twinkle();
	RCALL _Twinkle
;     380         SpinWaitClearAndPause(12);
	RCALL SUBOPT_0x8
;     381         ColorSwitch();
	RCALL _ColorSwitch
;     382         SpinWaitClearAndPause(12);
	RCALL SUBOPT_0x8
;     383         WaveUp();
	RCALL _WaveUp
;     384         SpinWaitClearAndPause(12);
	RCALL SUBOPT_0x8
;     385         LeftRight();
	RCALL _LeftRight
;     386         SpinWaitClearAndPause(12);
	RCALL SUBOPT_0x8
;     387     }
	RJMP _0x3F
;     388 }
_0x42:
	RJMP _0x42
;     389 
;     390 void InitValues()
;     391 {
_InitValues:
;     392     char i;
;     393 
;     394     for (i = 0; i < 15; i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x44:
	CPI  R17,15
	BRSH _0x45
;     395     {
;     396         g_currentValue[i] = 0;
	LDI  R26,LOW(_g_currentValue)
	RCALL SUBOPT_0x9
;     397         g_deltaValue[i] = 0;
	LDI  R26,LOW(_g_deltaValue)
	RCALL SUBOPT_0x9
;     398         g_deltaValueNext[i] = 0;
	LDI  R26,LOW(_g_deltaValueNext)
	RCALL SUBOPT_0x9
;     399     }
	SUBI R17,-1
	RJMP _0x44
_0x45:
;     400     g_deltaCount = 10;
	LDI  R30,LOW(10)
	MOV  R4,R30
;     401     g_deltaCountNext = 5;
	LDI  R30,LOW(5)
	MOV  R7,R30
;     402 
;     403 }
	LD   R17,Y+
	RET
;     404 
;     405 #define DimUp(increment) (increment)
;     406 #define DimDown(increment) (256 - increment)
;     407 
;     408 void SpinWait()
;     409 {
_SpinWait:
;     410     while (g_deltaCountNext != 0)
_0x46:
	TST  R7
	BRNE _0x46
;     411     {
;     412     }
;     413 }
	RET
;     414 
;     415 void SpinWaitClearAndPause(char pauseCount)
;     416 {
_SpinWaitClearAndPause:
;     417     char i;
;     418 
;     419     SpinWait();
	ST   -Y,R17
;	pauseCount -> Y+1
;	i -> R17
	RCALL _SpinWait
;     420     for (i = 0; i < 15; i++)
	LDI  R17,LOW(0)
_0x4A:
	CPI  R17,15
	BRSH _0x4B
;     421     {
;     422         g_deltaValueNext[i] = 0;
	LDI  R26,LOW(_g_deltaValueNext)
	RCALL SUBOPT_0x9
;     423     }
	SUBI R17,-1
	RJMP _0x4A
_0x4B:
;     424     g_deltaCountNext = pauseCount;
	LDD  R7,Y+1
;     425 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;     426 
;     427 eeprom char vOrdered[] = { 14, 9, 8, 13, 7, 12, 6, 5, 11, 4, 3, 10, 2, 1, 0 };

	.ESEG
_vOrdered:
	.DB  0xE
	.DB  0x9
	.DB  0x8
	.DB  0xD
	.DB  0x7
	.DB  0xC
	.DB  0x6
	.DB  0x5
	.DB  0xB
	.DB  0x4
	.DB  0x3
	.DB  0xA
	.DB  0x2
	.DB  0x1
	.DB  0x0
;     428 
;     429 void SetDeltaIfValid(int index, char dimValue)
;     430 {

	.CSEG
_SetDeltaIfValid:
;     431     if (index < 0 || index > 14)
;	index -> Y+1
;	dimValue -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,0
	BRLT _0x4D
	SBIW R26,15
	BRLT _0x4C
_0x4D:
;     432     {
;     433         return;
	RJMP _0x76
;     434     }
;     435 
;     436    g_deltaValueNext[vOrdered[index]] = dimValue;
_0x4C:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SUBI R26,LOW(-_vOrdered)
	SBCI R27,HIGH(-_vOrdered)
	RCALL __EEPROMRDB
	SUBI R30,-LOW(_g_deltaValueNext)
	LD   R26,Y
	STD  Z+0,R26
;     437 }
_0x76:
	ADIW R28,3
	RET
;     438 
;     439 
;     440 void SetDimSet(char* pArray, int count, char dimValue)
;     441 {
_SetDimSet:
;     442     char i;
;     443     for (i = 0; i < count; i++)
	ST   -Y,R17
;	*pArray -> Y+4
;	count -> Y+2
;	dimValue -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x50:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0xA
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x51
;     444     {
;     445         g_deltaValueNext[pArray[i]] = dimValue;
	MOV  R30,R17
	LDD  R26,Y+4
	ADD  R26,R30
	LD   R30,X
	SUBI R30,-LOW(_g_deltaValueNext)
	LDD  R26,Y+1
	STD  Z+0,R26
;     446     }
	SUBI R17,-1
	RJMP _0x50
_0x51:
;     447 }
	LDD  R17,Y+0
	ADIW R28,5
	RET
;     448 
;     449         // ideas
;     450         // left right
;     451         // flash & decay
;     452 
;     453         void LeftRightOneMove(int waitCount, char* pIndexFirst, int lengthFirst, char* pIndexSecond, int lengthSecond)
;     454         {
_LeftRightOneMove:
;     455             SpinWaitClearAndPause(waitCount);
;	waitCount -> Y+6
;	*pIndexFirst -> Y+5
;	lengthFirst -> Y+3
;	*pIndexSecond -> Y+2
;	lengthSecond -> Y+0
	LDD  R30,Y+6
	RCALL SUBOPT_0xB
;     456             SpinWait();
	RCALL _SpinWait
;     457 
;     458             SetDimSet(pIndexFirst, lengthFirst, DimDown(31));
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0xC
	LDI  R30,LOW(225)
	RCALL SUBOPT_0xD
;     459             SetDimSet(pIndexSecond, lengthSecond, DimUp(31));
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0xC
	LDI  R30,LOW(31)
	RCALL SUBOPT_0xD
;     460             g_deltaCountNext = 1;
	RCALL SUBOPT_0xE
;     461         }
	ADIW R28,8
	RET
;     462 
;     463 
;     464         void LeftRight()
;     465         {
_LeftRight:
;     466             byte onOne[] = { 10, 11, 13, 14 };
;     467             byte onTwo[] = { 1, 12 };
;     468             byte onThree[] = { 4, 8 };
;     469             byte onFour[] = { 2, 5, 6, 9 };
;     470             byte onFive[] = { 3, 7 };
;     471 
;     472             byte waitCount = 5;
;     473             byte repeat;
;     474 
;     475             SpinWaitClearAndPause(1);
	SBIW R28,14
	LDI  R24,14
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x52*2)
	LDI  R31,HIGH(_0x52*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR2
;	onOne -> Y+12
;	onTwo -> Y+10
;	onThree -> Y+8
;	onFour -> Y+4
;	onFive -> Y+2
;	waitCount -> R17
;	repeat -> R16
	LDI  R17,5
	RCALL SUBOPT_0xF
;     476 
;     477             // Top light is always on for this one...
;     478             g_deltaValueNext[0] = DimUp(31);
	LDI  R30,LOW(31)
	RCALL SUBOPT_0x10
;     479             SetDimSet(onOne, 4, DimUp(31));
	LDI  R30,LOW(31)
	RCALL SUBOPT_0xD
;     480             g_deltaCountNext = 1;
	RCALL SUBOPT_0xE
;     481 
;     482             for (repeat = 0; repeat < 20; repeat++)
	LDI  R16,LOW(0)
_0x54:
	CPI  R16,20
	BRSH _0x55
;     483             {
;     484                 LeftRightOneMove(waitCount, onOne, 4, onTwo, 2);
	RCALL SUBOPT_0x11
	MOV  R30,R28
	SUBI R30,-(14)
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
;     485                 LeftRightOneMove(waitCount, onTwo, 2, onThree, 2);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
;     486                 LeftRightOneMove(waitCount, onThree, 2, onFour, 4);
	RCALL SUBOPT_0x16
	MOV  R30,R28
	SUBI R30,-(9)
	RCALL SUBOPT_0x12
	RCALL _LeftRightOneMove
;     487                 LeftRightOneMove(waitCount, onFour, 4, onFive, 2);
	RCALL SUBOPT_0x11
	MOV  R30,R28
	SUBI R30,-(6)
	RCALL SUBOPT_0x12
	MOV  R30,R28
	SUBI R30,-(7)
	RCALL SUBOPT_0x17
	RCALL _LeftRightOneMove
;     488                 LeftRightOneMove(waitCount, onFive, 2, onFour, 4);
	RCALL SUBOPT_0x11
	MOV  R30,R28
	SUBI R30,-(4)
	RCALL SUBOPT_0x17
	MOV  R30,R28
	SUBI R30,-(9)
	RCALL SUBOPT_0x12
	RCALL _LeftRightOneMove
;     489                 LeftRightOneMove(waitCount, onFour, 4, onThree, 2);
	RCALL SUBOPT_0x11
	MOV  R30,R28
	SUBI R30,-(6)
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x15
;     490                 LeftRightOneMove(waitCount, onThree, 2, onTwo, 2);
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x13
;     491                 LeftRightOneMove(waitCount, onTwo, 2, onOne, 4);
	RCALL SUBOPT_0x14
	MOV  R30,R28
	SUBI R30,-(17)
	RCALL SUBOPT_0x12
	RCALL _LeftRightOneMove
;     492 
;     493                 if (repeat % 4 == 1)
	MOV  R30,R16
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x1)
	BRNE _0x56
;     494                 {
;     495                     waitCount--;
	SUBI R17,1
;     496                 }
;     497             }
_0x56:
	SUBI R16,-1
	RJMP _0x54
_0x55:
;     498 
;     499             SpinWaitClearAndPause(waitCount);
	ST   -Y,R17
	RCALL _SpinWaitClearAndPause
;     500 
;     501             // Turn off remainders
;     502             g_deltaValueNext[0] = DimDown(31);
	LDI  R30,LOW(225)
	RCALL SUBOPT_0x10
;     503             SetDimSet(onOne, 4, DimDown(31));
	LDI  R30,LOW(225)
	RCALL SUBOPT_0xD
;     504             g_deltaCountNext = 1;
	RCALL SUBOPT_0xE
;     505         }
	RCALL __LOADLOCR2
	ADIW R28,16
	RET
;     506 
;     507         eeprom byte WaveUpDeltaValues[] = { 1, 2, 3, 5, 10 };

	.ESEG
_WaveUpDeltaValues:
	.DB  0x1
	.DB  0x2
	.DB  0x3
	.DB  0x5
	.DB  0xA
;     508         void WaveUp()
;     509         {

	.CSEG
_WaveUp:
;     510             byte deltaIndex;
;     511             byte dimDelta;
;     512             byte dimCount;
;     513             byte i;
;     514 
;     515             SpinWaitClearAndPause(1);
	RCALL __SAVELOCR4
;	deltaIndex -> R17
;	dimDelta -> R16
;	dimCount -> R19
;	i -> R18
	RCALL SUBOPT_0xF
;     516             g_deltaCountNext = 1;
	RCALL SUBOPT_0xE
;     517 
;     518             for (deltaIndex = 0; deltaIndex < 4; deltaIndex++)
	LDI  R17,LOW(0)
_0x58:
	CPI  R17,4
	BRSH _0x59
;     519             {
;     520                 dimDelta = WaveUpDeltaValues[deltaIndex];
	RCALL SUBOPT_0xA
	SUBI R26,LOW(-_WaveUpDeltaValues)
	SBCI R27,HIGH(-_WaveUpDeltaValues)
	RCALL __EEPROMRDB
	MOV  R16,R30
;     521                 dimCount = (byte) ( 10 / dimDelta);       // 10 because each does 3, and our max count is 31.
	MOV  R30,R16
	LDI  R26,LOW(10)
	RCALL __DIVB21U
	MOV  R19,R30
;     522 
;     523                 // wave up all lights...
;     524                 for (i = 0; i < 18; i++)
	LDI  R18,LOW(0)
_0x5B:
	CPI  R18,18
	BRSH _0x5C
;     525                 {
;     526                     SpinWait();
	RCALL SUBOPT_0x18
;     527 
;     528                     SetDeltaIfValid(i, DimUp(dimDelta));
	RCALL SUBOPT_0x19
;     529                     SetDeltaIfValid(i - 1, DimUp(dimDelta));
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x19
;     530                     SetDeltaIfValid(i - 2, DimUp(dimDelta));
	SUBI R30,LOW(2)
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x19
;     531                     SetDeltaIfValid(i - 3, 0);
	SUBI R30,LOW(3)
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
;     532                     g_deltaCountNext = dimCount;
;     533                 }
	SUBI R18,-1
	RJMP _0x5B
_0x5C:
;     534 
;     535                 // and wave them off...
;     536                 for (i = 0; i < 18; i++)
	LDI  R18,LOW(0)
_0x5E:
	CPI  R18,18
	BRSH _0x5F
;     537                 {
;     538                     SpinWait();
	RCALL SUBOPT_0x18
;     539 
;     540                     SetDeltaIfValid(i, DimDown(dimDelta));
	RCALL SUBOPT_0x1C
;     541                     SetDeltaIfValid(i - 1, DimDown(dimDelta));
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1C
;     542                     SetDeltaIfValid(i - 2, DimDown(dimDelta));
	SUBI R30,LOW(2)
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1C
;     543                     SetDeltaIfValid(i - 3, 0);
	SUBI R30,LOW(3)
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
;     544                     g_deltaCountNext = dimCount;
;     545                 }
	SUBI R18,-1
	RJMP _0x5E
_0x5F:
;     546             }
	SUBI R17,-1
	RJMP _0x58
_0x59:
;     547 
;     548             SpinWaitClearAndPause(1);
	RCALL SUBOPT_0xF
;     549             g_deltaCountNext = 1;
	RCALL SUBOPT_0xE
;     550         }
	RJMP _0x75
;     551 
;     552 
;     553         void FirstPanelUpDown(char dimValue)
;     554         {
_FirstPanelUpDown:
;     555             g_deltaValueNext[4] = dimValue;
;	dimValue -> Y+0
	LD   R30,Y
	__PUTB1MN _g_deltaValueNext,4
;     556             g_deltaValueNext[9] = dimValue;
	__PUTB1MN _g_deltaValueNext,9
;     557             g_deltaValueNext[14] = dimValue;
	__PUTB1MN _g_deltaValueNext,14
;     558             g_deltaCountNext = 15;
	LDI  R30,LOW(15)
	MOV  R7,R30
;     559         }
	ADIW R28,1
	RET
;     560 
;     561         void ColorSwitch()
;     562         {
_ColorSwitch:
;     563             byte loop;
;     564             byte color;
;     565             byte last;
;     566             byte item;
;     567 
;     568             SpinWaitClearAndPause(1);
	RCALL __SAVELOCR4
;	loop -> R17
;	color -> R16
;	last -> R19
;	item -> R18
	RCALL SUBOPT_0xF
;     569 
;     570             // Dim up the last panel
;     571             FirstPanelUpDown(DimUp(2));
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _FirstPanelUpDown
;     572 
;     573             for (loop = 1; loop < 8; loop++)
	LDI  R17,LOW(1)
_0x61:
	CPI  R17,8
	BRSH _0x62
;     574             {
;     575                 for (color = 0; color < 5; color++)
	LDI  R16,LOW(0)
_0x64:
	CPI  R16,5
	BRSH _0x65
;     576                 {
;     577                     SpinWaitClearAndPause(24);
	LDI  R30,LOW(24)
	RCALL SUBOPT_0xB
;     578                     SpinWait();
	RCALL _SpinWait
;     579                     last = (byte) ((color + 4) % 5);
	MOV  R26,R16
	SUBI R26,-LOW(4)
	LDI  R30,LOW(5)
	RCALL __MODB21U
	MOV  R19,R30
;     580 
;     581                     for (item = 0; item < 3; item++)
	LDI  R18,LOW(0)
_0x67:
	CPI  R18,3
	BRSH _0x68
;     582                     {
;     583                         g_deltaValueNext[last + item * 5] = DimDown(2);
	MOV  R26,R18
	LDI  R30,LOW(5)
	RCALL __MULB12U
	ADD  R30,R19
	SUBI R30,-LOW(_g_deltaValueNext)
	LDI  R26,LOW(254)
	STD  Z+0,R26
;     584                         g_deltaValueNext[color + item * 5] = DimUp(2);
	MOV  R26,R18
	LDI  R30,LOW(5)
	RCALL __MULB12U
	ADD  R30,R16
	SUBI R30,-LOW(_g_deltaValueNext)
	LDI  R26,LOW(2)
	STD  Z+0,R26
;     585                     }
	SUBI R18,-1
	RJMP _0x67
_0x68:
;     586                     g_deltaCountNext = 15;
	LDI  R30,LOW(15)
	MOV  R7,R30
;     587                 }
	SUBI R16,-1
	RJMP _0x64
_0x65:
;     588             }
	SUBI R17,-1
	RJMP _0x61
_0x62:
;     589 
;     590             SpinWaitClearAndPause(0);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xB
;     591 
;     592             // Dim down the last panel
;     593             FirstPanelUpDown(DimDown(2));
	LDI  R30,LOW(254)
	ST   -Y,R30
	RCALL _FirstPanelUpDown
;     594         }
_0x75:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;     595 
;     596        eeprom char twinkleArray[] = { 4, 5, 0, 12, 9, 13, 14, 6, 7, 1, 8, 3, 11, 10, 2 };

	.ESEG
_twinkleArray:
	.DB  0x4
	.DB  0x5
	.DB  0x0
	.DB  0xC
	.DB  0x9
	.DB  0xD
	.DB  0xE
	.DB  0x6
	.DB  0x7
	.DB  0x1
	.DB  0x8
	.DB  0x3
	.DB  0xB
	.DB  0xA
	.DB  0x2
;     597 
;     598        void Twinkle()
;     599         {

	.CSEG
_Twinkle:
;     600             char i;
;     601             char loopCount;
;     602 
;     603             SpinWaitClearAndPause(1);
	RCALL __SAVELOCR2
;	i -> R17
;	loopCount -> R16
	RCALL SUBOPT_0xF
;     604 
;     605             for (i = 0; i < 15; i++)
	LDI  R17,LOW(0)
_0x6A:
	CPI  R17,15
	BRSH _0x6B
;     606             {
;     607                 g_deltaValueNext[i] = DimUp(5);
	LDI  R26,LOW(_g_deltaValueNext)
	ADD  R26,R17
	LDI  R30,LOW(5)
	ST   X,R30
;     608             }
	SUBI R17,-1
	RJMP _0x6A
_0x6B:
;     609             g_deltaCountNext = 6;
	LDI  R30,LOW(6)
	MOV  R7,R30
;     610 
;     611             for (loopCount = 0; loopCount < 4; loopCount++)
	LDI  R16,LOW(0)
_0x6D:
	CPI  R16,4
	BRSH _0x6E
;     612             {
;     613                 for (i = 0; i < 15; i++)
	LDI  R17,LOW(0)
_0x70:
	CPI  R17,15
	BRSH _0x71
;     614                 {
;     615                     SpinWaitClearAndPause(15);
	LDI  R30,LOW(15)
	RCALL SUBOPT_0xB
;     616 
;     617                     g_deltaValueNext[twinkleArray[i]] = DimDown(4);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(252)
	STD  Z+0,R26
;     618                     g_deltaCountNext = 4;
	LDI  R30,LOW(4)
	MOV  R7,R30
;     619                     SpinWait();
	RCALL _SpinWait
;     620 
;     621                     g_deltaValueNext[twinkleArray[i]] = DimUp(4);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(4)
	STD  Z+0,R26
;     622                     g_deltaCountNext = 4;
	LDI  R30,LOW(4)
	MOV  R7,R30
;     623                 }
	SUBI R17,-1
	RJMP _0x70
_0x71:
;     624             }
	SUBI R16,-1
	RJMP _0x6D
_0x6E:
;     625 
;     626             SpinWaitClearAndPause(1);
	RCALL SUBOPT_0xF
;     627 
;     628             for (i = 0; i < 15; i++)
	LDI  R17,LOW(0)
_0x73:
	CPI  R17,15
	BRSH _0x74
;     629             {
;     630                 g_deltaValueNext[i] = DimDown(5);
	LDI  R26,LOW(_g_deltaValueNext)
	ADD  R26,R17
	LDI  R30,LOW(251)
	ST   X,R30
;     631             }
	SUBI R17,-1
	RJMP _0x73
_0x74:
;     632             g_deltaCountNext = 6;
	LDI  R30,LOW(6)
	MOV  R7,R30
;     633 
;     634             SpinWaitClearAndPause(1);
	RCALL SUBOPT_0xF
;     635         }
	RCALL __LOADLOCR2P
	RET
;     636 
;     637 /*
;     638 
;     639 timerDelays[16] - array of count delays between dim levels.
;     640 
;     641 
;     642 INTERRUPT:
;     643 
;     644 ZC interrupt happens before actual ZC
;     645 
;     646 1) Set up timer for first interrupt just after ZC
;     647 2) Set timerDelayIndex to 0
;     648 3) Turn off all channels
;     649 4) Update delta dim levels, copy to dimValues array. Invert values so that 15 is the dimmest and 0 is the brightest.
;     650 
;     651 Counter 1 overflow handler.
;     652 
;     653 1) Set up timer for timerDelays[timerDelayIndex]. Increment timerDelayIndex.
;     654 2) Walk through channels. If dimValues[channel] == 0, turn on channel. If not, decrement it.
;     655 
;     656 
;     657 
;     658 
;     659 
;     660 
;     661 
;     662 
;     663 
;     664 */
;     665 


;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	RCALL __EEPROMRDW
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	__CPWRN 16,17,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x5:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	RCALL __BSTB1
	IN   R26,0x12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	RCALL __BSTB1
	IN   R26,0x18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(12)
	ST   -Y,R30
	RJMP _SpinWaitClearAndPause

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	ADD  R26,R17
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	MOV  R26,R17
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	RJMP _SpinWaitClearAndPause

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	RJMP _SetDimSet

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	MOV  R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(1)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	STS  _g_deltaValueNext,R30
	MOV  R30,R28
	SUBI R30,-(12)
	ST   -Y,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x11:
	MOV  R30,R17
	RCALL SUBOPT_0x5
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	MOV  R30,R28
	SUBI R30,-(15)
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0xC
	RCALL _LeftRightOneMove
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	MOV  R30,R28
	SUBI R30,-(12)
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	MOV  R30,R28
	SUBI R30,-(13)
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0xC
	RCALL _LeftRightOneMove
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	MOV  R30,R28
	SUBI R30,-(10)
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	RCALL _SpinWait
	MOV  R30,R18
	RCALL SUBOPT_0x5
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	ST   -Y,R16
	RCALL _SetDeltaIfValid
	MOV  R30,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x5
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SetDeltaIfValid
	MOV  R7,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1C:
	MOV  R30,R16
	RCALL SUBOPT_0x5
	LDI  R26,LOW(256)
	LDI  R27,HIGH(256)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ST   -Y,R30
	RCALL _SetDeltaIfValid
	MOV  R30,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	SUBI R26,LOW(-_twinkleArray)
	SBCI R27,HIGH(-_twinkleArray)
	RCALL __EEPROMRDB
	SUBI R30,-LOW(_g_deltaValueNext)
	RET

__MULB12U:
	MOV  R0,R26
	SUB  R26,R26
	LDI  R27,9
	RJMP __MULB12U1
__MULB12U3:
	BRCC __MULB12U2
	ADD  R26,R0
__MULB12U2:
	LSR  R26
__MULB12U1:
	ROR  R30
	DEC  R27
	BRNE __MULB12U3
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

__INITLOCB:
__INITLOCW:
	ADD R26,R28
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
