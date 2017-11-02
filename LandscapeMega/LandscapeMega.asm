
;CodeVisionAVR C Compiler V2.04.5b Standard
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	.EQU MCUCR=0x35
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _command=R6
	.DEF _command_ready=R9
	.DEF _state=R8

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x5C:
	.DB  0x0,0x0
_0x0:
	.DB  0x2B,0x2B,0x2B,0x0,0x41,0x54,0x43,0x4E
	.DB  0xD,0x0,0x45,0x47,0x48,0x6F,0x6D,0x65
	.DB  0xD,0x0,0x52,0x65,0x61,0x64,0x79,0x0
	.DB  0x31,0x0,0x30,0x0,0x41,0x54,0x43,0x4E
	.DB  0x0,0x48,0x65,0x6C,0x6C,0x6F,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x08
	.DW  _0x5C*2

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
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
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

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
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
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
;
;#define COMMAND_OK 1
;#define COMMAND_18 2
;#define COMMAND_ON 3
;#define COMMAND_OFF 4
;
;char command;
;char command_ready = 0;
;
;
;char state = 0;
;
;void HandleChar(char c)
; 0000 002B {

	.CSEG
_HandleChar:
; 0000 002C     switch (state)
;	c -> Y+0
	MOV  R30,R8
; 0000 002D     {
; 0000 002E         case 0: // ready;
	CPI  R30,0
	BRNE _0x6
; 0000 002F             if (c == 'O') state = 1;
	LD   R26,Y
	CPI  R26,LOW(0x4F)
	BRNE _0x7
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0030             if (c == '1') state = 3;
_0x7:
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x8
	LDI  R30,LOW(3)
	MOV  R8,R30
; 0000 0031             if (c == 'S') state = 5;
_0x8:
	LD   R26,Y
	CPI  R26,LOW(0x53)
	BRNE _0x9
	LDI  R30,LOW(5)
	MOV  R8,R30
; 0000 0032             break;
_0x9:
	RJMP _0x5
; 0000 0033 
; 0000 0034         case 1: // "O"
_0x6:
	CPI  R30,LOW(0x1)
	BRNE _0xA
; 0000 0035             if (c == 'K') state = 2;
	LD   R26,Y
	CPI  R26,LOW(0x4B)
	BRNE _0xB
	LDI  R30,LOW(2)
	MOV  R8,R30
; 0000 0036             else state = 0;
	RJMP _0xC
_0xB:
	CLR  R8
; 0000 0037             break;
_0xC:
	RJMP _0x5
; 0000 0038 
; 0000 0039         case 2: // "OK"
_0xA:
	CPI  R30,LOW(0x2)
	BRNE _0xD
; 0000 003A             if (c == '\r')
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0xE
; 0000 003B             {
; 0000 003C                 command = COMMAND_OK;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 003D                 command_ready = 1;
	MOV  R9,R30
; 0000 003E                 state = 0;
; 0000 003F             }
; 0000 0040             else state = 0;
_0xE:
_0x57:
	CLR  R8
; 0000 0041             break;
	RJMP _0x5
; 0000 0042 
; 0000 0043         case 3: // "1"
_0xD:
	CPI  R30,LOW(0x3)
	BRNE _0x10
; 0000 0044             if (c == '8') state = 4;
	LD   R26,Y
	CPI  R26,LOW(0x38)
	BRNE _0x11
	LDI  R30,LOW(4)
	MOV  R8,R30
; 0000 0045             else state = 0;
	RJMP _0x12
_0x11:
	CLR  R8
; 0000 0046             break;
_0x12:
	RJMP _0x5
; 0000 0047 
; 0000 0048         case 4: // "18"
_0x10:
	CPI  R30,LOW(0x4)
	BRNE _0x13
; 0000 0049             if (c == '\r')
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x14
; 0000 004A             {
; 0000 004B                 command = COMMAND_18;
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 004C                 command_ready = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 004D                 state = 0;
; 0000 004E             }
; 0000 004F             else state = 0;
_0x14:
_0x58:
	CLR  R8
; 0000 0050             break;
	RJMP _0x5
; 0000 0051 
; 0000 0052         case 5: // 'S'
_0x13:
	CPI  R30,LOW(0x5)
	BRNE _0x16
; 0000 0053             if (c == '1')
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x17
; 0000 0054             {
; 0000 0055                 state = 6;
	LDI  R30,LOW(6)
	MOV  R8,R30
; 0000 0056             }
; 0000 0057             else if (c == '0')
	RJMP _0x18
_0x17:
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRNE _0x19
; 0000 0058             {
; 0000 0059                 state = 7;
	LDI  R30,LOW(7)
	MOV  R8,R30
; 0000 005A                 return;
	JMP  _0x2060001
; 0000 005B             }
; 0000 005C             else state = 0;
_0x19:
	CLR  R8
; 0000 005D             break;
_0x18:
	RJMP _0x5
; 0000 005E 
; 0000 005F         case 6: // "S1"
_0x16:
	CPI  R30,LOW(0x6)
	BRNE _0x1B
; 0000 0060             if (c == '\r')
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x1C
; 0000 0061             {
; 0000 0062                 command = COMMAND_ON;
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 0063                 command_ready = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0064                 state = 0;
; 0000 0065             }
; 0000 0066             else state = 0;
_0x1C:
_0x59:
	CLR  R8
; 0000 0067             break;
	RJMP _0x5
; 0000 0068 
; 0000 0069         case 7: // "S0"
_0x1B:
	CPI  R30,LOW(0x7)
	BRNE _0x5
; 0000 006A             if (c == '\r')
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x1F
; 0000 006B             {
; 0000 006C                 command = COMMAND_OFF;
	LDI  R30,LOW(4)
	MOV  R6,R30
; 0000 006D                 command_ready = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 006E                 state = 0;
; 0000 006F             }
; 0000 0070             else state = 0;
_0x1F:
_0x5A:
	CLR  R8
; 0000 0071             break;
; 0000 0072     }
_0x5:
; 0000 0073 }
	JMP  _0x2060001
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 007A {
_usart_rx_isr:
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
; 0000 007B char status,data;
; 0000 007C status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 007D data=UDR;
	IN   R16,12
; 0000 007E    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x21
; 0000 007F    {
; 0000 0080    rx_buffer[rx_wr_index]=data;
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0081    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x22
	CLR  R5
; 0000 0082    if (++rx_counter == RX_BUFFER_SIZE)
_0x22:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x23
; 0000 0083       {
; 0000 0084       rx_counter=0;
	CLR  R7
; 0000 0085       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0086       };
_0x23:
; 0000 0087 
; 0000 0088       HandleChar(data);
	ST   -Y,R16
	RCALL _HandleChar
; 0000 0089 
; 0000 008A    };
_0x21:
; 0000 008B }
	LD   R16,Y+
	LD   R17,Y+
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
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0092 {
_getchar:
; 0000 0093 char data;
; 0000 0094 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x24:
	TST  R7
	BREQ _0x24
; 0000 0095 data=rx_buffer[rx_rd_index];
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0096 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x27
	CLR  R4
; 0000 0097 #asm("cli")
_0x27:
	cli
; 0000 0098 --rx_counter;
	DEC  R7
; 0000 0099 #asm("sei")
	sei
; 0000 009A return data;
	MOV  R30,R17
	RJMP _0x2060002
; 0000 009B }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;void init(void)
; 0000 00A5 {
_init:
; 0000 00A6 // Crystal Oscillator division factor: 1
; 0000 00A7 #pragma optsize-
; 0000 00A8 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00A9 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00AA #ifdef _OPTIMIZE_SIZE_
; 0000 00AB #pragma optsize+
; 0000 00AC #endif
; 0000 00AD 
; 0000 00AE // Input/Output Ports initialization
; 0000 00AF // Port A initialization
; 0000 00B0 // Func2=In Func1=In Func0=In
; 0000 00B1 // State2=T State1=T State0=T
; 0000 00B2 PORTA=0x00;
	OUT  0x1B,R30
; 0000 00B3 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00B4 
; 0000 00B5 // Port B initialization
; 0000 00B6 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00B7 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00B8 PORTB=0x00;
	OUT  0x18,R30
; 0000 00B9 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00BA 
; 0000 00BB // Port D initialization
; 0000 00BC // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00BD // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00BE PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00BF DDRD=0x00;
	OUT  0x11,R30
; 0000 00C0 
; 0000 00C1 // Timer/Counter 0 initialization
; 0000 00C2 // Clock source: System Clock
; 0000 00C3 // Clock value: Timer 0 Stopped
; 0000 00C4 // Mode: Normal top=FFh
; 0000 00C5 // OC0A output: Disconnected
; 0000 00C6 // OC0B output: Disconnected
; 0000 00C7 TCCR0A=0x00;
	OUT  0x30,R30
; 0000 00C8 TCCR0B=0x00;
	OUT  0x33,R30
; 0000 00C9 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00CA OCR0A=0x00;
	OUT  0x36,R30
; 0000 00CB OCR0B=0x00;
	OUT  0x3C,R30
; 0000 00CC 
; 0000 00CD // Timer/Counter 1 initialization
; 0000 00CE // Clock source: System Clock
; 0000 00CF // Clock value: Timer1 Stopped
; 0000 00D0 // Mode: Normal top=FFFFh
; 0000 00D1 // OC1A output: Discon.
; 0000 00D2 // OC1B output: Discon.
; 0000 00D3 // Noise Canceler: Off
; 0000 00D4 // Input Capture on Falling Edge
; 0000 00D5 // Timer1 Overflow Interrupt: Off
; 0000 00D6 // Input Capture Interrupt: Off
; 0000 00D7 // Compare A Match Interrupt: Off
; 0000 00D8 // Compare B Match Interrupt: Off
; 0000 00D9 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00DA TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00DB TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00DC TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00DD ICR1H=0x00;
	OUT  0x25,R30
; 0000 00DE ICR1L=0x00;
	OUT  0x24,R30
; 0000 00DF OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00E0 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00E1 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00E2 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00E3 
; 0000 00E4 // External Interrupt(s) initialization
; 0000 00E5 // INT0: Off
; 0000 00E6 // INT1: Off
; 0000 00E7 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00E8 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 00E9 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00EA 
; 0000 00EB // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00EC TIMSK=0x00;
	OUT  0x39,R30
; 0000 00ED 
; 0000 00EE // Universal Serial Interface initialization
; 0000 00EF // Mode: Disabled
; 0000 00F0 // Clock source: Register & Counter=no clk.
; 0000 00F1 // USI Counter Overflow Interrupt: Off
; 0000 00F2 USICR=0x00;
	OUT  0xD,R30
; 0000 00F3 
; 0000 00F4 // USART initialization
; 0000 00F5 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00F6 // USART Receiver: On
; 0000 00F7 // USART Transmitter: On
; 0000 00F8 // USART Mode: Asynchronous
; 0000 00F9 // USART Baud Rate: 9600
; 0000 00FA UCSRA=0x00;
	OUT  0xB,R30
; 0000 00FB UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00FC UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 00FD UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 00FE UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00FF 
; 0000 0100 // Analog Comparator initialization
; 0000 0101 // Analog Comparator: Off
; 0000 0102 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0103 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0104 
; 0000 0105 // Global enable interrupts
; 0000 0106 #asm("sei")
	sei
; 0000 0107 }
	RET
;
;void D(char v)
; 0000 010A {
_D:
; 0000 010B     PORTA = 255 - v;
;	v -> Y+0
	LD   R26,Y
	LDI  R30,LOW(255)
	SUB  R30,R26
	OUT  0x1B,R30
; 0000 010C }
	RJMP _0x2060001
;
;
;void SendString(char flash *string)
; 0000 0110 {
_SendString:
; 0000 0111     while (*string != 0)
;	*string -> Y+0
_0x28:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x2A
; 0000 0112     {
; 0000 0113         putchar(*string);
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 0114         string++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0115     }
	RJMP _0x28
_0x2A:
; 0000 0116 }
	ADIW R28,2
	RET
;
;char ValidateResponse(char flash *template)
; 0000 0119 {
; 0000 011A     char i = 0;
; 0000 011B     while (*template != 0)
;	*template -> Y+1
;	i -> R17
; 0000 011C     {
; 0000 011D         if (*template != getchar())
; 0000 011E         {
; 0000 011F             return 0;
; 0000 0120         }
; 0000 0121         template++;
; 0000 0122         i++;
; 0000 0123     }
; 0000 0124     return 1;
; 0000 0125 }
;
;void WaitCommand()
; 0000 0128 {
_WaitCommand:
; 0000 0129     while (command_ready == 0);
_0x2F:
	TST  R9
	BREQ _0x2F
; 0000 012A     command_ready = 0;
	CLR  R9
; 0000 012B }
	RET
;
;
;void FindPartner()
; 0000 012F {
_FindPartner:
; 0000 0130 char x;
; 0000 0131 
; 0000 0132     D(0);
	ST   -Y,R17
;	x -> R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _D
; 0000 0133     delay_ms(1000);
	CALL SUBOPT_0x0
; 0000 0134 
; 0000 0135     SendString("+++");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1
; 0000 0136     WaitCommand();
; 0000 0137     if (command == COMMAND_OK)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x32
; 0000 0138     {
; 0000 0139         D(31);
	LDI  R30,LOW(31)
	ST   -Y,R30
	RCALL _D
; 0000 013A     }
; 0000 013B 
; 0000 013C 
; 0000 013D 
; 0000 013E //    x = ValidateResponse("OK\r");
; 0000 013F 
; 0000 0140 
; 0000 0141         // ask for the association mode
; 0000 0142     while (0)
_0x32:
; 0000 0143     {
; 0000 0144     PORTA = 1;
; 0000 0145 
; 0000 0146 
; 0000 0147 
; 0000 0148 
; 0000 0149     }
; 0000 014A 
; 0000 014B     SendString("ATCN\r");
	__POINTW1FN _0x0,4
	CALL SUBOPT_0x1
; 0000 014C     WaitCommand();
; 0000 014D     //x = ValidateResponse("OK\r");
; 0000 014E }
_0x2060002:
	LD   R17,Y+
	RET
;
;
;
;
;void Handshake()
; 0000 0154 {
_Handshake:
; 0000 0155         PORTA = 255;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0156         putsf("EGHome\r");
	__POINTW1FN _0x0,10
	CALL SUBOPT_0x2
; 0000 0157 
; 0000 0158         PORTA = 254;
	LDI  R30,LOW(254)
	OUT  0x1B,R30
; 0000 0159 
; 0000 015A         while (rx_counter == 0)
_0x36:
	TST  R7
	BREQ _0x36
; 0000 015B         {
; 0000 015C 
; 0000 015D         }
; 0000 015E         PORTA = 253;
	LDI  R30,LOW(253)
	OUT  0x1B,R30
; 0000 015F         WaitCommand();
	RCALL _WaitCommand
; 0000 0160         if (command == COMMAND_18)
; 0000 0161         {
; 0000 0162         }
; 0000 0163 
; 0000 0164         delay_ms(50);
	CALL SUBOPT_0x3
; 0000 0165 
; 0000 0166         //return ValidateResponse("1804\r");
; 0000 0167 }
	RET
;
;
;
;void main(void)
; 0000 016C {
_main:
; 0000 016D     char value = 0;
; 0000 016E 
; 0000 016F     init();
;	value -> R17
	LDI  R17,0
	RCALL _init
; 0000 0170 
; 0000 0171     while (1)
_0x3A:
; 0000 0172     {
; 0000 0173         value++;
	SUBI R17,-1
; 0000 0174         PORTB = value;
	OUT  0x18,R17
; 0000 0175         delay_ms(50);
	CALL SUBOPT_0x3
; 0000 0176 
; 0000 0177 
; 0000 0178     }
	RJMP _0x3A
; 0000 0179 
; 0000 017A     FindPartner();
; 0000 017B     while (1)
; 0000 017C     {
; 0000 017D         Handshake();
; 0000 017E         putsf("Ready");
; 0000 017F 
; 0000 0180         while (1)
_0x40:
; 0000 0181         {
; 0000 0182             WaitCommand();
	RCALL _WaitCommand
; 0000 0183             if (command == COMMAND_ON)
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x43
; 0000 0184             {
; 0000 0185                 putsf("1");
	__POINTW1FN _0x0,24
	CALL SUBOPT_0x2
; 0000 0186                 D(255);
	LDI  R30,LOW(255)
	RJMP _0x5B
; 0000 0187             }
; 0000 0188             else if (command == COMMAND_OFF)
_0x43:
	LDI  R30,LOW(4)
	CP   R30,R6
	BRNE _0x45
; 0000 0189             {
; 0000 018A                 putsf("0");
	__POINTW1FN _0x0,26
	CALL SUBOPT_0x2
; 0000 018B                 D(0);
	LDI  R30,LOW(0)
_0x5B:
	ST   -Y,R30
	RCALL _D
; 0000 018C             }
; 0000 018D 
; 0000 018E 
; 0000 018F         }
_0x45:
	RJMP _0x40
; 0000 0190 
; 0000 0191 
; 0000 0192     }
; 0000 0193 
; 0000 0194 
; 0000 0195 
; 0000 0196 while (0)
; 0000 0197       {
; 0000 0198 
; 0000 0199       while (0)
; 0000 019A       {
; 0000 019B         delay_ms(50);
; 0000 019C         value++;
; 0000 019D         PORTA = value;
; 0000 019E 
; 0000 019F       }
; 0000 01A0 
; 0000 01A1       while (0)
; 0000 01A2       {
; 0000 01A3         putchar(value);
; 0000 01A4         value++;
; 0000 01A5       }
; 0000 01A6 
; 0000 01A7       // Place your code here
; 0000 01A8       delay_ms(1500);
; 0000 01A9       putchar('+');
; 0000 01AA       putchar('+');
; 0000 01AB       putchar('+');
; 0000 01AC       delay_ms(1000);
; 0000 01AD       value = getchar();
; 0000 01AE 
; 0000 01AF       if (value == 'O')
; 0000 01B0       {
; 0000 01B1            value = getchar();
; 0000 01B2 
; 0000 01B3            putsf("ATCN");
; 0000 01B4            getchar();
; 0000 01B5            getchar();
; 0000 01B6 
; 0000 01B7            putsf("Hello");
; 0000 01B8       while (1)
_0x50:
; 0000 01B9       {
; 0000 01BA 
; 0000 01BB            value = getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 01BC            PORTA = value;
	OUT  0x1B,R17
; 0000 01BD            putchar(value);
	ST   -Y,R17
	RCALL _putchar
; 0000 01BE 
; 0000 01BF       }
	RJMP _0x50
; 0000 01C0 
; 0000 01C1       while (0)
; 0000 01C2       {
; 0000 01C3         delay_ms(50);
; 0000 01C4         value++;
; 0000 01C5         PORTA = value;
; 0000 01C6         putchar(value);
; 0000 01C7 
; 0000 01C8       }
; 0000 01C9 
; 0000 01CA       }
; 0000 01CB 
; 0000 01CC       PORTA=value;
; 0000 01CD 
; 0000 01CE     delay_ms(1000000000);
; 0000 01CF 
; 0000 01D0 
; 0000 01D1 
; 0000 01D2       };
_0x48:
; 0000 01D3 }
_0x56:
	RJMP _0x56
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
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
_putsf:
	ST   -Y,R17
_0x2000006:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000008
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2000006
_0x2000008:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	CALL _SendString
	JMP  _WaitCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(43)
	ST   -Y,R30
	JMP  _putchar


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

;END OF CODE MARKER
__END_OF_CODE:
