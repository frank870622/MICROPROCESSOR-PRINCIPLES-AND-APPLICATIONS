
LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67    ; Oscillator Selection bits (INternal oscillator block, port function on RA6 and RA7)
    CONFIG WDT = OFF	    ; Watthdog Timer Enable bit (WDT disabled ( control is placed on the SWDTEN bit))
    
	org	0x00
;*********************************
start:
    CLRF WREG
    CLRF LATA
    CLRF LATB
    ADDLW 0x01
    
lab2loop:
    ADDWF LATA, 1
    BOV rotate
    INCF WREG
    goto lab2loop
    NOP
    NOP
    NOP
    GOTO initial

initial:
    GOTO rotate
rotate:
    CLRF WREG
    ADDLW 0x8F
    MOVWF LATB
    BSF STATUS, 0
    RLCF    LATB, 0
    
NOP  
end
    





