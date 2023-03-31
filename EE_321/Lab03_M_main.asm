;-------------------------------------------------------------------------------
; Lab 03 - Blink Delay Subroutine
;
; Button Pressed: green LED flashes on for 0.6 seconds & off for 0.6 seconds, red LED off
; Button Not Pressed: red LED flashes on for 0.3 seconds & off for 0.3 seconds, green LED off
;
; Casey Mauldin
; 21 MAY 2022
; Norwich University
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

DELAYLOOPS	.equ		27000
LED1		.equ		BIT0 					; Rename
LED2		.equ		BIT6
;-------------------------------------------------------------------------------
; Initialize pins here
;-------------------------------------------------------------------------------

init:
			; input pin
			bic.b	#BIT3,	&P1DIR	; clear P1.3 to config input for S1
			bis.b	#BIT3,	&P1REN	; enable P1.3 pull-up/down resistor
			bis.b	#BIT3,	&P1OUT	; select pull-up for the resistor

			; output pin
			bis.b 	#LED2,	&P1DIR 	; set P1.6 as an output (P1.6=LED2)
			bis.b	#LED1,	&P1DIR	; set P1.0 as an output (P1.0=LED1)

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

main:
if:
			bit.b	#BIT3,	&P1IN	; test bit 3: Z set if pressed (P1IN.3=0)
			jnz		else			; jump to endif not pressed

			mov.w	#6,	R12
			call	#DelayTenths
			xor.b 	#LED1,	&P1OUT 	; toggle P1.0 (LED1)
			bic.b	#LED2,	&P1OUT	; clear P1.6 if button not pressed

			jmp		if				; jump to if, restart loop
else:
			mov.w	#3,	R12
			call	#DelayTenths
			xor.b 	#LED2,	&P1OUT 	; toggle P1.6 (LED2) on
			bic.b	#LED1,	&P1OUT	; toggle P1.0 (LED1) off
			jmp		if
endif:

delay:
			dec.w R4 ; decrement R4
			jnz delay ; jump to delay loop until R4=0
			jmp main ; repeat main loop forever

;-------------------------------------------------------------------------------
; Subroutine Delay
;-------------------------------------------------------------------------------

DelayTenths:
		push.w	R4
		jmp		LoopTest
OuterLoop:
		mov.w	#DELAYLOOPS,	R4
DelayLoop:
		dec.w	R4
		jnz		DelayLoop
		dec.w	R12
LoopTest:
		cmp.w	#0,		R12
		jnz		OuterLoop
		pop.w		R4
		ret
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
