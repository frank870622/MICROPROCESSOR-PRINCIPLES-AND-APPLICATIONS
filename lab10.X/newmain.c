#include <xc.h>
#pragma config OSC  = INTIO67,WDT=OFF,LVP=OFF
#pragma PBADEN = 1 //set AN0~AN12 as analog input

void adc_init(void);
void ccp2_init(void);
void tmr_init(void);
volatile int result[8] = {0};
volatile int count = 0;
void __interrupt(high_priority) Hi_ISR(void)
{
    //deal ccp2 interrupt and adc interrupt
    if(PIR1bits.ADIF){//AD conversion finish
        result[count] = ADRES;
        
        PIR1bits.ADIF = 0;
    }
    else if(PIR2bits.CCP2IF){ //special event triger
        TMR3 = 0;
        if(count == 7){
            count = 0;  
            NOP();
        }
        else
            ++count;
        PIR2bits.CCP2IF = 0;
    }
    return ;
}

void main(void) {
    //change OSC if you want
    OSCCONbits.IRCF = 4;
    //    OSCCONbits.IRCF = ??;
    adc_init();
    ccp2_init();
    tmr_init();
    while(1);
    return;
}

void adc_init(void){
    //datasheet p232 TABLE 19-2
    //Configure the A/D module
    //ADCON0
    ADCON0bits.CHS = 7;
    //select analog channel
    //set TRIS
    TRISEbits.RE2 =  1;
    //Turn on A/D module
    ADCON0bits.GODONE = 1;
    ADCON0bits.ADON = 1;
    //ADCON1 //set refer voltage
    ADCON1bits.VCFG = 0;
    ADCON1bits.PCFG = 0;
    //ADCON2
    //A/D Conversion Clock
    ADCON2bits.ADCS = 3;
    //Acquisition Time
    ADCON2bits.ACQT = 1;
    //left or right justified
    ADCON2bits.ADFM = 1;  
    //Configure A/D interrupt(optional)
    PIR1bits.ADIF = 0;
    PIE1bits.ADIE = 1;
    IPR1bits.ADIP = 1;
    
    //enable Interrupt Priority mode
    RCONbits.IPEN = 1;
    INTCONbits.GIE = 1;
}

void ccp2_init(void){
    //Configure CCP2 mode,ref datasheet p139
    CCP2CONbits.CCP2M = 11;

    //configure CCP2 interrupt
    PIR2bits.CCP2IF = 0;
    PIE2bits.CCP2IE = 1;
    IPR2bits.CCP2IP = 1;
    //configure CCP2 comparator value
    CCPR2 = 31250;
}

void tmr_init(void){
    //set up timer3, ref datasheet p135
    T3CONbits.T3CCP2 = 1;
    T3CONbits.RD16 = 1;
    T3CONbits.T3CKPS = 0;
    T3CONbits.TMR3ON = 1;
    //no need to turn up timer3 interrupt
}