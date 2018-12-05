LIST p=18f4520
#include<p18f4520.inc>
CONFIG OSC = INTIO67
CONFIG WDT = OFF
CONFIG LVP = OFF

ORG 0X00
    
light1	macro
    
endm 


goto INIT
    
ISR:
    org	0x08
    decf    0x25
    bcf	PIR1, TMR2IF
    retfie  
INIT: 

    MOVLW   0x0f
    MOVWF   ADCON1
    CLRF    TRISD
    CLRF    LATD
    CLRF    PORTD
    

    bcf	    PIR1,TMR2IF
    bsf	    PIE1,TMR2IE
    bsf	    IPR1,TMR2IP
    bsf	    INTCON, GIE
    bsf	    RCON, IPEN
    movlw  d'125'
    movwf   PR2	
    movlw  d'125'
    movwf   0x25
    movlw  b'00000111'
    movwf   T2CON

forever:
    NOP
    tstfsz  0x25
    bra forever
light:
    movlw d'125'
    movwf 0x25
    incf    LATD
    bra forever

END
    


