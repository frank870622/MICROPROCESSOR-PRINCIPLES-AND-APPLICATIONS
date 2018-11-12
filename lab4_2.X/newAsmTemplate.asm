LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67    ; Oscillator Selection bits (INternal oscillator block, port function on RA6 and RA7)
    CONFIG WDT = OFF	    ; Watthdog Timer Enable bit (WDT disabled ( control is placed on the SWDTEN bit))
    
	org	0x00
;*********************************
function:
movlf	macro	literal, f, bank
	addlw literal
	movwf f, bank
	CLRF WREG
	endm
start:
    CLRF WREG
    LFSR    FSR0, 100H
    MOVLB 1
    movlf   6, 0x40, 1
    movlf   5, 0x16, 1
    movlf   4, 0x54, 1
    movff   0x140, POSTINC0
    movff   0x116, POSTINC0
    movff   0x154, INDF0
    rcall   mclear
    goto finish
mclear:
    clrf    WREG
    addlw   0x01
    mulwf   0x40, 1
    movff   PROD, WREG
    mulwf   0x16, 1
    movff   PROD, WREG
    mulwf   0x54, 1
    clrf    0x40, 1
    clrf    0x16, 1
    clrf    0x54, 1
    return
    
finish:
    movff POSTDEC0, 0x154
    movff POSTDEC0, 0x116
    movff POSTDEC0, 0x140
    
    
    
NOP  
end
    





