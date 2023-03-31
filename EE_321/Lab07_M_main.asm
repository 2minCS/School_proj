*-------------------------------------------------------------------------------
* MSP430 Assembler Code Template for use with TI Code Composer Studio
* Lab 07
;
; Utilize ADC
;
; Casey Mauldin
; 04 JUNE 2022
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
SetupWDT    mov.w   #WDT_MDLY_32,&WDTCTL    ; WDT ~45ms interval timer
            bis.b   #WDTIE,&IE1             ; Enable WDT interrupt
SetupADC10  mov.w   #ADC10SHT_2+ADC10ON,&ADC10CTL0 ;
            bis.b   #BIT1,&ADC10AE0          ; P1.0 ADC option select
            bis.w	#INCH_1,&ADC10CTL1
            mov.b   #001h,&ADC10DTC1        ; 1 conversion
SetupP1     bis.b   #BIT6,&P1DIR            ; P1.2 = output
            bis.b   #BIT6,&P1SEL            ; P1.2 = TA1 output
SetupC0     mov.w   #4095,&TACCR0         ; PWM Period
SetupC1     mov.w   #OUTMOD_7,&TACCTL1      ; TACCR1 reset/set
            mov.w   #4095,&TACCR1            ; TACCR1 PWM Duty Cycle
SetupTA     mov.w   #TASSEL_2+MC_1,&TACTL   ; SMCLK, upmode
                                            ;
Mainloop    bis.b   #CPUOFF+GIE,SR          ; LPM0, WDT_ISR will force exit
            mov.w   #TACCR1,&ADC10SA        ; Data transfer location

            bis.w   #ENC+ADC10SC,&ADC10CTL0 ; Start sampling
            jmp     Mainloop                ; Again
                                            ;
;-------------------------------------------------------------------------------
WDT_ISR;    Exit LPM0 mode, reti returns system active
;-------------------------------------------------------------------------------
            bic.w   #CPUOFF,0(SP)           ; Exit LPM0 on reti
            push	R15
            mov.w	&ADC10MEM, R15
            clrc
            rlc		R15
            rla		R15
            mov.w	R15,&TA0CCR1
            pop.w	R15
            reti                            ;
                                            ;
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .sect   ".int10"                ; WDT Vector
            .short  WDT_ISR                 ;
            .end
