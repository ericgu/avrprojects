
;CodeVisionAVR C Compiler V2.04.5b Standard
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8515L
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8515L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCSR=0x34
	.EQU MCUCR=0x35
	.EQU EMCUCR=0x36
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _g_waitCount=R5
	.DEF _g_nextWaitCount=R4
	.DEF _value=R6

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x65:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x06
	.DW  _0x65*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30
	OUT  EMCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
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

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.5b Standard
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 11/24/2010
;Author  : Eric
;Company :
;Comments:
;
;
;Chip type               : ATmega8515L
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*****************************************************/
;
;#include <mega8515.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif
;
;#define FRAME0 0
;#define FRAME1 1
;#define FRAME2 2
;#define FRAME3 3
;#define FRAME4 4
;#define FRAME5 5
;#define FRAME6 6
;#define FRAME7 7
;#define SNOWBOTTOM 8
;#define SNOWMIDDLE 9
;#define SNOWTOP 10
;#define HAT 11
;#define EYELEFT 12
;#define EYERIGHT 13
;#define NOSE 14
;#define MOUTH 15
;
;char g_waitCount;          // number of cycles to stay with this state
;
;char g_nextValue[16];       // next state of the lights
;char g_nextWaitCount;      // count for the next state
;
;#define GetChannelValue(i) ((g_nextValue[i] != 0) ? 1 : 0)
;
;int value = 0;
;
;void CopyToOutput(void)
; 0000 0035 {

	.CSEG
_CopyToOutput:
; 0000 0036     PORTA.0 = GetChannelValue(0);
	LDS  R26,_g_nextValue
	CPI  R26,LOW(0x0)
	BREQ _0x3
	LDI  R30,LOW(1)
	RJMP _0x4
_0x3:
	LDI  R30,LOW(0)
_0x4:
	CPI  R30,0
	BRNE _0x6
	CBI  0x1B,0
	RJMP _0x7
_0x6:
	SBI  0x1B,0
_0x7:
; 0000 0037     PORTA.1 = GetChannelValue(1);
	__GETB2MN _g_nextValue,1
	CPI  R26,LOW(0x0)
	BREQ _0x8
	LDI  R30,LOW(1)
	RJMP _0x9
_0x8:
	LDI  R30,LOW(0)
_0x9:
	CPI  R30,0
	BRNE _0xB
	CBI  0x1B,1
	RJMP _0xC
_0xB:
	SBI  0x1B,1
_0xC:
; 0000 0038     PORTA.2 = GetChannelValue(2);
	__GETB2MN _g_nextValue,2
	CPI  R26,LOW(0x0)
	BREQ _0xD
	LDI  R30,LOW(1)
	RJMP _0xE
_0xD:
	LDI  R30,LOW(0)
_0xE:
	CPI  R30,0
	BRNE _0x10
	CBI  0x1B,2
	RJMP _0x11
_0x10:
	SBI  0x1B,2
_0x11:
; 0000 0039     PORTA.3 = GetChannelValue(3);
	__GETB2MN _g_nextValue,3
	CPI  R26,LOW(0x0)
	BREQ _0x12
	LDI  R30,LOW(1)
	RJMP _0x13
_0x12:
	LDI  R30,LOW(0)
_0x13:
	CPI  R30,0
	BRNE _0x15
	CBI  0x1B,3
	RJMP _0x16
_0x15:
	SBI  0x1B,3
_0x16:
; 0000 003A     PORTA.4 = GetChannelValue(4);
	__GETB2MN _g_nextValue,4
	CPI  R26,LOW(0x0)
	BREQ _0x17
	LDI  R30,LOW(1)
	RJMP _0x18
_0x17:
	LDI  R30,LOW(0)
_0x18:
	CPI  R30,0
	BRNE _0x1A
	CBI  0x1B,4
	RJMP _0x1B
_0x1A:
	SBI  0x1B,4
_0x1B:
; 0000 003B     PORTA.5 = GetChannelValue(5);
	__GETB2MN _g_nextValue,5
	CPI  R26,LOW(0x0)
	BREQ _0x1C
	LDI  R30,LOW(1)
	RJMP _0x1D
_0x1C:
	LDI  R30,LOW(0)
_0x1D:
	CPI  R30,0
	BRNE _0x1F
	CBI  0x1B,5
	RJMP _0x20
_0x1F:
	SBI  0x1B,5
_0x20:
; 0000 003C     PORTA.6 = GetChannelValue(6);
	__GETB2MN _g_nextValue,6
	CPI  R26,LOW(0x0)
	BREQ _0x21
	LDI  R30,LOW(1)
	RJMP _0x22
_0x21:
	LDI  R30,LOW(0)
_0x22:
	CPI  R30,0
	BRNE _0x24
	CBI  0x1B,6
	RJMP _0x25
_0x24:
	SBI  0x1B,6
_0x25:
; 0000 003D     PORTA.7 = GetChannelValue(7);
	__GETB2MN _g_nextValue,7
	CPI  R26,LOW(0x0)
	BREQ _0x26
	LDI  R30,LOW(1)
	RJMP _0x27
_0x26:
	LDI  R30,LOW(0)
_0x27:
	CPI  R30,0
	BRNE _0x29
	CBI  0x1B,7
	RJMP _0x2A
_0x29:
	SBI  0x1B,7
_0x2A:
; 0000 003E 
; 0000 003F     PORTC.0 = GetChannelValue(8);
	__GETB2MN _g_nextValue,8
	CPI  R26,LOW(0x0)
	BREQ _0x2B
	LDI  R30,LOW(1)
	RJMP _0x2C
_0x2B:
	LDI  R30,LOW(0)
_0x2C:
	CPI  R30,0
	BRNE _0x2E
	CBI  0x15,0
	RJMP _0x2F
_0x2E:
	SBI  0x15,0
_0x2F:
; 0000 0040     PORTC.1 = GetChannelValue(9);
	__GETB2MN _g_nextValue,9
	CPI  R26,LOW(0x0)
	BREQ _0x30
	LDI  R30,LOW(1)
	RJMP _0x31
_0x30:
	LDI  R30,LOW(0)
_0x31:
	CPI  R30,0
	BRNE _0x33
	CBI  0x15,1
	RJMP _0x34
_0x33:
	SBI  0x15,1
_0x34:
; 0000 0041     PORTC.2 = GetChannelValue(10);
	__GETB2MN _g_nextValue,10
	CPI  R26,LOW(0x0)
	BREQ _0x35
	LDI  R30,LOW(1)
	RJMP _0x36
_0x35:
	LDI  R30,LOW(0)
_0x36:
	CPI  R30,0
	BRNE _0x38
	CBI  0x15,2
	RJMP _0x39
_0x38:
	SBI  0x15,2
_0x39:
; 0000 0042     PORTC.3 = GetChannelValue(11);
	__GETB2MN _g_nextValue,11
	CPI  R26,LOW(0x0)
	BREQ _0x3A
	LDI  R30,LOW(1)
	RJMP _0x3B
_0x3A:
	LDI  R30,LOW(0)
_0x3B:
	CPI  R30,0
	BRNE _0x3D
	CBI  0x15,3
	RJMP _0x3E
_0x3D:
	SBI  0x15,3
_0x3E:
; 0000 0043     PORTC.4 = GetChannelValue(12);
	__GETB2MN _g_nextValue,12
	CPI  R26,LOW(0x0)
	BREQ _0x3F
	LDI  R30,LOW(1)
	RJMP _0x40
_0x3F:
	LDI  R30,LOW(0)
_0x40:
	CPI  R30,0
	BRNE _0x42
	CBI  0x15,4
	RJMP _0x43
_0x42:
	SBI  0x15,4
_0x43:
; 0000 0044     PORTC.5 = GetChannelValue(13);
	__GETB2MN _g_nextValue,13
	CPI  R26,LOW(0x0)
	BREQ _0x44
	LDI  R30,LOW(1)
	RJMP _0x45
_0x44:
	LDI  R30,LOW(0)
_0x45:
	CPI  R30,0
	BRNE _0x47
	CBI  0x15,5
	RJMP _0x48
_0x47:
	SBI  0x15,5
_0x48:
; 0000 0045     PORTC.6 = GetChannelValue(14);
	__GETB2MN _g_nextValue,14
	CPI  R26,LOW(0x0)
	BREQ _0x49
	LDI  R30,LOW(1)
	RJMP _0x4A
_0x49:
	LDI  R30,LOW(0)
_0x4A:
	CPI  R30,0
	BRNE _0x4C
	CBI  0x15,6
	RJMP _0x4D
_0x4C:
	SBI  0x15,6
_0x4D:
; 0000 0046     PORTC.7 = GetChannelValue(15);
	__GETB2MN _g_nextValue,15
	CPI  R26,LOW(0x0)
	BREQ _0x4E
	LDI  R30,LOW(1)
	RJMP _0x4F
_0x4E:
	LDI  R30,LOW(0)
_0x4F:
	CPI  R30,0
	BRNE _0x51
	CBI  0x15,7
	RJMP _0x52
_0x51:
	SBI  0x15,7
_0x52:
; 0000 0047 }
	RET
;
;// Timer 0 overflow interrupt service routine
;// This runs at approximately 60 Hz
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 004D {
_timer0_ovf_isr:
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
; 0000 004E     // Reinitialize Timer 0 value
; 0000 004F     TCNT0=0x7D;
	LDI  R30,LOW(125)
	OUT  0x32,R30
; 0000 0050 
; 0000 0051     // if the wait is over, we copy the new values over and reset the wait count.
; 0000 0052     if (g_waitCount == 0)
	TST  R5
	BRNE _0x53
; 0000 0053     {
; 0000 0054         CopyToOutput();
	RCALL _CopyToOutput
; 0000 0055 
; 0000 0056             // Get the wait count. The main thread is waiting for g_nextWaitCount to be set to zero, so
; 0000 0057             // clearing it here will unblock the thread to figure out the next step in the animation...
; 0000 0058         g_waitCount = g_nextWaitCount;
	MOV  R5,R4
; 0000 0059         g_nextWaitCount = 0;
	CLR  R4
; 0000 005A     }
; 0000 005B     else
	RJMP _0x54
_0x53:
; 0000 005C     {
; 0000 005D         g_waitCount--;
	DEC  R5
; 0000 005E     }
_0x54:
; 0000 005F }
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
;
;void SpinWait()
; 0000 0062 {
_SpinWait:
; 0000 0063     while (g_nextWaitCount != 0)
_0x55:
	TST  R4
	BRNE _0x55
; 0000 0064     {
; 0000 0065     }
; 0000 0066 }
	RET
;
;void SpinWaitClearAndPause(char pauseCount)
; 0000 0069 {
_SpinWaitClearAndPause:
; 0000 006A     char i;
; 0000 006B 
; 0000 006C     SpinWait();
	ST   -Y,R17
;	pauseCount -> Y+1
;	i -> R17
	RCALL _SpinWait
; 0000 006D     for (i = 0; i < 15; i++)
	LDI  R17,LOW(0)
_0x59:
	CPI  R17,15
	BRSH _0x5A
; 0000 006E     {
; 0000 006F         g_nextValue[i] = 0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_g_nextValue)
	SBCI R31,HIGH(-_g_nextValue)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0070     }
	SUBI R17,-1
	RJMP _0x59
_0x5A:
; 0000 0071     g_nextWaitCount = pauseCount;
	LDD  R4,Y+1
; 0000 0072 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;
;void init(void);
;
;// Declare your global variables here
;
;
;void Juggle(char wait)
; 0000 007B {
; 0000 007C     int iteration = 0;
; 0000 007D     int current = 7;
; 0000 007E 
; 0000 007F     while (iteration < 80)
;	wait -> Y+4
;	iteration -> R16,R17
;	current -> R18,R19
; 0000 0080     {
; 0000 0081         SpinWait();
; 0000 0082         g_nextValue[current] = 0;
; 0000 0083         current = (current + 1) % 8;
; 0000 0084         g_nextValue[current] = 1;
; 0000 0085         g_nextWaitCount = wait;
; 0000 0086 
; 0000 0087         iteration++;
; 0000 0088     }
; 0000 0089 
; 0000 008A     SpinWaitClearAndPause(wait);
; 0000 008B }
;
;void Sequence()
; 0000 008E {
_Sequence:
; 0000 008F     int last = 15;
; 0000 0090     int i;
; 0000 0091     g_nextValue[15] = 1;
	RCALL __SAVELOCR4
;	last -> R16,R17
;	i -> R18,R19
	__GETWRN 16,17,15
	LDI  R30,LOW(1)
	__PUTB1MN _g_nextValue,15
; 0000 0092 
; 0000 0093     for (i = 0; i < 16; i++)
	__GETWRN 18,19,0
_0x5F:
	__CPWRN 18,19,16
	BRGE _0x60
; 0000 0094     {
; 0000 0095         g_nextValue[last] = 0;
	LDI  R26,LOW(_g_nextValue)
	LDI  R27,HIGH(_g_nextValue)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0096         g_nextValue[i] = 1;
	LDI  R26,LOW(_g_nextValue)
	LDI  R27,HIGH(_g_nextValue)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 0097 
; 0000 0098         last = (last + 1) % 16;
	MOVW R26,R16
	ADIW R26,1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL __MODW21
	MOVW R16,R30
; 0000 0099         g_nextWaitCount = 30;
	LDI  R30,LOW(30)
	MOV  R4,R30
; 0000 009A         SpinWait();
	RCALL _SpinWait
; 0000 009B     }
	__ADDWRN 18,19,1
	RJMP _0x5F
_0x60:
; 0000 009C 
; 0000 009D     SpinWaitClearAndPause(30);
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL _SpinWaitClearAndPause
; 0000 009E }
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;
;
;void main(void)
; 0000 00A2 {
_main:
; 0000 00A3 int i = 0;
; 0000 00A4 long int j = 0;
; 0000 00A5 // Declare your local variables here
; 0000 00A6 
; 0000 00A7 init();
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	i -> R16,R17
;	j -> Y+0
	__GETWRN 16,17,0
	RCALL _init
; 0000 00A8 
; 0000 00A9 
; 0000 00AA // Global enable interrupts
; 0000 00AB #asm("sei")
	sei
; 0000 00AC 
; 0000 00AD while (1)
_0x61:
; 0000 00AE       {
; 0000 00AF         Sequence();
	RCALL _Sequence
; 0000 00B0         //Juggle(10);
; 0000 00B1       };
	RJMP _0x61
; 0000 00B2 
; 0000 00B3 
; 0000 00B4 }
_0x64:
	NOP
	RJMP _0x64
;
;void init(void)
; 0000 00B7 {
_init:
; 0000 00B8 // Input/Output Ports initialization
; 0000 00B9 // Port A initialization
; 0000 00BA // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00BB // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00BC PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00BD DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 00BE 
; 0000 00BF // Port B initialization
; 0000 00C0 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C1 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00C2 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00C3 DDRB=0x00;
	OUT  0x17,R30
; 0000 00C4 
; 0000 00C5 // Port C initialization
; 0000 00C6 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00C7 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00C8 PORTC=0x00;
	OUT  0x15,R30
; 0000 00C9 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00CA 
; 0000 00CB // Port D initialization
; 0000 00CC // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00CD // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00CE PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00CF DDRD=0x00;
	OUT  0x11,R30
; 0000 00D0 
; 0000 00D1 // Port E initialization
; 0000 00D2 // Func2=In Func1=In Func0=In
; 0000 00D3 // State2=T State1=T State0=T
; 0000 00D4 PORTE=0x00;
	OUT  0x7,R30
; 0000 00D5 DDRE=0x00;
	OUT  0x6,R30
; 0000 00D6 
; 0000 00D7 // Timer/Counter 0 initialization
; 0000 00D8 // Clock source: System Clock
; 0000 00D9 // Clock value: 7.813 kHz
; 0000 00DA // Mode: Normal top=FFh
; 0000 00DB // OC0 output: Disconnected
; 0000 00DC TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00DD TCNT0=0x7D;
	LDI  R30,LOW(125)
	OUT  0x32,R30
; 0000 00DE OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 00DF 
; 0000 00E0 // Timer/Counter 1 initialization
; 0000 00E1 // Clock source: System Clock
; 0000 00E2 // Clock value: Timer1 Stopped
; 0000 00E3 // Mode: Normal top=FFFFh
; 0000 00E4 // OC1A output: Discon.
; 0000 00E5 // OC1B output: Discon.
; 0000 00E6 // Noise Canceler: Off
; 0000 00E7 // Input Capture on Falling Edge
; 0000 00E8 // Timer1 Overflow Interrupt: Off
; 0000 00E9 // Input Capture Interrupt: Off
; 0000 00EA // Compare A Match Interrupt: Off
; 0000 00EB // Compare B Match Interrupt: Off
; 0000 00EC TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00ED TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00EE TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00EF TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00F0 ICR1H=0x00;
	OUT  0x25,R30
; 0000 00F1 ICR1L=0x00;
	OUT  0x24,R30
; 0000 00F2 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F3 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F4 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F5 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00F6 
; 0000 00F7 // External Interrupt(s) initialization
; 0000 00F8 // INT0: Off
; 0000 00F9 // INT1: Off
; 0000 00FA // INT2: Off
; 0000 00FB MCUCR=0x00;
	OUT  0x35,R30
; 0000 00FC EMCUCR=0x00;
	OUT  0x36,R30
; 0000 00FD 
; 0000 00FE // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00FF TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0100 
; 0000 0101 // Analog Comparator initialization
; 0000 0102 // Analog Comparator: Off
; 0000 0103 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0104 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0105 }
	RET

	.DSEG
_g_nextValue:
	.BYTE 0x10

	.CSEG

	.CSEG
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

;END OF CODE MARKER
__END_OF_CODE:
