LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67    ; Oscillator Selection bits (INternal oscillator block, port function on RA6 and RA7)
    CONFIG WDT = OFF	    ; Watthdog Timer Enable bit (WDT disabled ( control is placed on the SWDTEN bit))
    
	org	0x00
Initial:
;*********************************
start:
    clrf    WREG    
    clrf    TRISD
    addlw   0x0a
    addwf   TRISD, 1
    decf    TRISD
    
here:
    addwf TRISD, 0
    decfsz  TRISD
    goto here
continue:
    
end
    


