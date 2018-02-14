		LIST	P=PIC16F84A
		INCLUDE	"P16F84A.INC"
		
		__CONFIG	_HS_OSC&_WDT_OFF
		
CNT1	EQU		0CH
CNT2	EQU		0DH
CNT3	EQU		0EH

		ORG		0H
MAIN
		BSF		STATUS, RP0		
		CLRF	TRISB			;PortB -> Output
		BCF		STATUS,	RP0		
MAIN1	
		CLRF	PORTB			;00H -> PortB
		BCF		STATUS,	C		;Carry -> Low
		BSF		PORTB,	0		;PortB0 -> 1
MAINLP
		CALL	TIME0125			;stay 0.125s	
		BTFSC	PORTB,	7		;skip if(PortB7==1)	
		GOTO	MAIN1		
		RLF		PORTB,	F		;Rotate Left PortB ~ C -> PortB 
		GOTO	MAINLP

;10
TIME2U			
		NOP						
		NOP
		NOP						
		NOP
		NOP						
		NOP
		NOP						
		NOP
		RETURN

;10*250
TIME5M 
 		MOVLW 	0A6H ;1c
 		MOVWF 	CNT1 ;1c
		NOP
		NOP						
		NOP
		NOP						
		NOP
		NOP						
		NOP
		NOP						
		NOP	
LOOP1 
 		CALL 	TIME2U		;((y+2)*n = 125n +2n ※yはTIMEyyの【合計クロック数】
 		DECFSZ 	CNT1,F 		;1*(n-1)+2*1  = n+1
 		GOTO 	LOOP1 		;2(n-1)   =2n-2
 		RETURN  			;2

;2500*250
TIME0125 
 		MOVLW 	0FAH ;1c
 		MOVWF 	CNT2 ;1c

LOOP2 
 		CALL 	TIME5M	;((y+2)*n = 125n +2n ※yはTIMEyyの【合計クロック数】
 		DECFSZ 	CNT2,F 		;1*(n-1)+2*1  = n+1
 		GOTO 	LOOP2		;2(n-1)   =2n-2
 		RETURN  			;2
		

		END