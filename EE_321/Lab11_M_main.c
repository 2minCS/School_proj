/*
* EE321 Lab 11 dc Motor State Machine
*
* Casey Mauldin
* Norwich University
* 17JUN22
*/

#include <msp430.h>
// states
#define ON_CW 0x13// identify each state with a number
#define ON_CCW 0x25
#define OFF_CW 0x32
#define OFF_CCW 0x34
#define BRAKE_CW 0x0A
#define BRAKE_CCW 0x0C
// inputs
#define ONOFF BIT0 // define button for P1.0
#define BRAKE BIT2 // define button for P1.2
#define MDIR BIT1 // define button for P1.1
// outputs
#define LED_CCW BIT2 // define blue LED for P2.2
#define LED_BRAKE BIT3 // define red LED for P2.3
#define LED_CW BIT1 // define yellow LED for P2.1
#define LED_ON BIT0  // green LED for 2.0
#define PMW_OUT BIT6
#define MOTORAI1 BIT4
#define MOTORAI2 BIT5
#define BLOCK BIT7
// masks
#define IN_MASK 0x07 // mask for input switches
#define LED_MASK 0x0F // mask for output LEDs
#define H_BRIDGE 0x30
#define OUT_MASK 0x3F //LEDs and H Bridge
// variables
unsigned char curState = 0x13; // initialize current state variable
// main.c
void main(void) {
    WDTCTL = WDTPW + WDTHOLD; // Stop WDT
    // Set clock speed (default = 1 MHz)
    BCSCTL1 = CALBC1_8MHZ; // Basic Clock System CTL (1,8,12 16_MHZ available)
    DCOCTL = CALDCO_8MHZ; // Digitally-Controlled Oscillator CTL

    // Initialize input pin
    P1DIR &= ~IN_MASK; // Configure pin for switch on P2.0
    P1IE |= IN_MASK; // Enable P2.0 interrupt
    P1IES |= IN_MASK; // Enable the interrupt on a high->low transition
    P1IFG &= ~IN_MASK; // reset interrupt flag

    // Set up LED pins
    P2DIR |= LED_MASK; // LED pins set to output
    P2OUT &= ~LED_MASK; // initialize LEDs to be off
    // Initialize P2.6 as the PWM output pin
    P2DIR |= PMW_OUT; // Bit 6 of P2DIR sets P2.6 as output & will be used for PWM
    P2SEL |= PMW_OUT; // P2.6 TA0.1 option select
    P2OUT &= ~BLOCK;

    // Set up Timer for PWM operation in up-mode
    TA0CTL = TASSEL_2 + MC_1 + ID_2; // Set up the clock that drives the timer:
    // TASSEL_2: Timer A clock source select: 2 - SMCLK
    // MC_1: Timer A mode control: 1 - Up to TACCR0 (up-mode)
    // ID_2: Timer A input divider: 0 - /4
    TA0CCTL1 = OUTMOD_7; // PWM output mode: 7 - PWM reset/set
    TA0CCR0 = 1024 - 1; // Clock ticks per cycle; PWM freq = clock freq/TACCR0
    // the value + 1 = number of resolution steps in the duty cycle
    TA0CCR1 = 512; // Initial PWM duty cycle = TACCR1/TACCR0 (initially 100%)
    //Set up ADC
    ADC10CTL1 |= CONSEQ1;
    ADC10CTL0 = ADC10SHT_2 + ADC10ON + ADC10IE;         // sample for 16 clock cycles
    // + turn on the ADC
    // + enable the interrupt
    ADC10CTL1 = INCH_4;  // choose input channel A1
    ADC10SA = 0x0200;
    ADC10AE0 |= BIT4;                         // initialize P1.4 as ADC input pin
    ADC10DTC1 = 0x01;
    P1SEL |= BIT4;
    //__enable_interrupt();
    while(1)
    {
        ADC10CTL0 &= ~ENC;
        ADC10CTL0 |= ENC + ADC10SC;
        __bis_SR_register(CPUOFF + GIE);

        // Set bits in the Status Register

   }
    // LPM0_bits: Low-Power Mode 0 (CPUOFF)
    // GIE: General Interrupt Enable (non-masked interrupts)
}
//*************************************************************************************************
// ADC10 interrupt service routine
#pragma vector=ADC10_VECTOR
__interrupt void ADC10_ISR (void)
{
    TA0CCR1 = ADC10MEM;
    __bic_SR_register_on_exit(CPUOFF);        // Return to active mode }
}
// Port 1 interrupt service routine
#pragma vector=PORT1_VECTOR
__interrupt void P1_ISR(void)
{

    switch(curState)
    {
    case ON_CW:
    {
        switch(P1IFG & IN_MASK)
        {
        case ONOFF:
        {


            P2SEL |= PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_CW;
            curState = OFF_CW; // next state becomes current state
            break;
        }
        case MDIR:
        {
            P2SEL |= PMW_OUT; // Timer PWM
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_ON + LED_CCW + MOTORAI2;

            curState = ON_CCW; // next state becomes current state
            break;
        }
        case BRAKE:
        {
            P2SEL &= ~PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_BRAKE + LED_CW + H_BRIDGE;

            curState = BRAKE_CW; // next state becomes current state
            break;
        }


        default:
            break;
        }

        break;
    }
    case OFF_CW:
    {
        switch(P1IFG & IN_MASK)
        {
        case ONOFF:
        {

            P2SEL |= PMW_OUT; // Timer PWM
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_ON + LED_CW + MOTORAI1;

            curState = ON_CW; // next state becomes current state
            break;
        }
        case MDIR:
        {
            P2SEL |= PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_CCW;
            curState = OFF_CCW; // next state becomes current state
            break;
        }
        case BRAKE:
        {
            P2SEL &= ~PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_BRAKE + LED_CW + H_BRIDGE;

            curState = BRAKE_CW; // next state becomes current state
            break;
        }
        default:
            break;
        }

        break;
    }

    case ON_CCW:
    {
        switch(P1IFG & IN_MASK)
        {
        case ONOFF:
        {
            P2SEL |= PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_CCW;
            curState = OFF_CCW; // next state becomes current state
            break;
        }
        case MDIR:
        {
            P2SEL |= PMW_OUT; // Timer PWM
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_ON + LED_CW + MOTORAI1;

            curState = ON_CW; // next state becomes current state
            break;
        }
        case BRAKE:
        {
            P2SEL &= ~PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_BRAKE + LED_CCW + H_BRIDGE;

            curState = BRAKE_CCW; // next state becomes current state
            break;
        }
        default:
            break;
        }

        break;
    }

    case OFF_CCW:
    {
        switch(P1IFG & IN_MASK)
        {
        case ONOFF:
        {


            P2SEL |= PMW_OUT; // Timer PWM
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_ON + LED_CCW + MOTORAI2;

            curState = ON_CCW; // next state becomes current state
            break;
        }
        case MDIR:
        {
            P2SEL |= PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_CW;
            curState = OFF_CW; // next state becomes current state
            break;
        }
        case BRAKE:
        {
            P2SEL &= ~PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_BRAKE + LED_CCW + H_BRIDGE;

            curState = BRAKE_CCW; // next state becomes current state
            break;
        }

        default:
            break;
        }

        break;
    }
    case BRAKE_CW:
    {
        switch(P1IFG & IN_MASK)
        {
        case ONOFF:
        {
            P2SEL |= PMW_OUT; // Timer PWM
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_ON + LED_CW + MOTORAI1;

            curState = ON_CW; // next state becomes current state
            break;
        }
        case MDIR:
        {
            P2SEL &= ~PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_BRAKE + LED_CCW + H_BRIDGE;

            curState = BRAKE_CCW; // next state becomes current state
            break;
        }
        case BRAKE:
        {
            P2SEL |= PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_CW;
            curState = OFF_CW; // next state becomes current state
            break;
        }
        default:
            break;
        }

        break;
    }
    case BRAKE_CCW:
    {
        switch(P1IFG & IN_MASK)
        {
        case ONOFF:
        {
            P2SEL |= PMW_OUT; // Timer PWM
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_ON + LED_CCW + MOTORAI2;

            curState = ON_CCW; // next state becomes current state
            break;
        }
        case MDIR:
        {
            P2SEL &= ~PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_BRAKE + LED_CW + H_BRIDGE;

            curState = BRAKE_CW; // next state becomes current state
            break;
        }
        case BRAKE:
        {
            P2SEL |= PMW_OUT; // Digital I/O
            P2OUT &= ~OUT_MASK;
            P2OUT |= LED_CCW;
            curState = OFF_CCW; // next state becomes current state
            break;
        }
        default:
            break;
        }

        break;
    }

    default:
        break;
    }


    P1IFG &= ~IN_MASK; // Reset interrupt flags
}
