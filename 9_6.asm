			LIST P=PIC16F84A
			#INCLUDE<P16F84A.INC>
		
			__CONFIG _HS_OSC&_CP_OFF&_WDT_OFF&_PWRTE_ON

W_TEMP		EQU		0CH
STATUS_TEMP	EQU		0DH
CNT1		EQU		0EH
CNTB		EQU		0FH
TMPA		EQU		010H
COUNT		EQU		011H	;�֐߃A�h���b�V���O�p�̃A�h���X�i�[�������
IN			EQU		012H
;**********************************
CAL1		EQU		013H
CAL2		EQU		014H
CAL3		EQU		015H	;�����R�[�h�i�[���v�Z�p���
CAL4		EQU		016H
CAL5		EQU		017H
CAL6		EQU		018H
;**********************************
BIN			EQU		019H	;BCD�p���
BCD1		EQU		01AH
BCD2		EQU		01BH
CNT			EQU		01CH
;**********************************
ANS1		EQU		01DH	;�����Ȃ��ŁI
ANS2		EQU		01EH
ANS3		EQU		01FH
;**********************************
J1			EQU		020H	;+,-�J�E���^
J2			EQU		021H	;=�J�E���^
;**********************************
	
			ORG		0H
			GOTO	MAIN
			
			ORG		04H

;PUSH
			MOVWF	W_TEMP
			MOVF	STATUS,W
			MOVWF	STATUS_TEMP

			CALL	CRECV
			MOVWF	BIN
			CALL	VAR

;POP
			MOVF	STATUS_TEMP,W
			MOVWF	STATUS
			SWAPF	W_TEMP,F
			SWAPF	W_TEMP,W
			BCF		INTCON,INTF
			RETFIE

;REMAINING CODE GOES HERE

MAIN
			BSF		STATUS,RP0
			BCF		INTCON,GIE
			CLRF	TRISA
			MOVLW	00FH
			MOVWF	TRISB
			BCF		OPTION_REG,INTEDG
			BCF		STATUS,RP0
			CLRF	COUNT
			CLRF	J2
			CLRF	J1
			CLRF	ANS3
			CLRF	CAL1
			CLRF	CAL2
			CLRF	CAL3
			CLRF	CAL4
			CLRF	CAL5
			CLRF	CAL6
			BSF		INTCON,GIE
			BSF		INTCON,INTE


MAINLP
			GOTO	MAINLP


CRECV
			CLRF	TMPA
			MOVLW	08H
			MOVWF	CNTB
			CALL	TIME156

CRECVLP
			BTFSC	PORTB,0
			BSF		STATUS,C
			BTFSS	PORTB,0
			BCF		STATUS,C
			RRF		TMPA,F
			CALL	TIME104
			DECFSZ	CNTB,F
			GOTO	CRECVLP
			MOVF	TMPA,W
			RETURN

CSEND			;WREG->CHARACTOR CODE
			MOVWF	IN
			MOVLW	08H
			MOVWF	CNTB
			BCF		PORTA,4		;START BIT
			CALL	TIME104		;DELAY 104U
CSENDLP
			BTFSC	IN,0
			BSF		PORTA,4
			BTFSS	IN,0
			BCF		PORTA,4
			CALL	TIME104
			RRF		IN,F
			DECFSZ	CNTB,F
			GOTO	CSENDLP
			BSF		PORTA,4
			CALL	TIME104
			RETURN

TIME156
			MOVLW	0C3H
			MOVWF	CNT1
LOOP1
			NOP
			DECFSZ	CNT1,F
			GOTO	LOOP1
			RETURN

TIME104
			MOVLW	082H
			MOVWF	CNT1
LOOP2
			NOP
			DECFSZ	CNT1,F
			GOTO	LOOP2
			RETURN

VAR			;CAL1~6�ɑ���֐߃A�h���b�V���O�łԂ����ނ�ŁI
			MOVLW	013H
			ADDWF	COUNT,W
			MOVWF	FSR
			CALL	CRECV
			MOVWF	INDF
			INCF	COUNT,F
			MOVF	COUNT,W
			CALL	CSEND
			
			MOVLW	B'00001101'
			CALL	CSEND
			MOVLW	B'00001010'
			CALL	CSEND

			MOVF	CAL1,W
			CALL	CSEND
			MOVF	CAL2,W
			CALL	CSEND
			MOVF	CAL3,W
			CALL	CSEND
			MOVF	CAL4,W
			CALL	CSEND
			MOVF	CAL5,W
			CALL	CSEND
			MOVF	CAL6,W
			CALL	CSEND
			MOVLW	B'00001101'
			CALL	CSEND
			MOVLW	B'00001010'
			CALL	CSEND

			;=�����͂��ꂽ��i6�߂̓��͂�������jimport�ɔ�Ԃ�ŁI
			MOVF	COUNT,W	
			XORLW	06H
			BTFSC	CAL6,5	
			CALL	IMPORT
			
			RETURN
				
			
IMPORT		;+-���肵�ĕ����R�[�h���琔�l�ɕϊ������ŁI
			MOVF	CAL3,W
			XORLW	'-';-�Ȃ�0�ɂȂ�
			MOVWF	J1

			;���e�����̏���
			CLRF	CAL3
			CLRF	CAL6
			MOVLW	'0'  
			SUBWF	CAL1,F
			COMF	CAL1,F
			SUBWF	CAL2,F
			COMF	CAL2,F
			SUBWF	CAL4,F
			COMF	CAL4,F
			SUBWF	CAL5,F
			COMF	CAL5,F

			SWAPF	CAL1,W
			IORWF	CAL2,W
			MOVWF	CAL3

			CALL	CSEND
			
			SWAPF	CAL4,W
			IORWF	CAL5,W
			MOVWF	CAL6

			CALL	CSEND

			MOVLW	B'00001101'
			CALL	CSEND
			MOVLW	B'00001010'
			CALL	CSEND

			BTFSC	J1,2
			CALL	ADD
			BTFSS	J1,2
			CALL	SUB

			RETURN	

ADD			;���Z��ŁI
			MOVF	CAL3,W
			ADDWF	CAL6,F	
			CALL	BCDC
			GOTO	ADDEXPORT

ADDEXPORT	;���l���當���R�[�h�ɕϊ������ŁI
			;�S�̈ʑ��M
			INCF	BCD2,W
			ADDLW	'0'
			DECFSZ	W,W
			CALL	CSEND

			;�\�̈�
			SWAPF	BCD1,W
			ANDLW	B'00001111'
			ADDLW	'0'
			CALL	CSEND

			;��̈�
			MOVF	BCD1,W
			ANDLW	B'00001111'
			ADDLW	'0'
			CALL	CSEND

			MOVLW	B'00001101'
			CALL	CSEND
			MOVLW	B'00001010'
			CALL	CSEND

			CALL	VARSET

			RETURN

SUB			;���Z��ŁI
			MOVF	CAL3,W
			SUBWF	CAL6,W
			BTFSC	W,7	
			CALL	SETMIN
			COMF	W,W
			GOTO	SUBEXPORT

SETMIN
			MOVLW	B'00101101'
			CALL	CSEND
			RETURN

SUBEXPORT	;����ς萔�l����R�[�h�ɕϊ������ŁI
			;�\�̈�
			SWAPF	BCD1,W
			ANDLW	B'00001111'
			ADDLW	'0'
			CALL	CSEND

			;��̈�
			MOVF	BCD1,W
			ANDLW	B'00001111'
			ADDLW	'0'
			CALL	CSEND
			
			MOVLW	B'00001101'
			CALL	CSEND
			MOVLW	B'00001010'
			CALL	CSEND

			CALL	VARSET

			RETURN

VARSET
			CLRF	COUNT
			CLRF	CAL1
			CLRF	CAL2
			CLRF	CAL3
			CLRF	CAL4
			CLRF	CAL5
			CLRF	CAL6
			CLRF	J1

			RETURN		

BCDC
	CLRF	CNT
	CLRF	BIN
	CLRF	BCD1
	CLRF	BCD2
	MOVLW	D'8'	 ;8��J��Ԃ�
	MOVWF	CNT	 ;CNT=8
	BCF		STATUS,C
	MOVF	CAL6,W	 ;�����ɓK���Ȑ�������(255�܂�)
	MOVWF	BIN	 ;BIN=?
BCDC_2
	RLF		BIN,F	 ;�S�̓I�ɍ��ɉ�
	RLF		BCD1,F
	RLF		BCD2,F
	BTFSC	STATUS,C ;DEC1�Ɉړ�����r�b�g(0=SKIP)
	BSF		BCD1,0	 ;C=1
	DECFSZ	CNT,F
	GOTO	BCDC_6	 ;LOOP<8
	GOTO	BCDC_5	 ;LOOP=8
BCDC_6
	MOVLW	0x03	 ;W=0x03
	ADDWF	BCD1,F	 ;[BCD1]+03H
	BTFSC	BCD1,3	 ;4bit => 5?
	GOTO	BCDC_3	 ;     => 5 (5~)
	MOVLW	0x03	 ;W=0x03
	SUBWF	BCD1,F	 ;[BCD1]-03H
BCDC_3
	MOVLW	0x30	 ;W=0x30
	ADDWF	BCD1,F	 ;[BCD1]+30H
	BTFSC	BCD1,7	 ;8BIT =>5?
	GOTO	BCDC_4	 ;     =>5 (5~)
	MOVLW	0x30	 ;W=0x30
	SUBWF	BCD1,F	 ;[BCD1]-30H
BCDC_4
	MOVLW	0x03	 ;W=0x03
	ADDWF	BCD2,F	 ;[BCD2]-03H
	BTFSC	BCD2,3	 ;12BIT =>5?
	GOTO	BCDC_2	 ;	=>5 (5~)
	MOVLW	0x03	 ;W=0x03
	SUBWF	BCD2,F	 ;[BCD2]-03H
	GOTO	BCDC_2
BCDC_5
	RETURN	;RETURN�ɂ����CALL���ꂽ���ɋA���I

			END