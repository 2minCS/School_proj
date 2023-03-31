*-------------------------------------------------------------------------------
* MSP430 Assembler Code Template for use with TI Code Composer Studio
* Lab 09 - LED State Machine
;
; Blink led's using continuous timer
;
; Casey Mauldin
; 11 JUNE 2022
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
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
BLU_LED: .equ BIT3 ; define blue LED for P1.3
RED_LED: .equ BIT1 ; define red LED for P1.1
YEL_LED: .equ BIT2 ; define yellow LED for P1.2
B1: 	 .equ BIT4 ; define button for P2.4
B2: 	 .equ BIT5 ; define button for P2.5




SetupP2		bic.b	#B1|B2, &P2DIR		; clear P2.4/2.5 to make it an input
			bis.b	#B1|B2, &P2REN		; enable pull-up/down resistor
			bis.b	#B1|B2, &P2OUT		; select pull-up for the resistor
			bis.b	#B1|B2, &P2IES		; interrupt on falling edge (push)
			;mov.b	#B1|B2, &P2IFG		; clear the interrupt flag
			bis.b	#B1|B2, &P2IE		; enable PORT2.4/2.5 interrupt
			bis.w	#GIE, SR		; general interrupt enable

SetupP1     mov.b	#0,&P1OUT
			bis.b   #BLU_LED|RED_LED|YEL_LED,&P1DIR            ; P1.1/1.2/1.3 = output
			xor.b	#RED_LED,&P1OUT

Mainloop             ;




            jmp     Mainloop                ; Again

;-------------------------------------------------------------------------------
P2_ISR:  ;
;-------------------------------------------------------------------------------
switch:
        		bit.b	#B1, P2IFG
        		jnz		Button1
        		bit.b	#B2, P2IFG
        		jnz		Button2
        		jmp		default
Button1:

				bit.b	#RED_LED, P1OUT
        		jnz		case1
        		bit.b	#YEL_LED, P1OUT
        		jnz		case2
        		bit.b	#BLU_LED, P1OUT
        		jnz		case3
        		jmp		default
case1:
					bic.b	#RED_LED, &P1OUT
					xor.b	#YEL_LED, &P1OUT
					bic.b	#B1, P2IFG
					jmp		end_switch
case2:
					bic.b	#YEL_LED, &P1OUT
					xor.b	#RED_LED, &P1OUT
					bic.b	#B1, P2IFG
					jmp		end_switch
case3:
					bic.b	#BLU_LED, &P1OUT
					xor.b	#RED_LED, &P1OUT
					bic.b	#B1, P2IFG
					jmp		end_switch

Button2:

				bit.b	#RED_LED, P1OUT
        		jnz		case4
        		bit.b	#YEL_LED, P1OUT
        		jnz		case5
        		bit.b	#BLU_LED, P1OUT
        		jnz		case6
        		jmp		default
case4:
					bic.b	#RED_LED, &P1OUT
					xor.b	#BLU_LED, &P1OUT
					bic.b	#B2, P2IFG
					jmp		end_switch
case5:
					bic.b	#YEL_LED, &P1OUT
					xor.b	#BLU_LED, &P1OUT
					bic.b	#B2, P2IFG
					jmp		end_switch
case6:
					bic.b	#BLU_LED, &P1OUT
					xor.b	#BLU_LED, &P1OUT
					bic.b	#B2, P2IFG
					jmp		end_switch
default:
				mov.b	#0, P2IFG
end_switch:
            	reti
                                   ;
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .sect   ".int03"                ; Port2 Vector
            .short  P2_ISR               ;
            .end


