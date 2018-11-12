LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67    ; Oscillator Selection bits (INternal oscillator block, port function on RA6 and RA7)
    CONFIG WDT = OFF	    ; Watthdog Timer Enable bit (WDT disabled ( control is placed on the SWDTEN bit))
    
	org	0x00
;*********************************
start:
 clrf LATA
 clrf LATB
 clrf LATC
 clrf LATD
 clrf LATE
 movlw 0x08
 movwf LATE
 movlw 0x10
 movwf LATD
 movlw 0x11
 movwf LATC
 clrf WREG
 
open:
    goto shift
aftershift:
    btfsc LATC, 7
    goto multer
aftermul:
    BCF STATUS, 0
    rlcf LATC, f
    BCF LATC, 0, 0
    decfsz LATE
    goto open
    movff LATB, 0x003
    movff LATA, 0x001
    goto exit
    
multer:
    movff LATD, WREG
    addwf LATB,f
    clrf WREG
    addwfc LATA, f
    goto aftermul

shift:    
    rlncf LATA, f
    BTFSC LATB, 7
    incf LATA
    rlncf LATB, f
    BCF LATB, 0, 0
    clrf WREG
    goto aftershift
    
exit:
    NOP
end
    








