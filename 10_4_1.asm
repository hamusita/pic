	LIST	P=PIC16F819
	#INCLUDE<P16F819.INC>
	
	__CONFIG	_HS_OSC&_CP_OFF&_WDT_OFF&_PWRTE_ON&_MCLR_ON&_LVP_OFF
	
W_TEMP		EQU	020H
STATUS_TEMP	EQU	021H
CNT1		EQU	022H
CNTB		EQU	023H
TMPA		EQU	024H
IN		EQU	025H
ADH0		EQU	026H
ADL0		EQU	027H
ADH1		EQU	028H
ADL1		EQU	029H
ADH2		EQU	030H
ADL2		EQU	031H
ADH3		EQU	032H
ADL3		EQU	033H
FLAG		EQU	034H

	ORG	0H
	GOTO	MAIN
	
	ORG	04H
;PUSH
	MOVWF	W_TEMP
	MOVF	STATUS,W
	MOVWF	STATUS_TEMP
	
	BSF	FLAG,0
;POP
	MOVF	STATUS_TEMP,W
	MOVWF	STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W
	BCF	INTCON,INTF
	RETFIE
MAIN
	BSF	STATUS,RP0
	BCF	INTCON,GIE
	MOVLW	0FH
	MOVWF	TRISA
	MOVLW	01H
	MOVWF	TRISB
	BCF	OPTION_REG,INTEDG
	MOVLW	08EH
	MOVWF	ADCON1
	BCF	STATUS,RP0
	BSF	PORTA,4
	CLRF	PORTB
	CLRF	FLAG
	BSF	INTCON,GIE
	BSF	INTCON,INTE
MAINLP
	BTFSS	FLAG,0
	GOTO	MAINLP
ADSTART0
	MOVLW	081H
	MOVWF	ADCON0
	
	CALL	TIME20U
	BSF	ADCON0,GO
ADLOOP0
	BTFSC	ADCON0,GO
	GOTO	ADLOOP0
	MOVF	ADRESH,W
	MOVWF	ADH0
	BSF	STATUS,RP0
	MOVF	ADRESL,W
	BCF	STATUS,RP0
	MOVWF	ADL0
ADSTART1
	MOVLW	B'10001001'
	MOVWF	ADCON0
	
	CALL	TIME20U
	BSF	ADCON0,GO
ADLOOP1
	BTFSC	ADCON0,GO
	GOTO	ADLOOP1
	MOVF	ADRESH,W
	MOVWF	ADH1
	BSF	STATUS,RP0
	MOVF	ADRESL,W
	BCF	STATUS,RP0
	MOVWF	ADL1
ADSTART2
	MOVLW	B'10010001'
	MOVWF	ADCON0
	
	CALL	TIME20U
	BSF	ADCON0,GO
ADLOOP2
	BTFSC	ADCON0,GO
	GOTO	ADLOOP2
	MOVF	ADRESH,W
	MOVWF	ADH2
	BSF	STATUS,RP0
	MOVF	ADRESL,W
	BCF	STATUS,RP0
	MOVWF	ADL2	
ADSTART3
	MOVLW	B'10011001'
	MOVWF	ADCON0
	
	CALL	TIME20U
	BSF	ADCON0,GO
ADLOOP3
	BTFSC	ADCON0,GO
	GOTO	ADLOOP3
	MOVF	ADRESH,W
	MOVWF	ADH3
	BSF	STATUS,RP0
	MOVF	ADRESL,W
	BCF	STATUS,RP0
	MOVWF	ADL3
	
	;���M
	MOVF	ADH0,W			
	CALL	CSEND	
	MOVF	ADL0,W	
	CALL	CSEND

	MOVF	ADH1,W	
	CALL	CSEND	
	MOVF	ADL1,W	
	CALL	CSEND

	MOVF	ADH2,W	
	CALL	CSEND	
	MOVF	ADL2,W
	CALL	CSEND

	MOVF	ADH3,W	
	CALL	CSEND	
	MOVF	ADL3,W	
	CALL	CSEND
	
	CLRF	FLAG
	GOTO	MAINLP
CSEND	
	MOVWF	IN
	MOVLW	08H
	MOVWF	CNTB
	BCF	PORTA,4
	CALL	TIME52
CSENDLP
	BTFSC	IN,0
	BSF	PORTA,4
	BTFSS	IN,0
	BCF	PORTA,4
	CALL	TIME52
	RRF	IN,F
	DECFSZ	CNTB,F
	GOTO	CSENDLP
	BSF	PORTA,4
	CALL	TIME52
	RETURN
TIME20U
	MOVLW	020H
	MOVWF	CNT1
	NOP
LOOP0
	DECFSZ	CNT1,F
	GOTO	LOOP0
	RETURN
TIME52
	MOVLW	041H
	MOVWF	CNT1
LOOP1	
	NOP
	DECFSZ	CNT1,F
	GOTO	LOOP1
	RETURN
		
	END
	
