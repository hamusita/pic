		LIST	P=PIC16F84A
		INCLUDE	"P16F84A.INC"
		
		__CONFIG	_HS_OSC
	
		ORG		0H
MAIN
		BSF		STATUS,	RP0		;BANK 1
		CLRF	TRISB			;RB
		BCF		STATUS,	RP0		;Bank 0
		CLRF	PORTB
		BSF		PORTB,	2
		BSF		PORTB,	4
		BSF		PORTB,	6
		
		
		END
		