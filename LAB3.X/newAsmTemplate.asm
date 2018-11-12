LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67    ; Oscillator Selection bits (INternal oscillator block, port function on RA6 and RA7)
    CONFIG WDT = OFF	    ; Watthdog Timer Enable bit (WDT disabled ( control is placed on the SWDTEN bit))
    
	org	0x00
Initial:
;*********************************
start:
    CLRF WREG
    ADDLW 0xB5
    ANDLW 0x7C
    XORLW 0xFF
    MOVWF LATD
    
    CLRF WREG
    ADDLW 0x96
    IORLW 0x69
    XORLW 0xFF
    MOVWF LATC
NOP

continue:
NOP  
end
    





