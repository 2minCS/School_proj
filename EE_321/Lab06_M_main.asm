*-------------------------------------------------------------------------------
* MSP430 Assembler Code Template for use with TI Code Composer Studio
* Lab 06 - Timers part 2
;
; Blink led's using continuous timer
;
; Casey Mauldin
; 28 MAY 2022
; Norwich University
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
gt_on:	 .equ 13750
gt_off:	 .equ 27500
rt_on:	 .equ 56250
rt_off:	 .equ 12500
S1: 	 .equ BIT3 ; define switch for P1.3
	; input pin
	bic.b	#S1,	&P1DIR	; clear P1.3 to config input for S1
	bis.b	#S1,	&P1REN	; enable P1.3 pull-up/down resistor
	bis.b	#S1,	&P1OUT	; select pull-up for the resistor
			; output pin
	bis.b 	#RED_LED,	&P1DIR 	; set P1.6 as an output (P1.6=LED2)
	bis.b	#GRN_LED,	&P1DIR	; set P1.0 as an output (P1.0=LED1)

	;bis.w	#TASSEL_2|MC_1|ID_3, &TA1CTL
	bis.w	#TASSEL_2|MC_2|ID_3, &TA0CTL
			; setup capture/compare register
	;mov.w	#50000, &TA0CCR0		; 50000 tics @ 1MHz/8 = 0.4 seconds
	bis.w	#CCIE, &TA0CCTL0		; enable interrupt for TA0CCR0
	;mov.w	#37500, &TA0CCR1		; 37500 tics @ 1MHz/8 = 0.3 seconds
	bis.w	#CCIE, &TA0CCTL1		; enable interrupt for TA0CCR1
	;mov.w	#37500, &TA0CCR2		; 37500 tics @ 1MHz/8 = 0.3 seconds
	bis.w	#CCIE, &TA0CCTL2		; enable interrupt for TA0CCR2
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

	reti	; return from interrupt
TA0IV_ISR:
		add.w	&TA0IV,PC 		; Add offset to Jump table
		reti 				; Vector 0: No interrupt
		jmp		ta0ccr1		; Vector 2: TACCR1 CCIFG
		jmp		ta0ccr2		; Vector 4: TACCR2 CCIFG
		reti				; Vector 6: Reserved
		reti				; Vector 8: Reserved
		jmp		ta0ovrf		; Vector A: TAIFG (Overflow)

ta0ccr1:

    		bit.b	#S1,	&P1IN
			jz else1	;If pressed jump to else1
			mov.w	#gt_on, &TA0CCR0
			xor.b  	#GRN_LED, &P1OUT
			mov.w	#rt_on, &TA0CCR1
			xor.b  	#RED_LED, &P1OUT
		jmp ta0end
else1:
			mov.w	#rt_on, &TA0CCR0
			xor.b  	#GRN_LED, &P1OUT
			mov.w	#gt_on, &TA0CCR1
			xor.b  	#RED_LED, &P1OUT
		jmp	ta0end
ta0ccr2:
			bit.b	#S1,	&P1IN
			jz	else3
			mov.w	#rt_off, &TA0CCR1
			mov.w	#gt_off, &TA0CCR0

		jmp	ta0end
else3:		mov.w	#rt_off, &TA0CCR0
			mov.w	#gt_off, &TA0CCR1

		jmp	ta0end
ta0ovrf:	bic.b	#BIT3,&P1OUT		; reset pin P1.3
ta0end:		reti


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
 .sect	".int08"			; TA1CCR0 Vector
 .short	TA0IV_ISR
