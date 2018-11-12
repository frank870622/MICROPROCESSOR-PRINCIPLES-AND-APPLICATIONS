LIST p=18f4520
#include<p18f4520.inc>
CONFIG OSC = INTIO67
CONFIG WDT = OFF
CONFIG LVP = OFF

#define SWITCH PORTA, 4
    L1	    EQU 0x14
    L2	    EQU 0x15
   ORG 0X00
    
	
DELAY MACRO
   local LOOP1
   local LOOP2
   MOVLW    d'90'
   MOVWF    L2
   LOOP2:
	MOVLW d'200'
	MOVWF	 L1
   LOOP1:
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1
	BRA LOOP1
	DECFSZ L2
	BRA LOOP2
endm 

goto INIT
ISR:
    org	0x08
    movlw   0x01
    movwf   LATD
    DELAY
    movlw   0x02
    movwf   LATD
    DELAY
    movlw   0x04
    movwf   LATD
    DELAY
    movlw   0x08
    movwf   LATD
    DELAY
    movlw   0x00
    movwf   LATD
    bcf	INTCON, INT0IF
    retfie  
INIT: 
    CLRF    PORTB
    CLRF    LATB
    BSF	    TRISB, 0
    MOVLW   0x0f
    MOVWF   ADCON1
    CLRF    TRISD
    CLRF    LATD
    CLRF    PORTD
    

    bsf	    INTCON, INT0IE
    bcf	    INTCON, INT0IF
    bsf	    INTCON, GIE
    bcf	    INTCON2, INTEDG0
    
forever:
    NOP
    bra forever
    
      
END
    


