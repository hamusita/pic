		LIST P=PIC16F819
		#INCLUDE<P16F819.INC>
		
		__CONFIG	_HS_OSC& _CP_OFF & _WDT_OFF&_PWRTE_ON&_MCLR_ON&_LVP_OFF
		
CNT		EQU		020H
		
		ORG		0H
MAIN
		;
		BSF		STATUS,		RP0
		MOVLW	01H
		MOVWF	TRISA
		CLRF	TRISB
		;bank1
		MOVLW	00EH
		MOVWF	ADCON1
		BCF		STATUS,		RP0
		;bank0
		MOVLW	081H
		MOVWF	ADCON0
		CLRF	PORTA
		CLRF	PORTB
		
ADSTART
		CALL	TIME20U
		BSF		ADCON0,GO
ADLOOP
		BTFSC	ADCON0,GO
		GOTO	ADLOOP
		RRF		ADRESH,F
		RRF		ADRESH,W
		CALL	BCD
		CLRF	PORTB
		MOVWF	PORTB
		GOTO	ADSTART
		
;20us
TIME20U
		MOVLW	020H
		MOVFW	CNT
		NOP
		NOP

LOOP
		DECFSZ	CNT,F
		GOTO	LOOP
		RETURN
;fin

;ìÒêiêîâª	
BCD
		ANDLW	03FH
		ADDWF	PCL,F
        RETLW   00H
        RETLW   01H
        RETLW   02H
        RETLW   02H
        RETLW   03H
        RETLW   04H
        RETLW   05H
        RETLW   05H
        RETLW   06H
        RETLW   07H
        RETLW   08H
        RETLW   09H
        RETLW   09H
        RETLW   10H
        RETLW   11H
        RETLW   12H
        RETLW   12H
        RETLW   13H
        RETLW   14H
        RETLW   15H
        RETLW   16H
        RETLW   16H
        RETLW   17H
        RETLW   18H
        RETLW   19H
        RETLW   20H
        RETLW   20H
        RETLW   21H
        RETLW   22H
        RETLW   23H
        RETLW   23H
        RETLW   24H
        RETLW   25H
        RETLW   26H
        RETLW   27H
        RETLW   27H
        RETLW   28H
        RETLW   29H
        RETLW   30H
        RETLW   30H
        RETLW   31H
        RETLW   32H
        RETLW   33H
        RETLW   34H
        RETLW   34H
        RETLW   35H
        RETLW   36H
        RETLW   37H
        RETLW   38H
        RETLW   38H
        RETLW   39H
        RETLW   40H
        RETLW   41H
        RETLW   41H
        RETLW   42H
        RETLW   43H
        RETLW   44H
        RETLW   45H
        RETLW   45H
        RETLW   46H
        RETLW   47H
        RETLW   48H
        RETLW   48H
        RETLW   49H
;fin
		END