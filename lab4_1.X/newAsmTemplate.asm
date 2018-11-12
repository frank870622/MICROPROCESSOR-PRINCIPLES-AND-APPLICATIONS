LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67    ; Oscillator Selection bits (INternal oscillator block, port function on RA6 and RA7)
    CONFIG WDT = OFF	    ; Watthdog Timer Enable bit (WDT disabled ( control is placed on the SWDTEN bit))
    
	org	0x00
;*********************************
function:
movlf	macro	literal, f
	addlw literal
	movwf f
	CLRF WREG
	endm
start:
    CLRF WREG
    clrf TRISD
    movlf 0x01, 0x12
    movlf 0x02, 0x13
    clrf    WREG
    movlf	8, TRISD
    rcall Fib
    goto Finish
Fib:
    clrf	WREG
    addwf	0x12, 0
    addwf	0x13, 0
    movwf	0x14, 0
    movff 0x13, 0x12
    movff 0x14, 0x13
    decfsz	TRISD
    rcall 0x1e
    return
    
Finish:
NOP
NOP  
end
