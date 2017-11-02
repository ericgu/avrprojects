
;CodeVisionAVR C Compiler V1.25.7a Standard
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATtiny861
;Clock frequency        : 20.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny861
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x0A
	.EQU GPIOR1=0x0B
	.EQU GPIOR2=0x0C

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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
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

	.INCLUDE "RingOfFire.vec"
	.INCLUDE "RingOfFire.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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
	LDI  R30,LOW(0x25F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x25F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0xE0)
	LDI  R29,HIGH(0xE0)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.25.7a Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project : Ring of Fire
;       9 Version : 1.0
;      10 Date    : 12/2/2007
;      11 Author  : Eric Gunnerson
;      12 Company : Bellevue WA 98008 US
;      13 Comments:
;      14 
;      15 
;      16 Chip type           : ATtiny861
;      17 Clock frequency     : 20.000000 MHz
;      18 Memory model        : Small
;      19 External SRAM size  : 0
;      20 Data Stack size     : 128
;      21 *****************************************************/
;      22 
;      23 #include <tiny861.h>
;      24 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      25 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      26 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;      27 	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_adc_noise_red=0x08
;      28 	.EQU __sm_mask=0x18
	.EQU __sm_mask=0x18
;      29 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;      30 	.EQU __sm_standby=0x18
	.EQU __sm_standby=0x18
;      31 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      32 	#endif
	#endif
;      33 
;      34 char g_currentValue[16];
_g_currentValue:
	.BYTE 0x10
;      35 char g_deltaValue[16];
_g_deltaValue:
	.BYTE 0x10
;      36 char g_deltaCount = 32;
;      37 
;      38 char g_deltaValueNext[16];
_g_deltaValueNext:
	.BYTE 0x10
;      39 char g_deltaCountNext;
;      40 
;      41 char g_pwmCounter = 0;
;      42 
;      43 void SetOutputPorts()
;      44 {

	.CSEG
_SetOutputPorts:
;      45     int i;
;      46     char portA = 0;
;      47     char portB = 0;
;      48 
;      49     for (i = 7; i >= 0; i--)
	RCALL __SAVELOCR4
;	i -> R16,R17
;	portA -> R19
;	portB -> R18
	LDI  R18,0
	LDI  R19,0
	__GETWRN 16,17,7
_0x5:
	SUBI R16,0
	SBCI R17,0
	BRLT _0x6
;      50     {
;      51         if (g_pwmCounter < g_currentValue[i])
	RCALL SUBOPT_0x0
	BRSH _0x7
;      52         {
;      53             portA |= 1;
	ORI  R19,LOW(1)
;      54         }
;      55         if (i != 0)
_0x7:
	RCALL SUBOPT_0x1
	BREQ _0x8
;      56         {
;      57             portA <<= 1;
	LSL  R19
;      58         }
;      59     }
_0x8:
	__SUBWRN 16,17,1
	RJMP _0x5
_0x6:
;      60 
;      61 
;      62     for (i = 15; i >= 8; i--)
	__GETWRN 16,17,15
_0xA:
	__CPWRN 16,17,8
	BRLT _0xB
;      63     {
;      64         if (g_pwmCounter < g_currentValue[i])
	RCALL SUBOPT_0x0
	BRSH _0xC
;      65         {
;      66             portB |= 1;
	ORI  R18,LOW(1)
;      67         }
;      68         if (i != 8)
_0xC:
	RCALL SUBOPT_0x2
	BREQ _0xD
;      69         {
;      70             portB <<= 1;
	LSL  R18
;      71         }
;      72     }
_0xD:
	__SUBWRN 16,17,1
	RJMP _0xA
_0xB:
;      73 
;      74     PORTA = portA;
	OUT  0x1B,R19
;      75     PORTB = portB;
	OUT  0x18,R18
;      76 }
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;      77 
;      78 // Timer 0 output compare A interrupt service routine
;      79 interrupt [TIM0_COMPA] void timer0_compa_isr(void)
;      80 {
_timer0_compa_isr:
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
;      81     int i;
;      82 
;      83 #ifdef TEST_INTERRUPT_SPEED
;      84     static int c = 0;
;      85     c++;
;      86     PORTA = c;
;      87     return;
;      88 #endif
;      89 
;      90 
;      91     SetOutputPorts();
	RCALL __SAVELOCR2
;	i -> R16,R17
	RCALL _SetOutputPorts
;      92 
;      93     g_pwmCounter++;
	INC  R5
;      94 
;      95         // When the counter is 17, we've completed this PWM cycle.
;      96         // That means we need to update the deltaCount
;      97     if (g_pwmCounter == 17)
	LDI  R30,LOW(17)
	CP   R30,R5
	BRNE _0xE
;      98     {
;      99         g_pwmCounter = 0;
	CLR  R5
;     100 
;     101         for (i = 0; i < 16; i++)
	RCALL SUBOPT_0x3
_0x10:
	RCALL SUBOPT_0x4
	BRGE _0x11
;     102         {
;     103             g_currentValue[i] += g_deltaValue[i];
	MOVW R30,R16
	SUBI R30,LOW(-_g_currentValue)
	SBCI R31,HIGH(-_g_currentValue)
	MOVW R22,R30
	LD   R0,Z
	LDI  R26,LOW(_g_deltaValue)
	LDI  R27,HIGH(_g_deltaValue)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ADD  R30,R0
	MOVW R26,R22
	ST   X,R30
;     104         }
	RCALL SUBOPT_0x5
	RJMP _0x10
_0x11:
;     105         g_deltaCount--;
	DEC  R3
;     106 
;     107             // When the deltaCount is zero, we're done with this specific
;     108             // atom. We'll get the next one and tell the main loop to generate
;     109             // the next atom...
;     110 
;     111         if (g_deltaCount == 0)
	TST  R3
	BRNE _0x12
;     112         {
;     113             for (i = 0; i < 16; i++)
	RCALL SUBOPT_0x3
_0x14:
	RCALL SUBOPT_0x4
	BRGE _0x15
;     114             {
;     115                 g_deltaValue[i] = g_deltaValueNext[i];
	MOVW R30,R16
	SUBI R30,LOW(-_g_deltaValue)
	SBCI R31,HIGH(-_g_deltaValue)
	MOVW R0,R30
	RCALL SUBOPT_0x6
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
;     116             }
	RCALL SUBOPT_0x5
	RJMP _0x14
_0x15:
;     117             g_deltaCount = g_deltaCountNext;
	MOV  R3,R2
;     118 
;     119             g_deltaCountNext = 0;
	CLR  R2
;     120        }
;     121     }
_0x12:
;     122 }
_0xE:
	RCALL __LOADLOCR2P
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
	RETI
;     123 
;     124 void SpinWait()
;     125 {
_SpinWait:
;     126     while (g_deltaCountNext != 0)
_0x16:
	TST  R2
	BRNE _0x16
;     127     {
;     128     }
;     129 }
	RET
;     130 
;     131 SpinWaitClearAndPause(char pauseCount)
;     132 {
_SpinWaitClearAndPause:
;     133     int i;
;     134 
;     135     SpinWait();
	RCALL __SAVELOCR2
;	pauseCount -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x7
;     136     for (i = 0; i < 16; i++)
_0x1A:
	RCALL SUBOPT_0x4
	BRGE _0x1B
;     137     {
;     138         g_deltaValueNext[i] = 0;
	RCALL SUBOPT_0x6
	LDI  R30,LOW(0)
	ST   X,R30
;     139     }
	RCALL SUBOPT_0x5
	RJMP _0x1A
_0x1B:
;     140     g_deltaCountNext = pauseCount;
	LDD  R2,Y+2
;     141 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;     142 
;     143 
;     144         void Rotate()
;     145         {
_Rotate:
;     146             int current = 0;
;     147             int last1 = 15;
;     148             int last2 = 14;
;     149             int last3 = 13;
;     150             int last4 = 12;
;     151             int loopCount;
;     152 
;     153             SpinWaitClearAndPause(1);
	SBIW R28,6
	LDI  R24,4
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	LDI  R30,LOW(_0x1C*2)
	LDI  R31,HIGH(_0x1C*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR6
;	current -> R16,R17
;	last1 -> R18,R19
;	last2 -> R20,R21
;	last3 -> Y+10
;	last4 -> Y+8
;	loopCount -> Y+6
	LDI  R16,0
	LDI  R17,0
	LDI  R18,15
	LDI  R19,0
	LDI  R20,14
	LDI  R21,0
	RCALL SUBOPT_0x8
;     154 
;     155             g_deltaValueNext[15] = 4 * 4;
	LDI  R30,LOW(16)
	__PUTB1MN _g_deltaValueNext,15
;     156             g_deltaValueNext[14] = 4 * 3;
	LDI  R30,LOW(12)
	__PUTB1MN _g_deltaValueNext,14
;     157             g_deltaValueNext[13] = 4 * 2;
	LDI  R30,LOW(8)
	__PUTB1MN _g_deltaValueNext,13
;     158             g_deltaValueNext[12] = 4 * 1;
	LDI  R30,LOW(4)
	__PUTB1MN _g_deltaValueNext,12
;     159             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     160             SpinWait();
	RCALL _SpinWait
;     161 
;     162             for (loopCount = 0; loopCount < 128; loopCount++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x1E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRGE _0x1F
;     163             {
;     164                 g_deltaValueNext[current] = 4 * 4;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
;     165                 g_deltaValueNext[last1] = 256 - 4; ;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	LDI  R30,LOW(252)
	RCALL SUBOPT_0xD
;     166                 g_deltaValueNext[last2] = 256 - 4;
	LDI  R30,LOW(252)
	RCALL SUBOPT_0xE
;     167                 g_deltaValueNext[last3] = 256 - 4;
	RCALL SUBOPT_0xF
;     168                 g_deltaValueNext[last4] = 256 - 4;
	RCALL SUBOPT_0x10
;     169                 g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     170                 SpinWaitClearAndPause(16);
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x11
;     171                 SpinWait();
;     172 
;     173                 current = (current + 1) % 16;
	MOVW R26,R16
	RCALL SUBOPT_0x12
	MOVW R16,R30
;     174                 last1 = (last1 + 1) % 16;
	MOVW R26,R18
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
;     175                 last2 = (last2 + 1) % 16;
	MOVW R20,R30
;     176                 last3 = (last3 + 1) % 16;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	STD  Y+10,R30
	STD  Y+10+1,R31
;     177                 last4 = (last4 + 1) % 16;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x15
;     178             }
	RCALL SUBOPT_0x16
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x1E
_0x1F:
;     179 
;     180             g_deltaValueNext[last1] = 256 - 4 * 4;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	LDI  R30,LOW(240)
	RCALL SUBOPT_0xD
;     181             g_deltaValueNext[last2] = 256 - 3 * 4;
	LDI  R30,LOW(244)
	RCALL SUBOPT_0xE
;     182             g_deltaValueNext[last3] = 256 - 2 * 4;
	LDI  R26,LOW(248)
	STD  Z+0,R26
;     183             g_deltaValueNext[last4] = 256 - 1 * 4;
	RCALL SUBOPT_0x10
;     184             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     185         }
	RJMP _0x82
;     186 
;     187         void Clock(int step, int pauseCount)
;     188         {
_Clock:
;     189             int add;
;     190             int loopCount;
;     191             int i;
;     192             int current = 0;
;     193             int last = 15;
;     194             int l;
;     195             int c;
;     196 
;     197             SpinWaitClearAndPause(1);
	SBIW R28,8
	LDI  R24,4
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	LDI  R30,LOW(_0x20*2)
	LDI  R31,HIGH(_0x20*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR6
;	step -> Y+16
;	pauseCount -> Y+14
;	add -> R16,R17
;	loopCount -> R18,R19
;	i -> R20,R21
;	current -> Y+12
;	last -> Y+10
;	l -> Y+8
;	c -> Y+6
	RCALL SUBOPT_0x8
;     198 
;     199             for (add = 0; add < 16; add += step)
	RCALL SUBOPT_0x3
_0x22:
	RCALL SUBOPT_0x4
	BRGE _0x23
;     200             {
;     201                 i = (add + 15) % 16;
	MOVW R26,R16
	RCALL SUBOPT_0x17
;     202                 g_deltaValueNext[i] = 16;
	RCALL SUBOPT_0xA
;     203                 g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     204             }
	RCALL SUBOPT_0x18
	RJMP _0x22
_0x23:
;     205 
;     206             SpinWait();
	RCALL _SpinWait
;     207             for (loopCount = 0; loopCount < 16; loopCount++)
	RCALL SUBOPT_0x19
_0x25:
	RCALL SUBOPT_0x1A
	BRGE _0x26
;     208             {
;     209                 for (add = 0; add < 16; add += step)
	RCALL SUBOPT_0x3
_0x28:
	RCALL SUBOPT_0x4
	BRGE _0x29
;     210                 {
;     211                     l = (last + add) % 16;
	RCALL SUBOPT_0x1B
;     212                     c = (current + add) % 16;
	MOVW R30,R16
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x1C
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL __MODW21
	STD  Y+6,R30
	STD  Y+6+1,R31
;     213                     g_deltaValueNext[l] = 256 - 16;
	RCALL SUBOPT_0x1D
;     214                     g_deltaValueNext[c] = 16;
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1E
	LDI  R26,LOW(16)
	STD  Z+0,R26
;     215                     g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     216                 }
	RCALL SUBOPT_0x18
	RJMP _0x28
_0x29:
;     217 
;     218                 SpinWaitClearAndPause(pauseCount);
	LDD  R30,Y+14
	RCALL SUBOPT_0x11
;     219 
;     220                 SpinWait();
;     221 
;     222                 current = (current + 1) % 16;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x12
	STD  Y+12,R30
	STD  Y+12+1,R31
;     223                 last = (last + 1) % 16;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	STD  Y+10,R30
	STD  Y+10+1,R31
;     224             }
	RCALL SUBOPT_0x1F
	RJMP _0x25
_0x26:
;     225             for (add = 0; add < 16; add += step)
	RCALL SUBOPT_0x3
_0x2B:
	RCALL SUBOPT_0x4
	BRGE _0x2C
;     226             {
;     227                 l = (last + add) % 16;
	RCALL SUBOPT_0x1B
;     228                 g_deltaValueNext[l] = 256 - 16;
	RCALL SUBOPT_0x1D
;     229                 g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     230             }
	RCALL SUBOPT_0x18
	RJMP _0x2B
_0x2C:
;     231         }
	RCALL __LOADLOCR6
	ADIW R28,18
	RET
;     232 
;     233 
;     234         void Chase()
;     235         {
_Chase:
;     236             int i;
;     237             int current = 0;
;     238             int last = 15;
;     239             int outer;
;     240             int loopCount;
;     241 
;     242             for (i = 0; i < 16; i++)
	SBIW R28,4
	RCALL __SAVELOCR6
;	i -> R16,R17
;	current -> R18,R19
;	last -> R20,R21
;	outer -> Y+8
;	loopCount -> Y+6
	LDI  R18,0
	LDI  R19,0
	LDI  R20,15
	LDI  R21,0
	RCALL SUBOPT_0x3
_0x2E:
	RCALL SUBOPT_0x4
	BRGE _0x2F
;     243             {
;     244                 g_deltaValueNext[0] = 0;
	LDI  R30,LOW(0)
	STS  _g_deltaValueNext,R30
;     245             }
	RCALL SUBOPT_0x5
	RJMP _0x2E
_0x2F:
;     246 
;     247             SpinWait();
	RCALL _SpinWait
;     248             g_deltaValueNext[14] = 16;
	LDI  R30,LOW(16)
	__PUTB1MN _g_deltaValueNext,14
;     249             g_deltaValueNext[15] = 16;
	__PUTB1MN _g_deltaValueNext,15
;     250             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     251 
;     252             SpinWaitClearAndPause(1);
	RCALL SUBOPT_0x8
;     253 
;     254             SpinWait();
	RCALL _SpinWait
;     255 
;     256             for (outer = 0; outer < 48; outer++)
	LDI  R30,0
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x31:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,48
	BRGE _0x32
;     257             {
;     258                 for (loopCount = 0; loopCount < 14; loopCount++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x34:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,14
	BRGE _0x35
;     259                 {
;     260                     g_deltaValueNext[last] = 256 - 16;
	RCALL SUBOPT_0x20
;     261                     g_deltaValueNext[current] = 16;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xA
;     262                     g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     263 
;     264                     SpinWaitClearAndPause(4);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x11
;     265 
;     266                     SpinWait();
;     267 
;     268                     current = (current + 1) % 16;
	MOVW R26,R18
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
;     269                     last = (last + 1) % 16;
	MOVW R20,R30
;     270                 }
	RCALL SUBOPT_0x16
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x34
_0x35:
;     271                 current = (current + 1) % 16;
	MOVW R26,R18
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
;     272                 last = (last + 1) % 16;
	MOVW R20,R30
;     273             }
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	RCALL SUBOPT_0x15
	RJMP _0x31
_0x32:
;     274             g_deltaValueNext[last] = 256 - 16;
	RCALL SUBOPT_0x20
;     275             last = (last + 15) % 16;
	MOVW R26,R20
	RCALL SUBOPT_0x17
;     276             g_deltaValueNext[last] = 256 - 16;
	LDI  R30,LOW(240)
	ST   X,R30
;     277             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     278         }
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
;     279 
;     280         void HalfAndHalf(int pauseCount)
;     281         {
_HalfAndHalf:
;     282             int i;
;     283             int j;
;     284 
;     285             SpinWait();
	RCALL __SAVELOCR4
;	pauseCount -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	RCALL SUBOPT_0x7
;     286             for (i = 0; i < 16; i++)
_0x37:
	RCALL SUBOPT_0x4
	BRGE _0x38
;     287             {
;     288                 if (i % 2 == 0)
	RCALL SUBOPT_0x21
	BRNE _0x39
;     289                 {
;     290                     g_deltaValueNext[i] = 16;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
;     291                 }
;     292                 else
_0x39:
;     293                 {
;     294 
;     295                 }
;     296             }
	RCALL SUBOPT_0x5
	RJMP _0x37
_0x38:
;     297             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     298             SpinWaitClearAndPause(pauseCount);
	RCALL SUBOPT_0x22
;     299 
;     300             for (j = 0; j < 16; j++)
	RCALL SUBOPT_0x19
_0x3C:
	RCALL SUBOPT_0x1A
	BRGE _0x3D
;     301             {
;     302                 SpinWait();
	RCALL SUBOPT_0x7
;     303                 for (i = 0; i < 16; i++)
_0x3F:
	RCALL SUBOPT_0x4
	BRGE _0x40
;     304                 {
;     305                     if (i % 2 == 0)
	RCALL SUBOPT_0x21
	BRNE _0x41
;     306                     {
;     307                         g_deltaValueNext[i] = 256 - 16;
	RCALL SUBOPT_0x6
	LDI  R30,LOW(240)
	RJMP _0x83
;     308                     }
;     309                     else
_0x41:
;     310                     {
;     311                         g_deltaValueNext[i] = 16;
	RCALL SUBOPT_0x6
	LDI  R30,LOW(16)
_0x83:
	ST   X,R30
;     312                     }
;     313                 }
	RCALL SUBOPT_0x5
	RJMP _0x3F
_0x40:
;     314                 g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     315                 SpinWaitClearAndPause(pauseCount);
	RCALL SUBOPT_0x22
;     316 
;     317                 SpinWait();
	RCALL SUBOPT_0x7
;     318                 for (i = 0; i < 16; i++)
_0x44:
	RCALL SUBOPT_0x4
	BRGE _0x45
;     319                 {
;     320                     if (i % 2 == 0)
	RCALL SUBOPT_0x21
	BRNE _0x46
;     321                     {
;     322                         g_deltaValueNext[i] = 16;
	RCALL SUBOPT_0x6
	LDI  R30,LOW(16)
	RJMP _0x84
;     323                     }
;     324                     else
_0x46:
;     325                     {
;     326                         g_deltaValueNext[i] = 256 - 16;
	RCALL SUBOPT_0x6
	LDI  R30,LOW(240)
_0x84:
	ST   X,R30
;     327                     }
;     328                 }
	RCALL SUBOPT_0x5
	RJMP _0x44
_0x45:
;     329                 g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     330                 SpinWaitClearAndPause(pauseCount);
	RCALL SUBOPT_0x22
;     331             }
	RCALL SUBOPT_0x1F
	RJMP _0x3C
_0x3D:
;     332 
;     333             for (i = 0; i < 16; i++)
	RCALL SUBOPT_0x3
_0x49:
	RCALL SUBOPT_0x4
	BRGE _0x4A
;     334             {
;     335                 if (i % 2 == 0)
	RCALL SUBOPT_0x21
	BRNE _0x4B
;     336                 {
;     337                     g_deltaValueNext[i] = 256 - 16;
	RCALL SUBOPT_0x6
	LDI  R30,LOW(240)
	ST   X,R30
;     338                 }
;     339                 else
_0x4B:
;     340                 {
;     341 
;     342                 }
;     343             }
	RCALL SUBOPT_0x5
	RJMP _0x49
_0x4A:
;     344             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     345             SpinWaitClearAndPause(pauseCount);
	RCALL SUBOPT_0x22
;     346         }
	RJMP _0x81
;     347 
;     348         void Streak(int start)
;     349         {
_Streak:
;     350             int i;
;     351             int current1 = start;
;     352             int current2 = (start + 1) % 16;
;     353             int last1 = 0;
;     354             int last2 = 0;
;     355 
;     356             SpinWaitClearAndPause(1);
	SBIW R28,4
	LDI  R24,4
	RCALL SUBOPT_0x23
	LDI  R30,LOW(_0x4D*2)
	LDI  R31,HIGH(_0x4D*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR6
;	start -> Y+10
;	i -> R16,R17
;	current1 -> R18,R19
;	current2 -> R20,R21
;	last1 -> Y+8
;	last2 -> Y+6
	__GETWRS 18,19,10
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	MOVW R20,R30
	RCALL SUBOPT_0x8
;     357 
;     358             for (i = 0; i < 9; i++)
	RCALL SUBOPT_0x3
_0x4F:
	__CPWRN 16,17,9
	BRGE _0x50
;     359             {
;     360                 SpinWait();
	RCALL _SpinWait
;     361 
;     362                 if (i != 0)
	RCALL SUBOPT_0x1
	BREQ _0x51
;     363                 {
;     364                     g_deltaValueNext[last1] = 256 - 16;
	RCALL SUBOPT_0x1D
;     365                     g_deltaValueNext[last2] = 256 - 16;
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1E
	LDI  R26,LOW(240)
	STD  Z+0,R26
;     366                 }
;     367 
;     368                 if (i != 8)
_0x51:
	RCALL SUBOPT_0x2
	BREQ _0x52
;     369                 {
;     370                     g_deltaValueNext[current1] = 16;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xA
;     371                     g_deltaValueNext[current2] = 16;
	RCALL SUBOPT_0xB
	ADD  R26,R20
	ADC  R27,R21
	RCALL SUBOPT_0xA
;     372                 }
;     373                 last1 = current1;
_0x52:
	__PUTWSR 18,19,8
;     374                 last2 = current2;
	__PUTWSR 20,21,6
;     375 
;     376                 current1 = (current1 + 15) % 16;
	MOVW R26,R18
	ADIW R26,15
	RCALL SUBOPT_0x24
	RCALL __MODW21
	RCALL SUBOPT_0x13
;     377                 current2 = (current2 + 1) % 16;
	MOVW R20,R30
;     378                 g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     379 
;     380                 SpinWaitClearAndPause(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _SpinWaitClearAndPause
;     381             }
	RCALL SUBOPT_0x5
	RJMP _0x4F
_0x50:
;     382         }
_0x82:
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
;     383 
;     384         void DimRandom()
;     385         {
_DimRandom:
;     386             int v[] = { 4, 5, 0, 12, 9, 13, 14, 6, 7, 1, 8, 3, 11, 15, 2, 10 };
;     387             int i;
;     388             int j;
;     389 
;     390             SpinWaitClearAndPause(1);
	SBIW R28,32
	LDI  R24,32
	RCALL SUBOPT_0x23
	LDI  R30,LOW(_0x53*2)
	LDI  R31,HIGH(_0x53*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR4
;	v -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	RCALL SUBOPT_0x8
;     391 
;     392             for (i = 0; i < 16; i++)
	RCALL SUBOPT_0x3
_0x55:
	RCALL SUBOPT_0x4
	BRGE _0x56
;     393             {
;     394                 for (j = 0; j < 4; j++)
	RCALL SUBOPT_0x19
_0x58:
	__CPWRN 18,19,4
	BRGE _0x59
;     395                 {
;     396                     if (i != 0)
	RCALL SUBOPT_0x1
	BREQ _0x5A
;     397                     {
;     398                         g_deltaValueNext[v[i - 1]] = 256 - 4;
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0xF
;     399                     }
;     400 
;     401                     if (i != 15)
_0x5A:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x5B
;     402                     {
;     403                         g_deltaValueNext[v[i]] = 4;
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,4
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x1E
	LDI  R26,LOW(4)
	STD  Z+0,R26
;     404                     }
;     405                     g_deltaCountNext = 4;
_0x5B:
	LDI  R30,LOW(4)
	MOV  R2,R30
;     406 
;     407                     SpinWait();
	RCALL _SpinWait
;     408                 }
	RCALL SUBOPT_0x1F
	RJMP _0x58
_0x59:
;     409 
;     410                 if (i != 0)
	RCALL SUBOPT_0x1
	BREQ _0x5C
;     411                 {
;     412                     g_deltaValueNext[v[i - 1]] = 0;
	RCALL SUBOPT_0x25
	LDI  R26,LOW(0)
	STD  Z+0,R26
;     413                 }
;     414             }
_0x5C:
	RCALL SUBOPT_0x5
	RJMP _0x55
_0x56:
;     415             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     416         }
	RCALL __LOADLOCR4
	ADIW R28,36
	RET
;     417 
;     418         void HandleSide(int spotIncrement, int pauseCount, int index)
;     419         {
_HandleSide:
;     420             g_deltaValueNext[index] = spotIncrement;
;	spotIncrement -> Y+4
;	pauseCount -> Y+2
;	index -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-_g_deltaValueNext)
	SBCI R27,HIGH(-_g_deltaValueNext)
	LDD  R30,Y+4
	ST   X,R30
;     421             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     422 
;     423             SpinWaitClearAndPause(pauseCount);
	LDD  R30,Y+2
	RCALL SUBOPT_0x11
;     424 
;     425             SpinWait();
;     426         }
	ADIW R28,6
	RET
;     427 
;     428         void BounceTrail(int pauseCount)
;     429         {
_BounceTrail:
;     430             int distance;
;     431             int index;
;     432 
;     433             SpinWaitClearAndPause(1);
	RCALL __SAVELOCR4
;	pauseCount -> Y+4
;	distance -> R16,R17
;	index -> R18,R19
	RCALL SUBOPT_0x8
;     434 
;     435             for (distance = 8; distance > 0; distance--)
	__GETWRN 16,17,8
_0x5E:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x5F
;     436             {
;     437                 for (index = 0; index < distance; index++)
	RCALL SUBOPT_0x19
_0x61:
	__CPWRR 18,19,16,17
	BRGE _0x62
;     438                 {
;     439                     HandleSide(16, pauseCount, index);
	RCALL SUBOPT_0x27
;     440                 }
	RCALL SUBOPT_0x1F
	RJMP _0x61
_0x62:
;     441 
;     442                 for (index = distance - 1; index >= 0; index--)
	MOVW R30,R16
	SBIW R30,1
	MOVW R18,R30
_0x64:
	SUBI R18,0
	SBCI R19,0
	BRLT _0x65
;     443                 {
;     444                     HandleSide(256 - 16, pauseCount, index);
	RCALL SUBOPT_0x28
;     445                 }
	__SUBWRN 18,19,1
	RJMP _0x64
_0x65:
;     446 
;     447                 for (index = 15; index > 15 - distance; index--)
	__GETWRN 18,19,15
_0x67:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	SUB  R30,R16
	SBC  R31,R17
	CP   R30,R18
	CPC  R31,R19
	BRGE _0x68
;     448                 {
;     449                     HandleSide(16, pauseCount, index);
	RCALL SUBOPT_0x27
;     450                 }
	__SUBWRN 18,19,1
	RJMP _0x67
_0x68:
;     451 
;     452                 for (index = 8 + (8 - distance); index < 16; index++)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	SUB  R30,R16
	SBC  R31,R17
	ADIW R30,8
	MOVW R18,R30
_0x6A:
	RCALL SUBOPT_0x1A
	BRGE _0x6B
;     453                 {
;     454                     HandleSide(256 - 16, pauseCount, index);
	RCALL SUBOPT_0x28
;     455                 }
	RCALL SUBOPT_0x1F
	RJMP _0x6A
_0x6B:
;     456             }
	__SUBWRN 16,17,1
	RJMP _0x5E
_0x5F:
;     457 
;     458             g_deltaCountNext = 1;
	RCALL SUBOPT_0x9
;     459         }
_0x81:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
;     460 
;     461         void AnimationThread()
;     462         {
_AnimationThread:
;     463             int i;
;     464             int v[] = { 4, 5, 0, 12, 9, 13, 14, 6, 7, 1, 8, 3, 11, 15, 2, 10 };
;     465 
;     466             BounceTrail(4);
	SBIW R28,32
	LDI  R24,32
	RCALL SUBOPT_0x23
	LDI  R30,LOW(_0x6C*2)
	LDI  R31,HIGH(_0x6C*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR2
;	i -> R16,R17
;	v -> Y+2
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x29
	RCALL _BounceTrail
;     467 
;     468             for (i = 0; i < 8; i++)
	RCALL SUBOPT_0x3
_0x6E:
	__CPWRN 16,17,8
	BRGE _0x6F
;     469             {
;     470                 DimRandom();
	RCALL _DimRandom
;     471             }
	RCALL SUBOPT_0x5
	RJMP _0x6E
_0x6F:
;     472 
;     473             {
;     474 
;     475                 for (i = 0; i < 16; i++)
	RCALL SUBOPT_0x3
_0x71:
	RCALL SUBOPT_0x4
	BRGE _0x72
;     476                 {
;     477                     Streak(v[i]);
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,2
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x29
	RCALL _Streak
;     478                     SpinWaitClearAndPause(34);
	LDI  R30,LOW(34)
	ST   -Y,R30
	RCALL _SpinWaitClearAndPause
;     479                 }
	RCALL SUBOPT_0x5
	RJMP _0x71
_0x72:
;     480             }
;     481 
;     482             {
;     483                 for (i = 4; i < 128; i *= 2)
	__GETWRN 16,17,4
_0x74:
	__CPWRN 16,17,128
	BRGE _0x75
;     484                 {
;     485                     HalfAndHalf(i);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _HalfAndHalf
;     486                 }
	LSL  R16
	ROL  R17
	RJMP _0x74
_0x75:
;     487             }
;     488 
;     489             {
;     490                 Chase();
	RCALL _Chase
;     491             }
;     492 
;     493             for (i = 0; i < 4; i++)
	RCALL SUBOPT_0x3
_0x77:
	__CPWRN 16,17,4
	BRGE _0x78
;     494             {
;     495                 //Bounce(4);
;     496             }
	RCALL SUBOPT_0x5
	RJMP _0x77
_0x78:
;     497 
;     498             {
;     499                 char step = 8;
;     500                 while (step >= 2)
	SBIW R28,1
	LDI  R24,1
	RCALL SUBOPT_0x23
	LDI  R30,LOW(_0x79*2)
	LDI  R31,HIGH(_0x79*2)
	RCALL __INITLOCB
;	v -> Y+3
;	step -> Y+0
_0x7A:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRLO _0x7C
;     501                 {
;     502                     Clock(step, 16);
	LD   R30,Y
	LDI  R31,0
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x29
	RCALL _Clock
;     503                     step /= 2;
	LD   R30,Y
	LSR  R30
	ST   Y,R30
;     504                 }
	RJMP _0x7A
_0x7C:
;     505             }
	ADIW R28,1
;     506 
;     507             {
;     508                 Rotate();
	RCALL _Rotate
;     509             }
;     510 
;     511             //AllOnOff();
;     512         }
	RCALL __LOADLOCR2
	ADIW R28,34
	RET
;     513 
;     514 
;     515 
;     516 
;     517 void main(void)
;     518 {
_main:
;     519 // Declare your local variables here
;     520 
;     521 // Crystal Oscillator division factor: 1
;     522 #pragma optsize-
;     523 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x28,R30
;     524 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
;     525 #ifdef _OPTIMIZE_SIZE_
;     526 #pragma optsize+
;     527 #endif
;     528 
;     529 // Input/Output Ports initialization
;     530 // Port A initialization
;     531 // Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
;     532 // State7=0 State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
;     533 PORTA=0x00;
	OUT  0x1B,R30
;     534 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
;     535 
;     536 // Port B initialization
;     537 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
;     538 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
;     539 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     540 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     541 
;     542 // Timer/Counter 0 initialization
;     543 // Clock source: System Clock
;     544 // Clock value: 2500.000 kHz
;     545 // Mode: 8bit CTC top=OCR0A
;     546 TCCR0A=0x01;
	LDI  R30,LOW(1)
	OUT  0x15,R30
;     547 TCCR0B=0x03;    // speed = 8 / 64 MHz = 125 KHz
	LDI  R30,LOW(3)
	OUT  0x33,R30
;     548 TCNT0H=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     549 TCNT0L=0x00;
	OUT  0x32,R30
;     550 OCR0A=0x4E;
	LDI  R30,LOW(78)
	OUT  0x13,R30
;     551 OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     552 TIFR=0x10;      // turn on output compare flag 0 a -
	LDI  R30,LOW(16)
	OUT  0x38,R30
;     553 
;     554 // Timer/Counter 1 initialization
;     555 // Clock source: System Clock
;     556 // Clock value: Timer 1 Stopped
;     557 // Mode: Normal top=OCR1C
;     558 // OC1A output: Discon.
;     559 // OC1B output: Discon.
;     560 // OC1C output: Discon.
;     561 // Fault Protection Mode: Off
;     562 // Fault Protection Noise Canceler: Off
;     563 // Fault Protection triggered on Falling Edge
;     564 // Fault Protection triggered by the Analog Comparator: Off
;     565 // Timer 1 Overflow Interrupt: Off
;     566 // Compare A Match Interrupt: Off
;     567 // Compare B Match Interrupt: Off
;     568 // Compare D Match Interrupt: Off
;     569 // Fault Protection Interrupt: Off
;     570 PLLCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
;     571 TCCR1A=0x00;
	OUT  0x30,R30
;     572 TCCR1B=0x00;
	OUT  0x2F,R30
;     573 TCCR1C=0x00;
	OUT  0x27,R30
;     574 TCCR1D=0x00;
	OUT  0x26,R30
;     575 TCCR1E=0x00;
	OUT  0x0,R30
;     576 TC1H=0x00;
	OUT  0x25,R30
;     577 TCNT1=0x00;
	OUT  0x2E,R30
;     578 OCR1A=0x00;
	OUT  0x2D,R30
;     579 OCR1B=0x00;
	OUT  0x2C,R30
;     580 OCR1C=0x00;
	OUT  0x2B,R30
;     581 OCR1D=0x00;
	OUT  0x2A,R30
;     582 DT1=0x00;
	OUT  0x24,R30
;     583 
;     584 // External Interrupt(s) initialization
;     585 // INT0: Off
;     586 // INT1: Off
;     587 // Interrupt on any change on pins PCINT0-7, 12-15: Off
;     588 // Interrupt on any change on pins PCINT8-11: Off
;     589 MCUCR=0x00;
	OUT  0x35,R30
;     590 GIMSK=0x00;
	OUT  0x3B,R30
;     591 
;     592 // Timer(s)/Counter(s) Interrupt(s) initialization
;     593 TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
;     594 
;     595 // Universal Serial Interface initialization
;     596 // Mode: Disabled
;     597 // Clock source: Register & Counter=no clk.
;     598 // USI Counter Overflow Interrupt: Off
;     599 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;     600 
;     601 // Analog Comparator initialization
;     602 // Analog Comparator: Off
;     603 ACSRA=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     604 // Hysterezis level: 0 mV
;     605 ACSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x9,R30
;     606 
;     607 // Global enable interrupts
;     608 #asm("sei")
	sei
;     609 
;     610 while (1)
_0x7D:
;     611 {
;     612     AnimationThread();
	RCALL _AnimationThread
;     613 }
	RJMP _0x7D
;     614 
;     615 }
_0x80:
	RJMP _0x80


;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_g_currentValue)
	LDI  R27,HIGH(_g_currentValue)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CP   R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOV  R0,R16
	OR   R0,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	__CPWRN 16,17,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_g_deltaValueNext)
	LDI  R27,HIGH(_g_deltaValueNext)
	ADD  R26,R16
	ADC  R27,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL _SpinWait
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _SpinWaitClearAndPause

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	MOV  R2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(16)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_g_deltaValueNext)
	LDI  R27,HIGH(_g_deltaValueNext)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ADD  R26,R18
	ADC  R27,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ST   X,R30
	RCALL SUBOPT_0xB
	ADD  R26,R20
	ADC  R27,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	ST   X,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUBI R30,LOW(-_g_deltaValueNext)
	SBCI R31,HIGH(-_g_deltaValueNext)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(252)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_g_deltaValueNext)
	SBCI R31,HIGH(-_g_deltaValueNext)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	RCALL _SpinWaitClearAndPause
	RJMP _SpinWait

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x12:
	ADIW R26,1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	MOVW R18,R30
	MOVW R26,R20
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	ADIW R26,15
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL __MODW21
	MOVW R20,R30
	RCALL SUBOPT_0xB
	ADD  R26,R20
	ADC  R27,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	__ADDWRR 16,17,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__CPWRN 18,19,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	MOVW R30,R16
	RCALL SUBOPT_0x14
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL __MODW21
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_g_deltaValueNext)
	SBCI R31,HIGH(-_g_deltaValueNext)
	LDI  R26,LOW(240)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	SUBI R30,LOW(-_g_deltaValueNext)
	SBCI R31,HIGH(-_g_deltaValueNext)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	__ADDWRN 18,19,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0xB
	ADD  R26,R20
	ADC  R27,R21
	LDI  R30,LOW(240)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x21:
	MOVW R26,R16
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	LDD  R30,Y+4
	ST   -Y,R30
	RJMP _SpinWaitClearAndPause

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	MOVW R30,R16
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,4
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x1C
	RCALL __GETW1P
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x1C
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x24
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x16
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	RJMP _HandleSide

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x16
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	RJMP _HandleSide

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	ST   -Y,R31
	ST   -Y,R30
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
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
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
