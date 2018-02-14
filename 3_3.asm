		LIST	P=PIC16F84A
		INCLUDE "P16F84A.INC"
		
		__CONFIG _HS_OSC
		
TMP0	EQU 0CH
TMP1	EQU 0DH

		ORG 0H
MAIN
		BSF		STATUS, RP0		;Bank 1 �����ݒ�J�n
		CLRF	TRISA			;PortA->Output
		MOVLW	0FFH			;11111111->W	W���W�X�^��0FFH(8�i��)���Ԃ�����
		MOVWF 	TRISB			;PortB->Input
		BCF		STATUS, RP0		;Bank 0 �ݒ�I��
		CLRF	PORTA			;All RA->Low	RA���I�[���N���A
LOOP
		MOVF	PORTB, W		;�|�[�gB��W���W�X�^�ɂԂ�����
		ANDLW	B'00001111'		;RB(A)��W��AND����W�ɂԂ�����
		MOVWF	TMP0			;W��TMP0��

		MOVF	PORTB, W		;�|�[�gB��W���W�X�^�ɂԂ�����
		ANDLW	B'11110000'		;RB(B)��W��
		MOVWF	TMP1			;W��TMP1��

		BCF		STATUS, C		;�N���A
		RRF		TMP1,	W		;W��TMP1��1�r�b�g���炵�����̂��Ԃ�����
		MOVWF	TMP1			;W����TMP�P�ɖ߂�
		BCF		STATUS,	C		;�N���A
		RRF		TMP1,	W		;Rotate Right TMP1 with C->M
		MOVWF	TMP1
		BCF		STATUS,	C
		RRF		TMP1,	W		;Rotate Right TMP1 with C->M
		MOVWF	TMP1
		BCF		STATUS, C
		RRF		TMP1,	W		;Rotate Right TMP1 with C->M

		ANDWF	TMP0,	W		;TMP0��W��AND���Ă�W

		MOVWF	PORTA
		GOTO 	LOOP
		
		END