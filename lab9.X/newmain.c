/*
 * File:   newmain.c
 * Author: user
 *
 * Created on 2018年12月3日, 下午 5:34
 */

#pragma config OSC = INTIO67
#pragma config WDT = OFF
#pragma config PBADEN = OFF
#pragma config LVP =OFF
#include <xc.h>
volatile int init = 75;
void main(void) {
    OSCCONbits.IRCF2 = 0;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF0 = 1;
    
    TRISBbits.RB0 = 1;
    TRISC = 0;
    LATC = 0;
   
    /*
    RCONbits.IPEN= 1;
    INTCONbits.GIE =1;
    PIR1bits.TMR2IF = 0;
    PIE1bits.TMR2IE = 1;
    IPR1bits.TMR2IP = 1;
    */
    
    CCP1CONbits.DC1B = 3;
    CCP1CONbits.CCP1M = 0xc;
    
    CCPR1L  = 18;
    PR2 = 155;
    T2CONbits.T2CKPS = 3;
    T2CONbits.TMR2ON = 1;
    
    
    while(1){
        if(PORTBbits.RB0 == 0){
            --init;
            CCPR1L = init / 4;
            CCP1CONbits.DC1B = init % 4;
        }
            
    }
    return;
}

