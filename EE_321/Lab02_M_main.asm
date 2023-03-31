;-------------------------------------------------------------------------------
; Lab 02 - Blink with Switch
;
; Program to blink the red LED on the MSP430 LaunchPad while button S1 is
; pressed, and stop blinking when the switch is released
;
; Casey Mauldin
; 13 MAY 2022
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

;-------------------------------------------------------------------------------
; Initialize pins here
;-------------------------------------------------------------------------------

init:
			; input pin
			bic.b	#BIT3,	&P1DIR	; clear P1.3 to config input for S1
			bis.b	#BIT3,	&P1REN	; enable P1.3 pull-up/down resistor
			bis.b	#BIT3,	&P1OUT	; select pull-up for the resistor

			; output pin
			bis.b 	#BIT6,	&P1DIR 	; set P1.6 as an output (P1.6=LED2)
			bis.b	#BIT0,	&P1DIR	; set P1.0 as an output (P1.0=LED1)

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

main:
if:
			bit.b	#BIT3,	&P1IN	; test bit 3: Z set if pressed (P1IN.3=0)
			jnz		else			; jump to endif not pressed

			mov.w 	#0ffffh, R4 ; put 65535 in R4

			xor.b 	#BIT0,	&P1OUT 	; toggle P1.0 (LED1)
			bic.b	#BIT6,	&P1OUT	; clear P1.6 if button not pressed

			jmp		endif				; jump to if, restart loop
else:
			xor.b 	#BIT6,	&P1OUT 	; toggle P1.6 (LED2) on
			bic.b	#BIT0,	&P1OUT	; toggle P1.0 (LED1) off
endif:

delay:
			dec.w R4 ; decrement R4
			jnz delay ; jump to delay loop until R4=0
			jmp main ; repeat main loop forever

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
            
