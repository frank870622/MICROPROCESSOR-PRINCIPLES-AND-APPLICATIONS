LIST p=18f4520
    #include<p18f4520.inc>
    CONFIG OSC=INTIO67
    CONFIG WDT=OFF
    CONFIG LVP=OFF
    

    #define switch PORTA,4
    L1 EQU 0x14
    L2 EQU 0x15
 org 0x00
delay macro 
 local LOOP1
 local LOOP2
 movlw d'180'
 movwf L2
 LOOP1:
    movlw d'200'
    movwf L1
 LOOP2:
    NOP
    NOP
    NOP
    NOP
    NOP
    DECFSZ L1
    BRA LOOP2
    DECFSZ L2
    BRA LOOP1
    ENDM
    
    
    clrf TRISD
    clrf LATD
CYCLE:
    movlw 0x01
    movwf LATD
    delay 
    movlw 0x02
    movwf LATD
    delay
    movlw 0x04
    movwf LATD
    delay
    movlw 0x08
    movwf LATD
    delay 
    goto CYCLE
    
end


