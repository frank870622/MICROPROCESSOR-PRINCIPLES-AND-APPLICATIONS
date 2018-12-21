#include <xc.h>
    //setting TX/RX

char mystring[10];
int lenStr = 0;

void UART_Initialize() {
        
    /*portC pin6/7 is mult with usart setting their tris*/    
    TRISCbits.TRISC6 = 1;            // Setting by data sheet 
    TRISCbits.TRISC7 = 1;            //  
    
    /*
           Serial Setting      
     * 1.   Setting Baud rate
     * 2.   choose sync/async mode 
     * 3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
     * 3.5  enable Tx, Rx Interrupt(optional)
     * 4.   Enable Tx & RX
     */      
    //  Setting baud rate
    TXSTAbits.SYNC = 0;             //choose the async moode
    BAUDCONbits.BRG16 = 0 ;          //Read Baud rate table
    TXSTAbits.BRGH = 1;
    SPBRG = 51;      
    
   //   Serial enable
    RCSTAbits.SPEN = 1;              //open serial port
    PIR1bits.TXIF = 0;
    PIR1bits.RCIF = 0;
    TXSTAbits.TXEN = 1;             //Enable Tx
    RCSTAbits.CREN = 1;             //Enable Rx
    //setting TX/RX interrupt
    PIE1bits.TXIE = 0;              //disable Tx interrupt
    IPR1bits.TXIP = 0;              //Setting Tx as low priority interrupt
    PIE1bits.RCIE = 1;              //Enable Rx interrupt
    IPR1bits.RCIP = 0;              //Setting Rc as low priority interrupt
    }

void PrintChar(unsigned char a)
{
    TXREG = a;              //write to TXREG will send data 
    return ;
}

char * WriteBuffer(){
    return mystring;
}

void PrintBuffer(char* str) {
    for(int i = 0 ; i < 10 ; i++) {
        TXREG = str[i];
    }
}

void MyusartRead()
{
    mystring[lenStr] = RCREG+1;
    PrintChar(mystring[lenStr]);
    lenStr++;
    lenStr %= 10;
    if(RCREG == '$') TRISC6 = 1;
    if(RCREG == '_') TRISC6 = 0;
    return ;
}

//// old version: 
//// void interrupt high_priority Hi_ISR(void)
//void __interrupt(high_priority) Hi_ISR(void)
//{
//    return ;
//}

// old version: 
// void interrupt low_priority Lo_ISR(void)
void __interrupt(low_priority)  Lo_ISR(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR == 1)
        {
            /*if necessary *handle overrun exception
             * Overrun will set if rcreg fifo is full then third word is recived
             * Then the RCSTA<1> OERR will set
             * how clear?
             * clear CERN OEER will be clear
            */
        }
        
        MyusartRead();
    }
    
   // process other interrupt sources here, if required
    return;
}
