
#include "xc.inc"
GLOBAL _add
    
PSECT mytext, local, class=CODE, reloc=2

_add:
 clrf LATA
 clrf LATB
 clrf LATC
 clrf LATD
 clrf LATE
 movlw 0x08
 movwf LATE, f
 MOVFF 0x001, LATD
 MOVFF 0x003, LATC
 clrf WREG
 
open:
    goto shift
aftershift:
    btfsc LATC, 7
    goto multer
aftermul:
    rlcf LATC, f
    BCF LATC, 0, 0
    decfsz LATE
    goto open
    movff LATB, 0x001
    movff LATA, 0x002
    return
    
multer:
    movff LATD, WREG
    addwf LATB,f
    clrf WREG
    addwfc LATA, f
    goto aftermul

shift:    
    rlncf LATA,	 f
    BTFSC LATB, 7
    incf LATA
    rlncf LATB, f
    BCF LATB, 0, 0
    clrf WREG
    goto aftershift
    