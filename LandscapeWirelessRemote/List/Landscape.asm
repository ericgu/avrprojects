
;CodeVisionAVR C Compiler V2.04.5b Standard
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313V
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313V
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R3
	.DEF _rx_rd_index=R2
	.DEF _rx_counter=R5
	.DEF _state=R4

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x4001D:
	.DB  0x0
_0x60000:
	.DB  0x45,0x47,0x30,0xD,0x0,0x45,0x47,0x31
	.DB  0xD,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x04
	.DW  _0x4001D*2

_0xFFFFFFFF:
	.DW  0

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
	LDI  R24,(14-2)+1
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
	LDI  R30,0x00
	OUT  GPIOR0,R30
	OUT  GPIOR1,R30
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x80)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include "project.h"
;
;#if 0
;void D(char v)
;{
;    PORTB = 255 - v;
;}
;#endif
;
;
;void main(void)
; 0000 000F {

	.CSEG
_main:
; 0000 0010     init();
	RCALL _init
; 0000 0011 
; 0000 0012     while (1)
_0x3:
; 0000 0013     {
; 0000 0014         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0015     }
	RJMP _0x3
; 0000 0016 }
_0x6:
	RJMP _0x6
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;
;void init(void)
; 0001 0004 {

	.CSEG
_init:
; 0001 0005 // Crystal Oscillator division factor: 1
; 0001 0006 #pragma optsize-
; 0001 0007 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0001 0008 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0001 0009 #ifdef _OPTIMIZE_SIZE_
; 0001 000A #pragma optsize+
; 0001 000B #endif
; 0001 000C 
; 0001 000D // Input/Output Ports initialization
; 0001 000E // Port A initialization
; 0001 000F // Func2=In Func1=In Func0=Out
; 0001 0010 // State2=T State1=T State0=0
; 0001 0011 PORTA=0x00;
	OUT  0x1B,R30
; 0001 0012 DDRA=0x01;
	LDI  R30,LOW(1)
	OUT  0x1A,R30
; 0001 0013 
; 0001 0014 // Port B initialization
; 0001 0015 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0001 0016 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=P
; 0001 0017 PORTB=0x01;
	OUT  0x18,R30
; 0001 0018 DDRB=0xFE;
	LDI  R30,LOW(254)
	OUT  0x17,R30
; 0001 0019 
; 0001 001A // Port D initialization
; 0001 001B // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0001 001C // State6=P State5=P State4=P State3=P State2=P State1=T State0=T
; 0001 001D PORTD=0x7C;
	LDI  R30,LOW(124)
	OUT  0x12,R30
; 0001 001E DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0001 001F 
; 0001 0020 // Timer/Counter 0 initialization
; 0001 0021 // Clock source: System Clock
; 0001 0022 // Clock value: Timer 0 Stopped
; 0001 0023 // Mode: Normal top=FFh
; 0001 0024 // OC0A output: Disconnected
; 0001 0025 // OC0B output: Disconnected
; 0001 0026 TCCR0A=0x00;
	OUT  0x30,R30
; 0001 0027 TCCR0B=0x00;
	OUT  0x33,R30
; 0001 0028 TCNT0=0x00;
	OUT  0x32,R30
; 0001 0029 OCR0A=0x00;
	OUT  0x36,R30
; 0001 002A OCR0B=0x00;
	OUT  0x3C,R30
; 0001 002B 
; 0001 002C // Timer/Counter 1 initialization
; 0001 002D // Clock source: System Clock
; 0001 002E // Clock value: 31.250 kHz
; 0001 002F // Mode: Normal top=FFFFh
; 0001 0030 // OC1A output: Discon.
; 0001 0031 // OC1B output: Discon.
; 0001 0032 // Noise Canceler: Off
; 0001 0033 // Input Capture on Falling Edge
; 0001 0034 // Timer1 Overflow Interrupt: On
; 0001 0035 // Input Capture Interrupt: Off
; 0001 0036 // Compare A Match Interrupt: Off
; 0001 0037 // Compare B Match Interrupt: Off
; 0001 0038 TCCR1A=0x00;
	OUT  0x2F,R30
; 0001 0039 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0001 003A TCNT1H=0xF3;
	RCALL SUBOPT_0x0
; 0001 003B TCNT1L=0xCA;
; 0001 003C ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0001 003D ICR1L=0x00;
	OUT  0x24,R30
; 0001 003E OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 003F OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 0040 OCR1BH=0x00;
	OUT  0x29,R30
; 0001 0041 OCR1BL=0x00;
	OUT  0x28,R30
; 0001 0042 
; 0001 0043 // External Interrupt(s) initialization
; 0001 0044 // INT0: Off
; 0001 0045 // INT1: Off
; 0001 0046 // Interrupt on any change on pins PCINT0-7: Off
; 0001 0047 GIMSK=0x00;
	OUT  0x3B,R30
; 0001 0048 MCUCR=0x00;
	OUT  0x35,R30
; 0001 0049 
; 0001 004A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 004B TIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0001 004C 
; 0001 004D // Universal Serial Interface initialization
; 0001 004E // Mode: Disabled
; 0001 004F // Clock source: Register & Counter=no clk.
; 0001 0050 // USI Counter Overflow Interrupt: Off
; 0001 0051 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0001 0052 
; 0001 0053 // USART initialization
; 0001 0054 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0055 // USART Receiver: On
; 0001 0056 // USART Transmitter: On
; 0001 0057 // USART Mode: Asynchronous
; 0001 0058 // USART Baud Rate: 9600
; 0001 0059 UCSRA=0x00;
	OUT  0xB,R30
; 0001 005A UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0001 005B UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0001 005C UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0001 005D UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0001 005E 
; 0001 005F // Analog Comparator initialization
; 0001 0060 // Analog Comparator: Off
; 0001 0061 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0001 0062 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0001 0063 
; 0001 0064 // Global enable interrupts
; 0001 0065 #asm("sei")
	sei
; 0001 0066 }
	RET
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include "project.h"
;
;//#define RXB8 1
;//#define TXB8 0
;//#define UPE 2
;#define OVR 3
;//#define FE 4
;//#define UDRE 5
;//#define RXC 7
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;
;char command;
;char command_ready = 0;
;
;
;char state = 0;
;
;void HandleChar(char c)
; 0002 0026 {

	.CSEG
_HandleChar:
; 0002 0027     switch (state)
;	c -> Y+0
	MOV  R30,R4
	LDI  R31,0
; 0002 0028     {
; 0002 0029         case 0: // ready;
	SBIW R30,0
	BRNE _0x40006
; 0002 002A             if (c == 'O') state = 1;
	LD   R26,Y
	CPI  R26,LOW(0x4F)
	BRNE _0x40007
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0002 002B             if (c == 'S') state = 5;
_0x40007:
	LD   R26,Y
	CPI  R26,LOW(0x53)
	BRNE _0x40008
	LDI  R30,LOW(5)
	MOV  R4,R30
; 0002 002C             break;
_0x40008:
	RJMP _0x40005
; 0002 002D 
; 0002 002E         case 1: // "O"
_0x40006:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x40009
; 0002 002F             if (c == 'K') state = 2;
	LD   R26,Y
	CPI  R26,LOW(0x4B)
	BRNE _0x4000A
	LDI  R30,LOW(2)
	MOV  R4,R30
; 0002 0030             else state = 0;
	RJMP _0x4000B
_0x4000A:
	CLR  R4
; 0002 0031             break;
_0x4000B:
	RJMP _0x40005
; 0002 0032 
; 0002 0033         case 2: // "OK"
_0x40009:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4000C
; 0002 0034             if (c == '\r')
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x4000D
; 0002 0035             {
; 0002 0036                 command = COMMAND_OK;
	LDI  R30,LOW(1)
	STS  _command,R30
; 0002 0037                 command_ready = 1;
	STS  _command_ready,R30
; 0002 0038                 state = 0;
; 0002 0039             }
; 0002 003A             else state = 0;
_0x4000D:
_0x4001C:
	CLR  R4
; 0002 003B             break;
	RJMP _0x40005
; 0002 003C 
; 0002 003D         case 5: // 'S'
_0x4000C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x40005
; 0002 003E             if (c == '1')
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x40010
; 0002 003F             {
; 0002 0040                 AllOn();
	RCALL _AllOn
; 0002 0041             }
; 0002 0042             else if (c == '0')
	RJMP _0x40011
_0x40010:
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRNE _0x40012
; 0002 0043             {
; 0002 0044                 AllOff();
	RCALL _AllOff
; 0002 0045             }
; 0002 0046             state = 0;
_0x40012:
_0x40011:
	CLR  R4
; 0002 0047             break;
; 0002 0048     }
_0x40005:
; 0002 0049 }
	RJMP _0x2060001
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0002 0050 {
_usart_rx_isr:
	RCALL SUBOPT_0x1
; 0002 0051 char status,data;
; 0002 0052 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0002 0053 data=UDR;
	IN   R16,12
; 0002 0054    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x40013
; 0002 0055    {
; 0002 0056    rx_buffer[rx_wr_index]=data;
	MOV  R30,R3
	SUBI R30,-LOW(_rx_buffer)
	ST   Z,R16
; 0002 0057    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R3
	LDI  R30,LOW(8)
	CP   R30,R3
	BRNE _0x40014
	CLR  R3
; 0002 0058    if (++rx_counter == RX_BUFFER_SIZE)
_0x40014:
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x40015
; 0002 0059       {
; 0002 005A       rx_counter=0;
	CLR  R5
; 0002 005B       rx_buffer_overflow=1;
	SBI  0x13,0
; 0002 005C       };
_0x40015:
; 0002 005D 
; 0002 005E       HandleChar(data);
	ST   -Y,R16
	RCALL _HandleChar
; 0002 005F 
; 0002 0060    };
_0x40013:
; 0002 0061 }
	RCALL __LOADLOCR2P
	RCALL SUBOPT_0x2
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0002 0068 {
; 0002 0069 char data;
; 0002 006A while (rx_counter==0);
;	data -> R17
; 0002 006B data=rx_buffer[rx_rd_index];
; 0002 006C if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0002 006D #asm("cli")
; 0002 006E --rx_counter;
; 0002 006F #asm("sei")
; 0002 0070 return data;
; 0002 0071 }
;#pragma used-
;#endif
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include "project.h"
;
;#define TIMEOUT_IN_TENTHS (10*34)
;
;static int timeRemainingTenths = 0;   // time before lights go off
;static char outputState = 0;
;static char tenths = 0;
;
;#define ALLOFF PIND.2
;#define ALLON PIND.3
;#define ON1 PIND.4
;#define ON2 PIND.5
;#define ON3 PIND.6
;#define STATUS PORTB.7
;
;void TurnOn(void)
; 0003 0014 {

	.CSEG
_TurnOn:
; 0003 0015     timeRemainingTenths = TIMEOUT_IN_TENTHS;
	LDI  R30,LOW(340)
	LDI  R31,HIGH(340)
	STS  _timeRemainingTenths_G003,R30
	STS  _timeRemainingTenths_G003+1,R31
; 0003 0016 }
	RET
;
;void AllOff(void)
; 0003 0019 {
_AllOff:
; 0003 001A     outputState = 0;
	RCALL SUBOPT_0x3
; 0003 001B     timeRemainingTenths = 0;
	STS  _timeRemainingTenths_G003,R30
	STS  _timeRemainingTenths_G003+1,R30
; 0003 001C }
	RET
;
;void AllOn(void)
; 0003 001F {
_AllOn:
; 0003 0020     outputState = 30;
	LDI  R30,LOW(30)
	STS  _outputState_G003,R30
; 0003 0021     TurnOn();
	RCALL _TurnOn
; 0003 0022 }
	RET
;
;
;void HandleButtons()
; 0003 0026 {
_HandleButtons:
; 0003 0027     if (ALLOFF == 0)
	SBIC 0x10,2
	RJMP _0x60003
; 0003 0028     {
; 0003 0029         AllOff();
	RCALL _AllOff
; 0003 002A     }
; 0003 002B     else if (ALLON == 0)
	RJMP _0x60004
_0x60003:
	SBIC 0x10,3
	RJMP _0x60005
; 0003 002C     {
; 0003 002D         AllOn();
	RCALL _AllOn
; 0003 002E     }
; 0003 002F     else if (ON1 == 0)
	RJMP _0x60006
_0x60005:
	SBIC 0x10,4
	RJMP _0x60007
; 0003 0030     {
; 0003 0031         outputState |= 1 << 1;
	RCALL SUBOPT_0x4
	ORI  R30,2
	RJMP _0x6001E
; 0003 0032         TurnOn();
; 0003 0033     }
; 0003 0034     else if (ON2 == 0)
_0x60007:
	SBIC 0x10,5
	RJMP _0x60009
; 0003 0035     {
; 0003 0036         outputState |= 1 << 2;
	RCALL SUBOPT_0x4
	ORI  R30,4
	RJMP _0x6001E
; 0003 0037         TurnOn();
; 0003 0038     }
; 0003 0039     else if (ON3 == 0)
_0x60009:
	SBIC 0x10,6
	RJMP _0x6000B
; 0003 003A     {
; 0003 003B         outputState |= 1 << 3;
	RCALL SUBOPT_0x4
	ORI  R30,8
_0x6001E:
	STS  _outputState_G003,R30
; 0003 003C         TurnOn();
	RCALL _TurnOn
; 0003 003D     }
; 0003 003E }
_0x6000B:
_0x60006:
_0x60004:
	RET
;
;void SendString(char flash *string)
; 0003 0041 {
_SendString:
; 0003 0042     while (*string != 0)
;	*string -> Y+0
_0x6000C:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x6000E
; 0003 0043     {
; 0003 0044         putchar(*string);
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0003 0045         string++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0003 0046     }
	RJMP _0x6000C
_0x6000E:
; 0003 0047 }
	ADIW R28,2
	RET
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0003 004B {
_timer1_ovf_isr:
	RCALL SUBOPT_0x1
; 0003 004C         // Reinitialize Timer1 value
; 0003 004D     TCNT1H=0xF3CA >> 8;
	RCALL SUBOPT_0x0
; 0003 004E     TCNT1L=0xF3CA & 0xff;
; 0003 004F 
; 0003 0050     HandleButtons();
	RCALL _HandleButtons
; 0003 0051 
; 0003 0052     if (timeRemainingTenths > 0)
	RCALL SUBOPT_0x5
	RCALL __CPW02
	BRGE _0x6000F
; 0003 0053     {
; 0003 0054         if ((timeRemainingTenths % 150 == 0) &&
; 0003 0055             (timeRemainingTenths <= 3000))
	RCALL SUBOPT_0x5
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RCALL __MODW21
	SBIW R30,0
	BRNE _0x60011
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	BRLT _0x60012
_0x60011:
	RJMP _0x60010
_0x60012:
; 0003 0056         {
; 0003 0057             PORTB = 0;
	LDI  R30,LOW(0)
	RJMP _0x6001F
; 0003 0058         }
; 0003 0059         else
_0x60010:
; 0003 005A         {
; 0003 005B             PORTB = outputState;
	RCALL SUBOPT_0x4
_0x6001F:
	OUT  0x18,R30
; 0003 005C         }
; 0003 005D         timeRemainingTenths--;
	LDI  R26,LOW(_timeRemainingTenths_G003)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0003 005E     }
; 0003 005F     else
	RJMP _0x60014
_0x6000F:
; 0003 0060     {
; 0003 0061         outputState = 0;
	RCALL SUBOPT_0x3
; 0003 0062         PORTB = 0;
	OUT  0x18,R30
; 0003 0063     }
_0x60014:
; 0003 0064 
; 0003 0065     tenths++;
	LDS  R30,_tenths_G003
	SUBI R30,-LOW(1)
	STS  _tenths_G003,R30
; 0003 0066     if (tenths == 10)
	LDS  R26,_tenths_G003
	CPI  R26,LOW(0xA)
	BRNE _0x60015
; 0003 0067     {
; 0003 0068         tenths = 0;
	LDI  R30,LOW(0)
	STS  _tenths_G003,R30
; 0003 0069         if (outputState == 0)
	RCALL SUBOPT_0x4
	CPI  R30,0
	BRNE _0x60016
; 0003 006A         {
; 0003 006B             SendString("EG0\r");
	__POINTW1FN _0x60000,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SendString
; 0003 006C         }
; 0003 006D         else
	RJMP _0x60017
_0x60016:
; 0003 006E         {
; 0003 006F             SendString("EG1\r");
	__POINTW1FN _0x60000,5
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SendString
; 0003 0070             if (timeRemainingTenths > 0)
	RCALL SUBOPT_0x5
	RCALL __CPW02
	BRGE _0x60018
; 0003 0071             {
; 0003 0072                 STATUS = 1;
	SBI  0x18,7
; 0003 0073             }
; 0003 0074         }
_0x60018:
_0x60017:
; 0003 0075     }
; 0003 0076     else
	RJMP _0x6001B
_0x60015:
; 0003 0077     {
; 0003 0078         STATUS = 0;
	CBI  0x18,7
; 0003 0079     }
_0x6001B:
; 0003 007A }
	RCALL SUBOPT_0x2
	RETI
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2060001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_command:
	.BYTE 0x1
_command_ready:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0x8
_timeRemainingTenths_G003:
	.BYTE 0x2
_outputState_G003:
	.BYTE 0x1
_tenths_G003:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(243)
	OUT  0x2D,R30
	LDI  R30,LOW(202)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _outputState_G003,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDS  R30,_outputState_G003
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDS  R26,_timeRemainingTenths_G003
	LDS  R27,_timeRemainingTenths_G003+1
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
