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
   MOVLW    d'180'
   MOVWF    L2
   LOOP2:
	MOVLW d'200'
	MOVWF	 L1
   LOOP1:
	NOP
	btfss	PORTA, 4, 0
	bra gotostop
	DECFSZ L1
	BRA LOOP1
	DECFSZ L2
	BRA LOOP2
endm
	
DELAY1 MACRO
   local LOOP1
   local LOOP2
   MOVLW    d'180'
   MOVWF    L2
   LOOP2:
	MOVLW d'200'
	MOVWF	 L1
   LOOP1:
	NOP
	btfss	PORTA, 4, 0
	bra gotorun
	DECFSZ L1
	BRA LOOP1
	DECFSZ L2
	BRA LOOP2
endm   
	
DELAY2 MACRO
   local LOOP1
   local LOOP2
   MOVLW    d'180'
   MOVWF    L2
   LOOP2:
	MOVLW d'200'
	MOVWF	 L1
   LOOP1:
	NOP
	DECFSZ L1
	BRA LOOP1
	DECFSZ L2
	BRA LOOP2
endm 
   
INIT: 
    CLRF    PORTA
    CLRF    LATA
    BSF	    TRISA, 4
    MOVLW   0x0f
    MOVWF   ADCON1
    CLRF    TRISD
    CLRF    LATD
run:
    DELAY
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
    bra run
stop:
    movlw 0x00
    movwf LATD
    DELAY1
    bra	stop

gotostop:
    movlw 0x00
    movwf LATD
    DELAY2
    bra stop
gotorun:
    DELAY2
    bra run
    
      
END
    


