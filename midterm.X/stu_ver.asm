LIST p=18f4520
#include<p18f4520.inc>

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setting file register address.
COUNT set 0X100	    
DIVISORH set 0X110   
DIVISORL set 0X111
REMAINDERH set 0X120
REMAINDERL set 0X121
QUOTIENT set 0x0130 ; 
temp	set 0x140


#define Button1Flag 0X160, 0 ; You can use it or not.
#define Button2Flag 0X170, 0 ; You can use it or not.
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; Teacher assistent will provide input data.
Input1H EQU 0x0F
Input1L EQU 0x8C 
Input2  EQU 0x6F ; 0xF7C/0x6F = 0x23 ... 0x4F
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
ORG 0X00  
bra Init
ORG 0X08 ; setting interrupt service routine 
bra isr	
	
rrcf4time macro origf, destf ; rotate your orginal register to destination for 4 times
			     ; Clear your destination first.
	clrf	destf
	movlw	origf
	movwf	destf
	rlcf	destf
	rlcf	destf
	rlcf	destf
	rlcf	destf
	endm
	
; Build the delay macro 
#define SWITCH PORTA, 4
    L1	    EQU 0x14
    L2	    EQU 0x15
	    
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
	NOP
	NOP
	NOP
	DECFSZ L1
	BRA LOOP1
	DECFSZ L2
	BRA LOOP2
endm
Init:	bsf OSCCON, IRCF2 ; Internal Oscillator Frequency is set 4Mhz
	bsf OSCCON, IRCF1 ; Don't remove 3 lines !!!
	bcf OSCCON, IRCF0 
			  
    CLRF    PORTB
    CLRF    LATB
    clrf     TRISB
    BSF	    TRISB, 0
    BSF	    TRISB, 4
    MOVLW   0x0f
    MOVWF   ADCON1
    CLRF    TRISD
    CLRF    LATD
    CLRF    PORTD
    

    bsf	    INTCON, INT0IE
    bsf	    INTCON, RBIE
    bcf	    INTCON, INT0IF
    bcf	    INTCON, RBIF
    bsf	    INTCON, GIE
    bcf	    INTCON2, INTEDG0
			  ; Setting button1&button2 interrupt configuration on INTx(Just pick any 2 from Int0-Int2)  
			  ;
			  ;		  
			  ; Setting config for lighting LED (RD3-RD0)	
    bcf Button1Flag
    bcf Button2Flag
    
    
    movlw   Input1H
    movwf   REMAINDERH, A
    movlw   Input1L
    movwf   REMAINDERL, A
    movlw   0
    movwf   DIVISORL, A
    movlw   Input2
    movwf   DIVISORH, A
    movlw   d'9'
    movwf   COUNT
    clrf    QUOTIENT
    
    
loop:
    clrf    STATUS
    movf    DIVISORL, W, A
    subwf   REMAINDERL, W, A
    movwf   temp
    movf    DIVISORH, W, A
    subwfb  REMAINDERH, W, A
    btfsc   STATUS, N
    goto less
    rlcf QUOTIENT
    bsf	QUOTIENT, 0
    movwf   REMAINDERH
    movf   temp, W, A
    movwf   REMAINDERL
    goto    next
less:
    rlcf    QUOTIENT
    bcf	QUOTIENT, 0, A
next:
    rrcf	    DIVISORL
    bcf	    DIVISORL, 7
    btfsc   DIVISORH, 0
    bsf	    DIVISORL, 7
    rrcf    DIVISORH
    bcf   DIVISORH, 7

    decfsz  COUNT
    goto loop
    
    movlb   1
    movf   REMAINDERL, W, A
    movwf   0x23, 1
    movwf   0x24, 1
    swapf    0x23, F, 1
    movlw   b'00001111'
    andwf   0x23, F, 1
    andwf   0x24, F, 1
    
    movf   QUOTIENT, W, A
    movwf   0x33, 1
    movwf   0x34, 1
    swapf    0x33, F, 1
    movlw   b'00001111'
    andwf   0x33, F, 1
    andwf   0x34, F, 1
forever:
    NOP
    btfsc   Button1Flag, 0
    goto button1
    btfsc   Button2Flag, 0
    goto button2
    goto forever
button1:
    DELAY
    DELAY
    movf 0x23, 0, 1
    movwf   LATD
    DELAY
    DELAY
    DELAY
    DELAY
    clrf LATD
    DELAY
    DELAY
    movf 0x24, 0, 1
    movwf   LATD
    DELAY
    DELAY
    DELAY
    DELAY
    clrf LATD
    bcf	Button1Flag, 0
    goto forever
button2:
    DELAY
    DELAY
    movf 0x33, 0, 1
    movwf   LATD
    DELAY
    DELAY
    DELAY
    DELAY
    clrf LATD
    DELAY
    DELAY
    movf 0x34, 0, 1
    movwf   LATD
    DELAY
    DELAY
    DELAY
    DELAY
    clrf LATD
    bcf	Button2Flag, 0
    goto forever
    nop

Divide:  ; divde 
	; You can write macro of divide, or not.
	; Input1 is Dividend, Input2 is Division. 
	; For example, 0xFFC / 0x11h =  0xFF0...0xC.
	; 0xFFC: Dividend (0xF: DividendH, 0xFC: DividendL). 
	; 0X11: Division.  0XFF0: Quotient. 0xc: Remainder
	; You must push result values to QUOTIENT(0X130), REMAINDERL(0x121) before you shift values.
Transfer:  
	; rotate register	
	; transfer values to specified file registers.
	; you can design a better method you think.
	
mainLoop: bra mainLoop
	  ; You must add some codes, then make your hardware is operated successfully.
	  ; about intx of button , just pick any 2 from int0-int2
	  ; Writing delay macro on interrupt service routine will get zero score.
	  ; hint: Button1Flag&Button2Flag are good partners!
	 
q_blink: 	; Designing Quotient_blink for Subroutine
	return 
r_blink: 	; Designing Remainder_blink for Subroutine
	return 
	
isr:	; Don't create Delay here!
    btfsc   INTCON, INT0IF
    bsf    Button1Flag, 0
    btfsc   INTCON, RBIF
    bsf	   Button2Flag, 0
    bcf	INTCON, INT0IF
    bcf	INTCON, RBIF
    retfie
	END