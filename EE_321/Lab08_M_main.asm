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
RESET       mov.w   #0280h,SP               ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupADC10  mov.w   #INCH_3+CONSEQ_1,&ADC10CTL1 ; A3/A2/A1, single sequence
            mov.w   #ADC10SHT_2+MSC+ADC10ON+ADC10IE,&ADC10CTL0 ;
            bis.b   #0Eh,&ADC10AE0          ; P1.1,2,3 ADC10 option selects
            mov.b   #03h,&ADC10DTC1         ; 3 conversions

SetupP1     bis.b   #BIT6,&P1DIR            ; P1.6 = output
            bis.b   #BIT6,&P1SEL            ; P1.6 = TA0 output

SetupP2		bis.b	#BIT1+BIT5,&P2DIR
			bis.b	#BIT1,&P2SEL
			bis.b	#BIT5,&P2SEL

SetupC0     mov.w   #1023,&TACCR0         ; PWM Period
SetupC1     mov.w   #OUTMOD_7,&TACCTL1      ; TA0CCR1 reset/set
            mov.w   #1023,&TACCR1            ; TA0CCR1 PWM Duty Cycle
SetupTA     mov.w   #TASSEL_2+MC_1,&TACTL   ; SMCLK, upmode

SetupT1C0   mov.w   #1023,&TA1CCR0         ; PWM Period
SetupT1C1   mov.w   #OUTMOD_7,&TA1CCTL1      ; TA1CCR1 reset/set
            mov.w   #1023,&TA1CCR1            ; TA1CCR1 PWM Duty Cycle
SetupT2C2   mov.w   #OUTMOD_7,&TA1CCTL2      ; TA1CCR2 reset/set
            mov.w   #1023,&TA1CCR2            ; TA1CCR2 PWM Duty Cycle
SetupTA1    mov.w   #TASSEL_2+MC_1,&TA1CTL   ; SMCLK, upmode

Mainloop    bic.w   #ENC,&ADC10CTL0         ;
busy_test   bit     #BUSY,&ADC10CTL1        ; ADC10 core inactive?
            jnz     busy_test               ;
            mov.w	#adcResult,&ADC10SA
            bis.w   #ENC+ADC10SC,&ADC10CTL0 ; Start sampling

            bis.w   #CPUOFF+GIE,SR          ; LPM0, ADC10_ISR will force exit

grnPWM:		mov.w   &adcResult+4,R15			; conversion result--> R15
			clrc    				; C=0 in SR
			rrc     R15				; shift right, C=0 to msbit
			rra     R15				; shift right, msbit=0 to msbit
			mov.w   R15,&TA0CCR1		; copy shifted result to CCR1

redPWM:		mov.w   &adcResult+2,R14			; conversion result--> R14
			clrc    				; C=0 in SR
			rrc     R14
			rra		R14		; shift right, C=0 to msbit
			mov.w   R14,&TA1CCR1		; copy shifted result to CCR1


bluPWM:		mov.w   &adcResult+0,R13			; conversion result--> R13
			clrc    				; C=0 in SR
			rrc     R13
			rra		R13		; shift right, C=0 to msbit
			mov.w   R13,&TA1CCR2		; copy shifted result to CCR2

            jmp     Mainloop                ; Again
;-------------------------------------------------------------------------------
; Memory Allocation
;-------------------------------------------------------------------------------
		.data			; allocate variables in data memory
		.retain			; keep, even if they are not used

adcResult:	.space	6		; allocate 3*2 bytes

;-------------------------------------------------------------------------------
ADC10_ISR:  ;Exit LPM0 on reti
;-------------------------------------------------------------------------------
            bic.w   #CPUOFF,0(SP)           ; Exit LPM0 on reti

            reti
                                   ;

;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .sect   ".int05"                ; ADC10 Vector
            .short  ADC10_ISR               ;
            .end


