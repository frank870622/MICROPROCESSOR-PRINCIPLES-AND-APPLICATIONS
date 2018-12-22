#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
//using namespace std;
#define C5 523
#define D5 587
#define E5 659
#define F5 698
#define G5 784

#define C4 262
#define D4 294
#define E4 329
#define F4 349
#define G4 392
#define A4 440
#define B4 494
int per_arrp1[30] = { G5, E5, E5, 0, F5, D5, D5, 0, C5, D5, E5, F5, G5, G5, G5, 0, 
 G5, E5, E5, 0, F5, D5, D5, 0, C5, E5, G5, G5, E5, 0 
} ;
int per_arrp2[19] = { E4, G4, A4, A4, 0, A4, B4, C5, C5, 0, C5, D5, B4, B4, 0, A4, G4, A4, 0 };
int wait1[30] = {1, 1, 1, 1, 1,
                 1, 1, 1, 1, 1, 
                 1, 1, 1, 1, 1, 
                 1, 1, 1, 1, 1, 
                 1, 1, 1, 1, 1, 
                 1, 1, 1, 1, 1 
};
int wait2[19] = {1,1,2,1,1,1,1,2,1,1,1,1,2,1,1,1,1,3,1} ;

char str[10];
int usemode = 0;
int lednumber = 0;
int unit = 0;
int musicnumber = 0;
int musiccount = 0;
int musicstep = 0;
int modenumber = 0;
int unit_count = 0;
void Mode1() // print "Hello world"
{
    modenumber = 1;
    ClearBuffer();
    // TODO 
    
    while(GetlenStr() != 2);
    lednumber = atoi(GetString());
    ClearBuffer();
    while(GetlenStr() != 2);
    unit = atoi(GetString());
    
    //unit = 3;
    //lednumber = 3;
    //7812
    if(lednumber == 1){
        TRISDbits.RD0 = 0;
        TRISDbits.RD1 = 1;
        TRISDbits.RD2 = 1;
        TRISDbits.RD3 = 1;
    }
    else if(lednumber == 2){
        TRISDbits.RD0 = 0;
        TRISDbits.RD1 = 0;
        TRISDbits.RD2 = 1;
        TRISDbits.RD3 = 1;
    }
    else if(lednumber == 3){
        TRISDbits.RD0 = 0;
        TRISDbits.RD1 = 0;
        TRISDbits.RD2 = 0;
        TRISDbits.RD3 = 1;
    }
    else if(lednumber == 4){
        TRISDbits.RD0 = 0;
        TRISDbits.RD1 = 0;
        TRISDbits.RD2 = 0;
        TRISDbits.RD3 = 0;
    }
    /*
        RCONbits.IPEN= 1;
        PIE1bits.TMR1IE =1;
        PIR1bits.TMR1IF =0;
        IPR1bits.TMR1IP =1;
        INTCONbits.GIE =1;
        
        T1CONbits.RD16 = 1;
        T1CONbits.T1CKPS = 3;
        T1CONbits.TMR1CS = 0;
        T1CONbits.TMR1ON = 1;
    
        TMR1 = 65535 - 7218*unit; 
     * */
    RCONbits.IPEN= 1;
    PIE1bits.TMR2IE =1;
    PIR1bits.TMR2IF =0;
    IPR1bits.TMR2IP =1;
    INTCONbits.GIE =1;
    
    T2CONbits.T2OUTPS = 15;
    T2CONbits.T2CKPS = 3;
    T2CONbits.TMR2ON = 1;
    TMR2 = 255 - 244;
    // Output the result on Command-line Interface.
    while(1){
        if(strstr(GetString(), "q") != NULL)
            break;
    }
    T2CONbits.TMR2ON = 0;
    TRISDbits.RD0 = 0;
    TRISDbits.RD1 = 0;
    TRISDbits.RD2 = 0;
    TRISDbits.RD3 = 0;
    ClearBuffer();
    modenumber = 0;
}

void Mode2() { // Output Voltage 
    modenumber = 2;
    ClearBuffer();
    
    int digital = 0;
    float voltage = 0.0;
    for(int i = 0; i < 10; ++i) // TODO design a condition. Return to main function when the while loop is over.
    {
        digital=ADC_Read(0);
        voltage = digital* ((float)5/1023); // 5v / 2^10-1  (10bits)
        // TODO
        // Output the voltage on CLI.
        memset(str, 0, 10);
        sprintf(str, "%lf", voltage);
        UART_Write_Text(str);
        UART_Write_Text("V");
        // The voltage must have the second digit after the decimal point.
        for(int i = 0 ; i < 10000 ; i++) ; // a delay time
    }
    

    int stepmove = -1;
    stepmove = (int)voltage;
    if(stepmove <= 1) stepmove = -1;
    if(stepmove >=4 ) stepmove = -4;
    
    T2CON = 0x00;
    PIE1bits.TMR2IE =0;
    
    TRISCbits.RC2 = 0;
    T2CONbits.TMR2ON = 1;
    T2CONbits.T2CKPS = 3;
    CCP1CONbits.CCP1M = 12;
    PR2 = 155;
    CCP1CONbits.DC1B = 3;
    CCPR1L = 18;
    int init = 75;
    
    while(1){
       init += stepmove;
       CCPR1L = init / 4;
       CCP1CONbits.DC1B = init % 4;
       if(init <= 0 || init >= 75)
           stepmove *= -1;
       if(strstr(GetString(), "q") != NULL)
            break;
    }
    T2CONbits.TMR2ON = 0;
    TRISCbits.RC2 = 1;
    ClearBuffer();
    modenumber = 0;
}
void Mode3(){
    modenumber = 3;
    ClearBuffer();
    while(GetlenStr() != 2);
    musicnumber = atoi(GetString());
    /*
    CCP1CON = 10;
    T3CON = 0x81;
    T1CON = 0x81;
    T3CONbits.T3CCP1 = 0;
    T3CONbits.T3CCP2 = 1;
            
    IPR1bits.CCP1IP = 1;
    PIR1bits.CCP1IF = 0;
    PIE1bits.CCP1IE = 1;
    CCPR1 = per_arrp1[musicstep];
     *
    */

    
    CCP2CON = 10;
    T3CON = 0x81;
    T1CON = 0x81;
    T3CONbits.T3CCP1 = 1;
    T3CONbits.T3CCP2 = 1;
            
    IPR2bits.CCP2IP = 1;
    PIR2bits.CCP2IF = 0;
    PIE2bits.CCP2IE = 1;
    CCPR2 = per_arrp1[musicstep];
    
    TRISCbits.RC1 = 0;
    
    RCONbits.IPEN= 1;
    PIE1bits.TMR1IE =1;
    PIR1bits.TMR1IF =0;
    IPR1bits.TMR1IP =1;
    INTCONbits.GIE =1;
        
    T1CONbits.RD16 = 1;
    T1CONbits.T1CKPS = 3;
    T1CONbits.TMR1CS = 0;
    T1CONbits.TMR1ON = 1;
    
    
    
    TMR1 = 65535 - 7812;
    while(1){
        if(strstr(GetString(), "q") != NULL)
            break;
        else if(strstr(GetString(), "s") != NULL){
            T1CONbits.TMR1ON = 0;
            T3CONbits.TMR3ON = 0;
            ClearBuffer();
        }
        else if(strstr(GetString(), "p") != NULL){
            T1CONbits.TMR1ON = 1;
            T3CONbits.TMR3ON = 1;
            ClearBuffer();
        }
    }
    //T1CONbits.TMR1ON = 0;
    //T3CONbits.TMR3ON = 0;
    modenumber = 0;
    ClearBuffer();
}

void main(void) 
{
    
    SYSTEM_Initialize() ;
    ClearBuffer();
    while(1) {
        // TODO 
        // "clear" > clear UART Buffer()
        if(strstr(GetString(), "clear") != NULL)
            ClearBuffer();
        //ClearBuffer();
        // "mode1" > start Mode1 function as above
        else if(strstr(GetString(), "blink") != NULL){
            Mode1();
        }
            
        // "mode2" > start Mode2 function as above
        else if(strstr(GetString(), "breath") != NULL)
            Mode2();
        else if(strstr(GetString(), "music") != NULL)
            Mode3();
    }
    return;
    
}

// old version: 
// void interrupt high_priority Hi_ISR(void)
void __interrupt(high_priority) Hi_ISR(void)
{
    if(PIR2bits.CCP2IF == 1) {
        LATCbits.LATC1 = !(LATCbits.LATC1);
        if(musicnumber == 1)
            CCPR2 += per_arrp1[musicstep];
        else 
            CCPR2 += per_arrp2[musicstep];
        PIR2bits.CCP2IF = 0;
    }
    else if(TMR1IF){
        /*
        if(modenumber == 1){
            LATDbits.LATD0 = !(LATDbits.LATD0);
            LATDbits.LATD1 = !(LATDbits.LATD1);
            LATDbits.LATD2 = !(LATDbits.LATD2);
            LATDbits.LATD3 = !(LATDbits.LATD3);
            TMR1 = 65535 - 7218*unit;
        }
        */
            ++musiccount;
            if(musicnumber == 1){
                if(musiccount == wait1[musicstep]){
                musiccount = 0;
                musicstep++;
                }
                if(musicstep == 30) musicstep = 0;
            }
            else{
                if(musiccount == wait2[musicstep]){
                musiccount = 0;
                musicstep++;
                }
                if(musicstep == 19) musicstep = 0;
            }
            TMR1 = 65535 - 7812;
        TMR1IF = 0;
    }
    else if(TMR2IF){
        if(modenumber == 1){
            if(unit_count >= unit){
                LATDbits.LATD0 = !(LATDbits.LATD0);
                LATDbits.LATD1 = !(LATDbits.LATD1);
                LATDbits.LATD2 = !(LATDbits.LATD2);
                LATDbits.LATD3 = !(LATDbits.LATD3);
                unit_count = 0;
            }
            else    ++unit_count;
        }
        TMR2 = 255 - 244;
        TMR2IF = 0;
    }
    return ;
}