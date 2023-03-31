;-------------------------------------------------------------------------------
; Lab 01 - Blink1
;
; Program to blink an LED on the MSP430 LaunchPad
;
; Casey Mauldin
; 12 MAY 2022
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

init:
			bis.b #40h,&P1DIR ; set P1.6 as an output (P1.6=LED2)

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

main:

			xor.b #40h,&P1OUT ; toggle P1.6 (LED2)
			mov.w #08h, R5 ; put 1 in R5
delay2:
			mov.w #0ffffh, R4 ; put 65535 in R4
delay:
			dec.w R4 ; decrement R4
			jnz delay ; jump to delay loop until R4=0
			dec.w R5 ; decrement R5
			jnz delay2 ; jump to delay2 loop until R5=0
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
            
