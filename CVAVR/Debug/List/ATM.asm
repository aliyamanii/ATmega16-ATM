
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _transaction_count=R5
	.DEF _transaction_index=R4
	.DEF _current_user_index=R6
	.DEF _current_user_index_msb=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0xFF,0xFF

_0x3:
	.DB  0x31,0x34,0x37,0x2A,0x32,0x35,0x38,0x30
	.DB  0x33,0x36,0x39,0x23,0x2A,0x30,0x23,0x44
_0x4:
	.DB  0x31,0x32,0x33,0x34,0x35,0x0,0x36,0x37
	.DB  0x38,0x39,0x30,0x0,0xE8,0x3,0x32,0x33
	.DB  0x34,0x35,0x36,0x0,0x37,0x38,0x39,0x30
	.DB  0x31,0x0,0xDC,0x5,0x33,0x34,0x35,0x36
	.DB  0x37,0x0,0x38,0x39,0x30,0x31,0x32,0x0
	.DB  0xD0,0x7,0x34,0x35,0x36,0x37,0x38,0x0
	.DB  0x39,0x30,0x31,0x32,0x33,0x0,0xB0,0x4
	.DB  0x35,0x36,0x37,0x38,0x39,0x0,0x30,0x31
	.DB  0x32,0x33,0x34,0x0,0x8,0x7,0x36,0x37
	.DB  0x38,0x39,0x30,0x0,0x31,0x32,0x33,0x34
	.DB  0x35,0x0,0x84,0x3,0x37,0x38,0x39,0x30
	.DB  0x31,0x0,0x32,0x33,0x34,0x35,0x36,0x0
	.DB  0x98,0x8,0x38,0x39,0x30,0x31,0x32,0x0
	.DB  0x33,0x34,0x35,0x36,0x37,0x0,0x14,0x5
	.DB  0x39,0x30,0x31,0x32,0x33,0x0,0x34,0x35
	.DB  0x36,0x37,0x38,0x0,0xA4,0x6,0x30,0x31
	.DB  0x32,0x33,0x34,0x0,0x35,0x36,0x37,0x38
	.DB  0x39,0x0,0x4C,0x4
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x55,0x4E
	.DB  0x61,0x6D,0x65,0x3A,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x50,0x61,0x73,0x73,0x3A
	.DB  0x0,0x57,0x72,0x6F,0x6E,0x67,0x20,0x43
	.DB  0x72,0x65,0x64,0x65,0x6E,0x74,0x69,0x61
	.DB  0x6C,0x73,0x0,0x31,0x2E,0x42,0x61,0x6C
	.DB  0x20,0x32,0x2E,0x54,0x72,0x61,0x6E,0x73
	.DB  0x66,0x0,0x33,0x2E,0x54,0x72,0x73,0x63
	.DB  0x20,0x34,0x2E,0x4F,0x74,0x68,0x3F,0x0
	.DB  0x41,0x63,0x63,0x3A,0x25,0x64,0x0,0x42
	.DB  0x61,0x6C,0x3A,0x25,0x64,0x0,0x53,0x65
	.DB  0x6E,0x64,0x20,0x74,0x6F,0x3A,0x0,0x52
	.DB  0x65,0x63,0x69,0x70,0x69,0x65,0x6E,0x74
	.DB  0x20,0x4E,0x6F,0x74,0x0,0x46,0x6F,0x75
	.DB  0x6E,0x64,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x41,0x6D,0x6F,0x75,0x6E,0x74,0x3A
	.DB  0x0,0x54,0x72,0x61,0x6E,0x73,0x66,0x65
	.DB  0x72,0x0,0x43,0x6F,0x6D,0x70,0x6C,0x65
	.DB  0x74,0x65,0x0,0x46,0x61,0x69,0x6C,0x65
	.DB  0x64,0x0,0x4E,0x6F,0x20,0x54,0x72,0x61
	.DB  0x6E,0x73,0x61,0x63,0x74,0x69,0x6F,0x6E
	.DB  0x73,0x0,0x59,0x65,0x74,0x0,0x25,0x64
	.DB  0x2D,0x25,0x73,0x2D,0x25,0x64,0x0,0x4F
	.DB  0x74,0x68,0x65,0x72,0x20,0x4E,0x6F,0x74
	.DB  0x0,0x49,0x6D,0x70,0x6C,0x65,0x6D,0x65
	.DB  0x6E,0x74,0x65,0x64,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _keypad
	.DW  _0x3*2

	.DW  0x8C
	.DW  _users
	.DW  _0x4*2

	.DW  0x0D
	.DW  _0x62
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x62+13
	.DW  _0x0*2+13

	.DW  0x12
	.DW  _0x62+25
	.DW  _0x0*2+25

	.DW  0x0F
	.DW  _0x62+43
	.DW  _0x0*2+43

	.DW  0x0E
	.DW  _0x62+58
	.DW  _0x0*2+58

	.DW  0x09
	.DW  _0x62+72
	.DW  _0x0*2+86

	.DW  0x0E
	.DW  _0x62+81
	.DW  _0x0*2+95

	.DW  0x06
	.DW  _0x62+95
	.DW  _0x0*2+109

	.DW  0x0E
	.DW  _0x62+101
	.DW  _0x0*2+115

	.DW  0x09
	.DW  _0x62+115
	.DW  _0x0*2+129

	.DW  0x09
	.DW  _0x62+124
	.DW  _0x0*2+138

	.DW  0x09
	.DW  _0x62+133
	.DW  _0x0*2+129

	.DW  0x07
	.DW  _0x62+142
	.DW  _0x0*2+147

	.DW  0x10
	.DW  _0x62+149
	.DW  _0x0*2+154

	.DW  0x04
	.DW  _0x62+165
	.DW  _0x0*2+170

	.DW  0x0A
	.DW  _0x62+169
	.DW  _0x0*2+183

	.DW  0x0C
	.DW  _0x62+179
	.DW  _0x0*2+193

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : ATM System
;Version : 1.5
;Date    : 5/24/2025
;Author  : Grok 3
;Company : xAI
;Comments: ATM system with 10 users, transfer, and transaction history
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
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
;#include <delay.h>
;#include <string.h>
;#include <stdio.h>
;
;// LCD definitions
;#define LCD_RS PORTA.0
;#define LCD_RW PORTA.1
;#define LCD_EN PORTA.2
;#define LCD_D7 PORTA.4
;#define LCD_D6 PORTA.5
;#define LCD_D5 PORTA.6
;#define LCD_D4 PORTA.7
;
;// LED definitions
;#define LED_OK PORTC.0
;#define LED_ERROR PORTC.1
;
;// Keypad definitions
;#define ROWS 4
;#define COLS 4
;
;// User structure
;typedef struct {
;    char username[6]; // 5 chars + null terminator
;    char password[6]; // 5 chars + null terminator
;    unsigned int balance;
;} User;
;
;// Transaction structure
;typedef struct {
;    int sender_index;
;    int recipient_index;
;    unsigned int amount;
;} Transaction;
;
;// Global variables
;char keypad[ROWS][COLS] = {
;    {'1', '4', '7', '*'}, // Row 0 (PD0)
;    {'2', '5', '8', '0'}, // Row 1 (PD1)
;    {'3', '6', '9', '#'}, // Row 2 (PD2)
;    {'*', '0', '#', 'D'}  // Row 3 (not used, PD3 not connected)
;};

	.DSEG
;
;// Array of 10 users
;User users[10] = {
;    {"12345", "67890", 1000},
;    {"23456", "78901", 1500},
;    {"34567", "89012", 2000},
;    {"45678", "90123", 1200},
;    {"56789", "01234", 1800},
;    {"67890", "12345", 900},
;    {"78901", "23456", 2200},
;    {"89012", "34567", 1300},
;    {"90123", "45678", 1700},
;    {"01234", "56789", 1100}
;};
;
;// Transaction history (stores last 2 transactions)
;Transaction transactions[2];
;unsigned char transaction_count = 0;
;unsigned char transaction_index = 0;
;
;char input_username[6] = "";
;char input_password[6] = "";
;char recipient_username[6] = "";
;char input_amount[5] = "";
;int current_user_index = -1;
;
;// Function prototypes
;void lcd_init(void);
;void lcd_cmd(unsigned char);
;void lcd_data(unsigned char);
;void lcd_string(char*);
;char keypad_scan(void);
;void clear_input(char*, unsigned char);
;int find_user(char*);
;int find_recipient(char*);
;void wait_for_hash(void);
;void add_transaction(int sender_index, int recipient_index, unsigned int amount);
;
;// LCD initialization
;void lcd_init(void) {
; 0000 0069 void lcd_init(void) {

	.CSEG
_lcd_init:
; .FSTART _lcd_init
; 0000 006A     LCD_RW = 0; // Ensure RW is always low (write mode)
	CBI  0x1B,1
; 0000 006B     lcd_cmd(0x02); // Initialize LCD in 4-bit mode
	LDI  R26,LOW(2)
	RCALL _lcd_cmd
; 0000 006C     lcd_cmd(0x28); // 2 lines, 5x7 matrix
	LDI  R26,LOW(40)
	RCALL _lcd_cmd
; 0000 006D     lcd_cmd(0x0C); // Display on, cursor off
	LDI  R26,LOW(12)
	RCALL _lcd_cmd
; 0000 006E     lcd_cmd(0x06); // Increment cursor
	LDI  R26,LOW(6)
	RCALL _lcd_cmd
; 0000 006F     lcd_cmd(0x01); // Clear display
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 0070     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 0071 }
	RET
; .FEND
;
;// Send command to LCD
;void lcd_cmd(unsigned char cmd) {
; 0000 0074 void lcd_cmd(unsigned char cmd) {
_lcd_cmd:
; .FSTART _lcd_cmd
; 0000 0075     LCD_D4 = (cmd >> 4) & 0x01;
	ST   -Y,R26
;	cmd -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,LOW(0x1)
	BRNE _0x7
	CBI  0x1B,7
	RJMP _0x8
_0x7:
	SBI  0x1B,7
_0x8:
; 0000 0076     LCD_D5 = (cmd >> 5) & 0x01;
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x9
	CBI  0x1B,6
	RJMP _0xA
_0x9:
	SBI  0x1B,6
_0xA:
; 0000 0077     LCD_D6 = (cmd >> 6) & 0x01;
	CALL SUBOPT_0x0
	BRNE _0xB
	CBI  0x1B,5
	RJMP _0xC
_0xB:
	SBI  0x1B,5
_0xC:
; 0000 0078     LCD_D7 = (cmd >> 7) & 0x01;
	LD   R30,Y
	ROL  R30
	LDI  R30,0
	ROL  R30
	ANDI R30,LOW(0x1)
	BRNE _0xD
	CBI  0x1B,4
	RJMP _0xE
_0xD:
	SBI  0x1B,4
_0xE:
; 0000 0079     LCD_RS = 0;
	CBI  0x1B,0
; 0000 007A     LCD_EN = 1;
	CALL SUBOPT_0x1
; 0000 007B     delay_ms(1);
; 0000 007C     LCD_EN = 0;
; 0000 007D 
; 0000 007E     LCD_D4 = cmd & 0x01;
	BRNE _0x15
	CBI  0x1B,7
	RJMP _0x16
_0x15:
	SBI  0x1B,7
_0x16:
; 0000 007F     LCD_D5 = (cmd >> 1) & 0x01;
	LD   R30,Y
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x17
	CBI  0x1B,6
	RJMP _0x18
_0x17:
	SBI  0x1B,6
_0x18:
; 0000 0080     LCD_D6 = (cmd >> 2) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x19
	CBI  0x1B,5
	RJMP _0x1A
_0x19:
	SBI  0x1B,5
_0x1A:
; 0000 0081     LCD_D7 = (cmd >> 3) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x1B
	CBI  0x1B,4
	RJMP _0x1C
_0x1B:
	SBI  0x1B,4
_0x1C:
; 0000 0082     LCD_RS = 0;
	CBI  0x1B,0
; 0000 0083     LCD_EN = 1;
	RJMP _0x2060006
; 0000 0084     delay_ms(1);
; 0000 0085     LCD_EN = 0;
; 0000 0086     delay_ms(2);
; 0000 0087 }
; .FEND
;
;// Send data to LCD
;void lcd_data(unsigned char data) {
; 0000 008A void lcd_data(unsigned char data) {
_lcd_data:
; .FSTART _lcd_data
; 0000 008B     LCD_D4 = (data >> 4) & 0x01;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,LOW(0x1)
	BRNE _0x23
	CBI  0x1B,7
	RJMP _0x24
_0x23:
	SBI  0x1B,7
_0x24:
; 0000 008C     LCD_D5 = (data >> 5) & 0x01;
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x25
	CBI  0x1B,6
	RJMP _0x26
_0x25:
	SBI  0x1B,6
_0x26:
; 0000 008D     LCD_D6 = (data >> 6) & 0x01;
	CALL SUBOPT_0x0
	BRNE _0x27
	CBI  0x1B,5
	RJMP _0x28
_0x27:
	SBI  0x1B,5
_0x28:
; 0000 008E     LCD_D7 = (data >> 7) & 0x01;
	LD   R30,Y
	ROL  R30
	LDI  R30,0
	ROL  R30
	ANDI R30,LOW(0x1)
	BRNE _0x29
	CBI  0x1B,4
	RJMP _0x2A
_0x29:
	SBI  0x1B,4
_0x2A:
; 0000 008F     LCD_RS = 1;
	SBI  0x1B,0
; 0000 0090     LCD_EN = 1;
	CALL SUBOPT_0x1
; 0000 0091     delay_ms(1);
; 0000 0092     LCD_EN = 0;
; 0000 0093 
; 0000 0094     LCD_D4 = data & 0x01;
	BRNE _0x31
	CBI  0x1B,7
	RJMP _0x32
_0x31:
	SBI  0x1B,7
_0x32:
; 0000 0095     LCD_D5 = (data >> 1) & 0x01;
	LD   R30,Y
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x33
	CBI  0x1B,6
	RJMP _0x34
_0x33:
	SBI  0x1B,6
_0x34:
; 0000 0096     LCD_D6 = (data >> 2) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x35
	CBI  0x1B,5
	RJMP _0x36
_0x35:
	SBI  0x1B,5
_0x36:
; 0000 0097     LCD_D7 = (data >> 3) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x37
	CBI  0x1B,4
	RJMP _0x38
_0x37:
	SBI  0x1B,4
_0x38:
; 0000 0098     LCD_RS = 1;
	SBI  0x1B,0
; 0000 0099     LCD_EN = 1;
_0x2060006:
	SBI  0x1B,2
; 0000 009A     delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 009B     LCD_EN = 0;
	CBI  0x1B,2
; 0000 009C     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 009D }
	ADIW R28,1
	RET
; .FEND
;
;// Display string on LCD
;void lcd_string(char *str) {
; 0000 00A0 void lcd_string(char *str) {
_lcd_string:
; .FSTART _lcd_string
; 0000 00A1     char *ptr = str;
; 0000 00A2     while (*ptr) {
	CALL SUBOPT_0x2
;	*str -> Y+2
;	*ptr -> R16,R17
	__GETWRS 16,17,2
_0x3F:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x41
; 0000 00A3         lcd_data(*ptr++);
	__ADDWRN 16,17,1
	LD   R26,X
	RCALL _lcd_data
; 0000 00A4     }
	RJMP _0x3F
_0x41:
; 0000 00A5 }
	RJMP _0x2060002
; .FEND
;
;// Scan keypad for key press
;char keypad_scan(void) {
; 0000 00A8 char keypad_scan(void) {
_keypad_scan:
; .FSTART _keypad_scan
; 0000 00A9     unsigned char row;
; 0000 00AA     unsigned char col;
; 0000 00AB     PORTD = 0xF0; // Set rows high, columns as inputs with pull-ups
	ST   -Y,R17
	ST   -Y,R16
;	row -> R17
;	col -> R16
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 00AC 
; 0000 00AD     for (row = 0; row < ROWS; row++) {
	LDI  R17,LOW(0)
_0x43:
	CPI  R17,4
	BRSH _0x44
; 0000 00AE         if (row == 3) continue; // Skip unused row (PD3 not connected)
	CPI  R17,3
	BREQ _0x42
; 0000 00AF         PORTD = ~(1 << row); // Set one row low at a time (PD0-PD2)
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	OUT  0x12,R30
; 0000 00B0         delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 00B1         for (col = 0; col < COLS; col++) {
	LDI  R16,LOW(0)
_0x47:
	CPI  R16,4
	BRSH _0x48
; 0000 00B2             if (!(PIND & (1 << (col + 4)))) { // Check columns PD4-PD7
	CALL SUBOPT_0x3
	BRNE _0x49
; 0000 00B3                 while (!(PIND & (1 << (col + 4)))); // Wait for key release
_0x4A:
	CALL SUBOPT_0x3
	BREQ _0x4A
; 0000 00B4                 return keypad[row][col];
	MOV  R30,R17
	LDI  R26,LOW(_keypad)
	LDI  R27,HIGH(_keypad)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	RJMP _0x2060005
; 0000 00B5             }
; 0000 00B6         }
_0x49:
	SUBI R16,-1
	RJMP _0x47
_0x48:
; 0000 00B7     }
_0x42:
	SUBI R17,-1
	RJMP _0x43
_0x44:
; 0000 00B8     return 0; // No key pressed
	LDI  R30,LOW(0)
_0x2060005:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00B9 }
; .FEND
;
;// Clear input buffer
;void clear_input(char *buffer, unsigned char size) {
; 0000 00BC void clear_input(char *buffer, unsigned char size) {
_clear_input:
; .FSTART _clear_input
; 0000 00BD     unsigned char i = 0;
; 0000 00BE     for (; i < size; i++) {
	ST   -Y,R26
	ST   -Y,R17
;	*buffer -> Y+2
;	size -> Y+1
;	i -> R17
	LDI  R17,0
_0x4E:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x4F
; 0000 00BF         buffer[i] = '\0';
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	ST   X,R30
; 0000 00C0     }
	SUBI R17,-1
	RJMP _0x4E
_0x4F:
; 0000 00C1 }
	LDD  R17,Y+0
	RJMP _0x2060004
; .FEND
;
;// Find user by username
;int find_user(char *username) {
; 0000 00C4 int find_user(char *username) {
_find_user:
; .FSTART _find_user
; 0000 00C5     int i = 0;
; 0000 00C6     for (; i < 10; i++) {
	CALL SUBOPT_0x2
;	*username -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x51:
	__CPWRN 16,17,10
	BRGE _0x52
; 0000 00C7         if (strcmp(users[i].username, username) == 0) {
	CALL SUBOPT_0x4
	BRNE _0x53
; 0000 00C8             return i;
	MOVW R30,R16
	RJMP _0x2060002
; 0000 00C9         }
; 0000 00CA     }
_0x53:
	__ADDWRN 16,17,1
	RJMP _0x51
_0x52:
; 0000 00CB     return -1; // User not found
	RJMP _0x2060003
; 0000 00CC }
; .FEND
;
;// Find recipient by username
;int find_recipient(char *username) {
; 0000 00CF int find_recipient(char *username) {
_find_recipient:
; .FSTART _find_recipient
; 0000 00D0     int i = 0;
; 0000 00D1     for (; i < 10; i++) {
	CALL SUBOPT_0x2
;	*username -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x55:
	__CPWRN 16,17,10
	BRGE _0x56
; 0000 00D2         if (strcmp(users[i].username, username) == 0 && i != current_user_index) {
	CALL SUBOPT_0x4
	BRNE _0x58
	__CPWRR 6,7,16,17
	BRNE _0x59
_0x58:
	RJMP _0x57
_0x59:
; 0000 00D3             return i;
	MOVW R30,R16
	RJMP _0x2060002
; 0000 00D4         }
; 0000 00D5     }
_0x57:
	__ADDWRN 16,17,1
	RJMP _0x55
_0x56:
; 0000 00D6     return -1; // Recipient not found or same as current user
_0x2060003:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x2060002:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2060004:
	ADIW R28,4
	RET
; 0000 00D7 }
; .FEND
;
;// Wait for '#' key to return to menu
;void wait_for_hash(void) {
; 0000 00DA void wait_for_hash(void) {
_wait_for_hash:
; .FSTART _wait_for_hash
; 0000 00DB     char key;
; 0000 00DC     while (1) {
	ST   -Y,R17
;	key -> R17
_0x5A:
; 0000 00DD         key = keypad_scan();
	RCALL _keypad_scan
	MOV  R17,R30
; 0000 00DE         if (key == '#') break;
	CPI  R17,35
	BRNE _0x5A
; 0000 00DF     }
; 0000 00E0 }
	LD   R17,Y+
	RET
; .FEND
;
;// Add a transaction to the history
;void add_transaction(int sender_index, int recipient_index, unsigned int amount) {
; 0000 00E3 void add_transaction(int sender_index, int recipient_index, unsigned int amount) {
_add_transaction:
; .FSTART _add_transaction
; 0000 00E4     transactions[transaction_index].sender_index = sender_index;
	ST   -Y,R27
	ST   -Y,R26
;	sender_index -> Y+4
;	recipient_index -> Y+2
;	amount -> Y+0
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_transactions)
	SBCI R31,HIGH(-_transactions)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00E5     transactions[transaction_index].recipient_index = recipient_index;
	CALL SUBOPT_0x5
	__ADDW1MN _transactions,2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00E6     transactions[transaction_index].amount = amount;
	CALL SUBOPT_0x5
	__ADDW1MN _transactions,4
	LD   R26,Y
	LDD  R27,Y+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00E7     transaction_index = (transaction_index + 1) % 2; // Circular buffer for 2 transactions
	MOV  R30,R4
	LDI  R31,0
	ADIW R30,1
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	MOV  R4,R30
; 0000 00E8     if (transaction_count < 2) transaction_count++;
	LDI  R30,LOW(2)
	CP   R5,R30
	BRSH _0x5E
	INC  R5
; 0000 00E9 }
_0x5E:
	ADIW R28,6
	RET
; .FEND
;
;void main(void) {
; 0000 00EB void main(void) {
_main:
; .FSTART _main
; 0000 00EC     unsigned char i;
; 0000 00ED     char key;
; 0000 00EE     char buffer[16];
; 0000 00EF     unsigned char authenticated = 0;
; 0000 00F0     int recipient_index;
; 0000 00F1     unsigned int amount;
; 0000 00F2     int j;
; 0000 00F3 
; 0000 00F4     // Port A initialization (LCD)
; 0000 00F5     DDRA = (1<<DDA0) | (1<<DDA1) | (1<<DDA2) | (1<<DDA4) | (1<<DDA5) | (1<<DDA6) | (1<<DDA7); // PA0, PA1, PA2, PA4-PA7  ...
	SBIW R28,20
;	i -> R17
;	key -> R16
;	buffer -> Y+4
;	authenticated -> R19
;	recipient_index -> R20,R21
;	amount -> Y+2
;	j -> Y+0
	LDI  R19,0
	LDI  R30,LOW(247)
	OUT  0x1A,R30
; 0000 00F6     PORTA = 0x00; // Initial state
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00F7 
; 0000 00F8     // Port C initialization (LEDs)
; 0000 00F9     DDRC = (1<<DDC0) | (1<<DDC1); // PC0, PC1 as outputs for LEDs
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 00FA     PORTC = 0x00; // LEDs off initially
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00FB 
; 0000 00FC     // Port D initialization (Keypad)
; 0000 00FD     DDRD = 0x0F;  // Rows (PD0-PD3) as outputs, Columns (PD4-PD7) as inputs
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 00FE     PORTD = 0xF0; // Enable pull-ups on columns
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 00FF 
; 0000 0100     // Timer/Counter 0 initialization
; 0000 0101     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0102     TCNT0=0x00;
	OUT  0x32,R30
; 0000 0103     OCR0=0x00;
	OUT  0x3C,R30
; 0000 0104 
; 0000 0105     // Timer/Counter 1 initialization
; 0000 0106     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0107     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0108     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0109     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 010A     ICR1H=0x00;
	OUT  0x27,R30
; 0000 010B     ICR1L=0x00;
	OUT  0x26,R30
; 0000 010C     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 010D     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 010E     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 010F     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0110 
; 0000 0111     // Timer/Counter 2 initialization
; 0000 0112     ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0113     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0114     TCNT2=0x00;
	OUT  0x24,R30
; 0000 0115     OCR2=0x00;
	OUT  0x23,R30
; 0000 0116 
; 0000 0117     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0118     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0119 
; 0000 011A     // External Interrupt(s) initialization
; 0000 011B     MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 011C     MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 011D 
; 0000 011E     // USART initialization
; 0000 011F     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0120 
; 0000 0121     // Analog Comparator initialization
; 0000 0122     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0123     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0124 
; 0000 0125     // ADC initialization
; 0000 0126     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0127 
; 0000 0128     // SPI initialization
; 0000 0129     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 012A 
; 0000 012B     // TWI initialization
; 0000 012C     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 012D 
; 0000 012E     // Initialize LCD
; 0000 012F     lcd_init();
	RCALL _lcd_init
; 0000 0130 
; 0000 0131     while (1) {
_0x5F:
; 0000 0132         // Prompt for username
; 0000 0133         lcd_cmd(0x01); // Clear display
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 0134         lcd_string("Enter UName:");
	__POINTW2MN _0x62,0
	CALL SUBOPT_0x6
; 0000 0135         lcd_cmd(0xC0); // Move to second line
; 0000 0136         i = 0;
; 0000 0137         clear_input(input_username, 6);
	LDI  R30,LOW(_input_username)
	LDI  R31,HIGH(_input_username)
	CALL SUBOPT_0x7
; 0000 0138         while (i < 5) {
_0x63:
	CPI  R17,5
	BRSH _0x65
; 0000 0139             key = keypad_scan();
	CALL SUBOPT_0x8
; 0000 013A             if (key && key != '#' && key != '*') {
	BREQ _0x67
	CPI  R16,35
	BREQ _0x67
	CPI  R16,42
	BRNE _0x68
_0x67:
	RJMP _0x66
_0x68:
; 0000 013B                 input_username[i] = key;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_input_username)
	SBCI R31,HIGH(-_input_username)
	CALL SUBOPT_0x9
; 0000 013C                 lcd_data(key);
; 0000 013D                 i++;
; 0000 013E             }
; 0000 013F             if (key == '#') break; // Enter key
_0x66:
	CPI  R16,35
	BRNE _0x63
; 0000 0140         }
_0x65:
; 0000 0141         input_username[i] = '\0';
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_input_username)
	SBCI R31,HIGH(-_input_username)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0142 
; 0000 0143         // Prompt for password
; 0000 0144         lcd_cmd(0x01); // Clear display
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 0145         lcd_string("Enter Pass:");
	__POINTW2MN _0x62,13
	CALL SUBOPT_0x6
; 0000 0146         lcd_cmd(0xC0); // Move to second line
; 0000 0147         i = 0;
; 0000 0148         clear_input(input_password, 6);
	LDI  R30,LOW(_input_password)
	LDI  R31,HIGH(_input_password)
	CALL SUBOPT_0x7
; 0000 0149         while (i < 5) {
_0x6A:
	CPI  R17,5
	BRSH _0x6C
; 0000 014A             key = keypad_scan();
	CALL SUBOPT_0x8
; 0000 014B             if (key && key != '#' && key != '*') {
	BREQ _0x6E
	CPI  R16,35
	BREQ _0x6E
	CPI  R16,42
	BRNE _0x6F
_0x6E:
	RJMP _0x6D
_0x6F:
; 0000 014C                 input_password[i] = key;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_input_password)
	SBCI R31,HIGH(-_input_password)
	ST   Z,R16
; 0000 014D                 lcd_data('*'); // Mask password
	LDI  R26,LOW(42)
	RCALL _lcd_data
; 0000 014E                 i++;
	SUBI R17,-1
; 0000 014F             }
; 0000 0150             if (key == '#') break; // Enter key
_0x6D:
	CPI  R16,35
	BRNE _0x6A
; 0000 0151         }
_0x6C:
; 0000 0152         input_password[i] = '\0';
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_input_password)
	SBCI R31,HIGH(-_input_password)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0153 
; 0000 0154         // Validate credentials
; 0000 0155         current_user_index = find_user(input_username);
	LDI  R26,LOW(_input_username)
	LDI  R27,HIGH(_input_username)
	RCALL _find_user
	MOVW R6,R30
; 0000 0156         if (current_user_index != -1 && strcmp(users[current_user_index].password, input_password) == 0) {
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x72
	CALL SUBOPT_0xA
	__ADDW1MN _users,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_input_password)
	LDI  R27,HIGH(_input_password)
	CALL _strcmp
	CPI  R30,0
	BREQ _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 0157             LED_OK = 1;
	SBI  0x15,0
; 0000 0158             LED_ERROR = 0;
	CBI  0x15,1
; 0000 0159             authenticated = 1;
	LDI  R19,LOW(1)
; 0000 015A         } else {
	RJMP _0x78
_0x71:
; 0000 015B             LED_OK = 0;
	CBI  0x15,0
; 0000 015C             LED_ERROR = 1;
	SBI  0x15,1
; 0000 015D             lcd_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 015E             lcd_string("Wrong Credentials");
	__POINTW2MN _0x62,25
	RCALL _lcd_string
; 0000 015F             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0160             continue;
	RJMP _0x5F
; 0000 0161         }
_0x78:
; 0000 0162 
; 0000 0163         // Show menu if authenticated
; 0000 0164         while (authenticated) {
_0x7D:
	CPI  R19,0
	BRNE PC+2
	RJMP _0x7F
; 0000 0165             lcd_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 0166             lcd_string("1.Bal 2.Transf");
	__POINTW2MN _0x62,43
	CALL SUBOPT_0xB
; 0000 0167             lcd_cmd(0xC0);
; 0000 0168             lcd_string("3.Trsc 4.Oth?");
	__POINTW2MN _0x62,58
	RCALL _lcd_string
; 0000 0169 
; 0000 016A             key = keypad_scan();
	CALL SUBOPT_0x8
; 0000 016B             if (key) {
	BRNE PC+2
	RJMP _0x80
; 0000 016C                 lcd_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 016D                 switch (key) {
	MOV  R30,R16
	LDI  R31,0
; 0000 016E                     case '1': // Balance
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x84
; 0000 016F                         sprintf(buffer, "Acc:%d", current_user_index + 1); // Simplified account number
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,72
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	ADIW R30,1
	CALL __CWD1
	CALL SUBOPT_0xC
; 0000 0170                         lcd_string(buffer);
	CALL SUBOPT_0xB
; 0000 0171                         lcd_cmd(0xC0);
; 0000 0172                         sprintf(buffer, "Bal:%d", users[current_user_index].balance);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,79
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
	__ADDW1MN _users,12
	MOVW R26,R30
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL SUBOPT_0xC
; 0000 0173                         lcd_string(buffer);
	CALL SUBOPT_0xD
; 0000 0174                         wait_for_hash(); // Wait for '#' to return to menu
; 0000 0175                         break;
	RJMP _0x83
; 0000 0176                     case '2': // Transfer
_0x84:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x85
; 0000 0177                         // Prompt for recipient username
; 0000 0178                         lcd_string("Send to:");
	__POINTW2MN _0x62,72
	CALL SUBOPT_0x6
; 0000 0179                         lcd_cmd(0xC0);
; 0000 017A                         i = 0;
; 0000 017B                         clear_input(recipient_username, 6);
	LDI  R30,LOW(_recipient_username)
	LDI  R31,HIGH(_recipient_username)
	CALL SUBOPT_0x7
; 0000 017C                         while (i < 5) {
_0x86:
	CPI  R17,5
	BRSH _0x88
; 0000 017D                             key = keypad_scan();
	CALL SUBOPT_0x8
; 0000 017E                             if (key && key != '#' && key != '*') {
	BREQ _0x8A
	CPI  R16,35
	BREQ _0x8A
	CPI  R16,42
	BRNE _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
; 0000 017F                                 recipient_username[i] = key;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_recipient_username)
	SBCI R31,HIGH(-_recipient_username)
	CALL SUBOPT_0x9
; 0000 0180                                 lcd_data(key);
; 0000 0181                                 i++;
; 0000 0182                             }
; 0000 0183                             if (key == '#') break;
_0x89:
	CPI  R16,35
	BRNE _0x86
; 0000 0184                         }
_0x88:
; 0000 0185                         recipient_username[i] = '\0';
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_recipient_username)
	SBCI R31,HIGH(-_recipient_username)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0186 
; 0000 0187                         // Find recipient
; 0000 0188                         recipient_index = find_recipient(recipient_username);
	LDI  R26,LOW(_recipient_username)
	LDI  R27,HIGH(_recipient_username)
	RCALL _find_recipient
	MOVW R20,R30
; 0000 0189                         if (recipient_index == -1) {
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x8D
; 0000 018A                             lcd_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 018B                             lcd_string("Recipient Not");
	__POINTW2MN _0x62,81
	CALL SUBOPT_0xB
; 0000 018C                             lcd_cmd(0xC0);
; 0000 018D                             lcd_string("Found");
	__POINTW2MN _0x62,95
	CALL SUBOPT_0xD
; 0000 018E                             wait_for_hash();
; 0000 018F                             break;
	RJMP _0x83
; 0000 0190                         }
; 0000 0191 
; 0000 0192                         // Prompt for amount
; 0000 0193                         lcd_cmd(0x01);
_0x8D:
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 0194                         lcd_string("Enter Amount:");
	__POINTW2MN _0x62,101
	CALL SUBOPT_0x6
; 0000 0195                         lcd_cmd(0xC0);
; 0000 0196                         i = 0;
; 0000 0197                         clear_input(input_amount, 5);
	LDI  R30,LOW(_input_amount)
	LDI  R31,HIGH(_input_amount)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _clear_input
; 0000 0198                         while (i < 4) {
_0x8E:
	CPI  R17,4
	BRSH _0x90
; 0000 0199                             key = keypad_scan();
	CALL SUBOPT_0x8
; 0000 019A                             if (key && key != '#' && key != '*' && (key >= '0' && key <= '9')) {
	BREQ _0x92
	CPI  R16,35
	BREQ _0x92
	CPI  R16,42
	BREQ _0x92
	CPI  R16,48
	BRLO _0x93
	CPI  R16,58
	BRLO _0x94
_0x93:
	RJMP _0x92
_0x94:
	RJMP _0x95
_0x92:
	RJMP _0x91
_0x95:
; 0000 019B                                 input_amount[i] = key;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x9
; 0000 019C                                 lcd_data(key);
; 0000 019D                                 i++;
; 0000 019E                             }
; 0000 019F                             if (key == '#') break;
_0x91:
	CPI  R16,35
	BRNE _0x8E
; 0000 01A0                         }
_0x90:
; 0000 01A1                         input_amount[i] = '\0';
	CALL SUBOPT_0xE
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01A2 
; 0000 01A3                         // Convert amount to integer
; 0000 01A4                         amount = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 01A5                         for (i = 0; i < strlen(input_amount); i++) {
	LDI  R17,LOW(0)
_0x98:
	LDI  R26,LOW(_input_amount)
	LDI  R27,HIGH(_input_amount)
	CALL _strlen
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x99
; 0000 01A6                             amount = amount * 10 + (input_amount[i] - '0');
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	MOVW R26,R30
	CALL SUBOPT_0xE
	LD   R30,Z
	LDI  R31,0
	SBIW R30,48
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 01A7                         }
	SUBI R17,-1
	RJMP _0x98
_0x99:
; 0000 01A8 
; 0000 01A9                         // Perform transfer
; 0000 01AA                         if (users[current_user_index].balance >= amount) {
	CALL SUBOPT_0xA
	__ADDW1MN _users,12
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x9A
; 0000 01AB                             users[current_user_index].balance -= amount;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xF
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 01AC                             users[recipient_index].balance += amount;
	__MULBNWRU 20,21,14
	CALL SUBOPT_0xF
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 01AD                             add_transaction(current_user_index, recipient_index, amount);
	ST   -Y,R7
	ST   -Y,R6
	ST   -Y,R21
	ST   -Y,R20
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _add_transaction
; 0000 01AE                             lcd_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 01AF                             lcd_string("Transfer");
	__POINTW2MN _0x62,115
	CALL SUBOPT_0xB
; 0000 01B0                             lcd_cmd(0xC0);
; 0000 01B1                             lcd_string("Complete");
	__POINTW2MN _0x62,124
	RJMP _0xAB
; 0000 01B2                         } else {
_0x9A:
; 0000 01B3                             lcd_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 01B4                             lcd_string("Transfer");
	__POINTW2MN _0x62,133
	CALL SUBOPT_0xB
; 0000 01B5                             lcd_cmd(0xC0);
; 0000 01B6                             lcd_string("Failed");
	__POINTW2MN _0x62,142
_0xAB:
	RCALL _lcd_string
; 0000 01B7                         }
; 0000 01B8                         wait_for_hash();
	RCALL _wait_for_hash
; 0000 01B9                         break;
	RJMP _0x83
; 0000 01BA                     case '3': // Transaction
_0x85:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x9C
; 0000 01BB                         if (transaction_count == 0) {
	TST  R5
	BRNE _0x9D
; 0000 01BC                             lcd_string("No Transactions");
	__POINTW2MN _0x62,149
	CALL SUBOPT_0xB
; 0000 01BD                             lcd_cmd(0xC0);
; 0000 01BE                             lcd_string("Yet");
	__POINTW2MN _0x62,165
	RCALL _lcd_string
; 0000 01BF                         } else {
	RJMP _0x9E
_0x9D:
; 0000 01C0                             for (j = 0; j < transaction_count; j++) {
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0xA0:
	MOV  R30,R5
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLT PC+2
	RJMP _0xA1
; 0000 01C1                                 int idx = (transaction_index - 1 - j + 2) % 2; // Most recent first
; 0000 01C2                                 sprintf(buffer, "%d-%s-%d", j + 1, users[transactions[idx].recipient_index].username, tr ...
	SBIW R28,2
;	buffer -> Y+6
;	amount -> Y+4
;	j -> Y+2
;	idx -> Y+0
	MOV  R30,R4
	LDI  R31,0
	SBIW R30,1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	ST   Y,R30
	STD  Y+1,R31
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,174
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _transactions,2
	MOVW R26,R30
	CALL __GETW1P
	LDI  R26,LOW(14)
	LDI  R27,HIGH(14)
	CALL __MULW12U
	SUBI R30,LOW(-_users)
	SBCI R31,HIGH(-_users)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(6)
	CALL __MULB1W2U
	__ADDW1MN _transactions,4
	MOVW R26,R30
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01C3                                 if (j == 0) {
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BRNE _0xA2
; 0000 01C4                                     lcd_string(buffer);
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0xB
; 0000 01C5                                     lcd_cmd(0xC0);
; 0000 01C6                                 } else {
	RJMP _0xA3
_0xA2:
; 0000 01C7                                     lcd_string(buffer);
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_string
; 0000 01C8                                 }
_0xA3:
; 0000 01C9                             }
	ADIW R28,2
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0xA0
_0xA1:
; 0000 01CA                         }
_0x9E:
; 0000 01CB                         wait_for_hash();
	RCALL _wait_for_hash
; 0000 01CC                         break;
	RJMP _0x83
; 0000 01CD                     case '4': // Other
_0x9C:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xA4
; 0000 01CE                         lcd_string("Other Not");
	__POINTW2MN _0x62,169
	CALL SUBOPT_0xB
; 0000 01CF                         lcd_cmd(0xC0);
; 0000 01D0                         lcd_string("Implemented");
	__POINTW2MN _0x62,179
	CALL SUBOPT_0xD
; 0000 01D1                         wait_for_hash();
; 0000 01D2                         break;
	RJMP _0x83
; 0000 01D3                     case '*': // Exit
_0xA4:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0x83
; 0000 01D4                         authenticated = 0;
	LDI  R19,LOW(0)
; 0000 01D5                         LED_OK = 0;
	CBI  0x15,0
; 0000 01D6                         LED_ERROR = 0;
	CBI  0x15,1
; 0000 01D7                         current_user_index = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R6,R30
; 0000 01D8                         break;
; 0000 01D9                 }
_0x83:
; 0000 01DA             }
; 0000 01DB         }
_0x80:
	RJMP _0x7D
_0x7F:
; 0000 01DC     }
	RJMP _0x5F
; 0000 01DD }
_0xAA:
	RJMP _0xAA
; .FEND

	.DSEG
_0x62:
	.BYTE 0xBF

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
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
_put_buff_G101:
; .FSTART _put_buff_G101
	CALL SUBOPT_0x2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x10
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x10
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x11
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x12
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x10
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x12
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x15
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG
_keypad:
	.BYTE 0x10
_users:
	.BYTE 0x8C
_transactions:
	.BYTE 0xC
_input_username:
	.BYTE 0x6
_input_password:
	.BYTE 0x6
_recipient_username:
	.BYTE 0x6
_input_amount:
	.BYTE 0x5

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	SBI  0x1B,2
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x1B,2
	LD   R30,Y
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3:
	IN   R1,16
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,4
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	__MULBNWRU 16,17,14
	SUBI R30,LOW(-_users)
	SBCI R31,HIGH(-_users)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOV  R30,R4
	LDI  R26,LOW(6)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	CALL _lcd_string
	LDI  R26,LOW(192)
	CALL _lcd_cmd
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	JMP  _clear_input

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	CALL _keypad_scan
	MOV  R16,R30
	CPI  R16,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	ST   Z,R16
	MOV  R26,R16
	CALL _lcd_data
	SUBI R17,-1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	MOVW R30,R6
	LDI  R26,LOW(14)
	LDI  R27,HIGH(14)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	CALL _lcd_string
	LDI  R26,LOW(192)
	JMP  _lcd_cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	MOVW R26,R28
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL _lcd_string
	JMP  _wait_for_hash

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_input_amount)
	SBCI R31,HIGH(-_input_amount)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	__ADDW1MN _users,12
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETW1P
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

;END OF CODE MARKER
__END_OF_CODE:
