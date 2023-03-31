*-------------------------------------------------------------------------------
* MSP430 Assembler Code Template for use with TI Code Composer Studio
* Replace comments with your description, name, and date here
*
*-------------------------------------------------------------------------------
 .cdecls C,LIST,"msp430.h" ; Include device header file

;-------------------------------------------------------------------------------
 .def RESET ; Export program entry-point to
 ; make it known to linker.
;-------------------------------------------------------------------------------
 .text ; Assemble into program memory.
 .retain ; Override ELF conditional linking
 ; and retain current section.
 .retainrefs ; And retain any sections that have
 ; references to current section.
;-------------------------------------------------------------------------------
RESET mov.w #__STACK_END,SP ; Initialize stackpointer
StopWDT mov.w #WDTPW|WDTHOLD,&WDTCTL ; Stop watchdog timer

init: ;Set up the green LED output pin, Timer0_A3, TA0CCR0, and GIE here
GRN_LED: .equ BIT0 ; define grn LED for P1.0
RED_LED: .equ BIT6 ; define red LED for P1.6
S1: 	 .equ BIT3 ; define switch for P1.3
	; input pin
	bic.b	#S1,	&P1DIR	; clear P1.3 to config input for S1
	bis.b	#S1,	&P1REN	; enable P1.3 pull-up/down resistor
	bis.b	#S1,	&P1OUT	; select pull-up for the resistor
	;bis.b   #S1, 	&P1IES
			; output pin
	bis.b 	#RED_LED,	&P1DIR 	; set P1.6 as an output (P1.6=LED2)
	bis.b	#GRN_LED,	&P1DIR	; set P1.0 as an output (P1.0=LED1)

	bis.w	#TASSEL_2|MC_1|ID_3, &TA1CTL
	bis.w	#TASSEL_2|MC_1|ID_3, &TA0CTL
			; setup capture/compare register
	mov.w	#50000, &TA0CCR0		; 50000 tics @ 1MHz/8 = 0.4 seconds
	bis.w	#CCIE, &TA0CCTL0		; enable interrupt for TA0CCR0
	mov.w	#37500, &TA1CCR0		; 37500 tics @ 1MHz/8 = 0.3 seconds
	;bis.w	#CCIE, &TA1CCTL0		; enable interrupt for TA1CCR0
		; enable general interrupts
	bis.w	#GIE, SR			; general interrupt enable
;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main: ;Your main program code (enter LPM0) here
	bis.w	#LPM0, SR		; enter low-power mode 0 (CPUOFF)



;-------------------------------------------------------------------------------
; Interrupt Service Routines
;-------------------------------------------------------------------------------
TA0CCR0_ISR:
	bis.w	#CCIE, &TA0CCTL0
	bic.w	#CCIE, &TA1CCTL0
	bit.b	#S1,	&P1IN	; test bit 3: Z set if pressed (P1IN.3=0)
	jz		TA1CCR0_ISR
	xor.b  	#GRN_LED, &P1OUT	; toggle the LED
	bic.b	#RED_LED, &P1OUT
	reti	; return from interrupt
TA1CCR0_ISR:
	bis.w	#CCIE, &TA1CCTL0
	bic.w	#CCIE, &TA0CCTL0
	bit.b	#S1,	&P1IN	; test bit 3: Z set if pressed (P1IN.3=0)
	jnz		TA0CCR0_ISR
	xor.b  	#RED_LED, &P1OUT
	bic.b  	#GRN_LED, &P1OUT
	reti


;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
 .global __STACK_END
 .sect .stack

;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
 .sect ".reset" ; MSP430 RESET Vector
 .short RESET
 .sect	".int09"			; TA0CCR0 Vector
 .short	TA0CCR0_ISR
 .sect	".int13"			; TA1CCR0 Vector
 .short	TA1CCR0_ISR
