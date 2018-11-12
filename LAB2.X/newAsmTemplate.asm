LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67    ; Oscillator Selection bits (INternal oscillator block, port function on RA6 and RA7)
    CONFIG WDT = OFF	    ; Watthdog Timer Enable bit (WDT disabled ( control is placed on the SWDTEN bit))
    
	org	0x00
Initial:
;*********************************
start:
    CLRF WREG
    CLRF TRISD
    ADDLW 0x08
    ADDWF TRISD, 1
    LFSR FSR0, 107H
    LFSR FSR1, 110H
    LFSR FSR2, 120H
array1:
    MOVFF TRISD, POSTDEC0
    MOVFF TRISD, POSTINC1
    MOVFF TRISD, POSTINC2
    DECFSZ TRISD
    goto array1
    ADDWF TRISD, 1

    LFSR FSR0, 107H
    LFSR FSR1, 117H
    LFSR FSR2, 127H
array2:
    CLRF WREG
    ADDWF POSTDEC0, 0
    ADDWF POSTDEC2, 1
    DECFSZ TRISD
    goto array2
    
NOP

continue:
    
end
    


