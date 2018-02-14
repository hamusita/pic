		LIST	P=PIC16F84A
		INCLUDE "P16F84A.INC"
		
		__CONFIG _HS_OSC
		
TMP0	EQU 0CH
TMP1	EQU 0DH

		ORG 0H
MAIN
		BSF		STATUS, RP0		;Bank 1 初期設定開始
		CLRF	TRISA			;PortA->Output
		MOVLW	0FFH			;11111111->W	Wレジスタに0FFH(8進数)をぶち込む
		MOVWF 	TRISB			;PortB->Input
		BCF		STATUS, RP0		;Bank 0 設定終了
		CLRF	PORTA			;All RA->Low	RAをオールクリア
LOOP
		MOVF	PORTB, W		;ポートBをWレジスタにぶち込む
		ANDLW	B'00001111'		;RB(A)とWをANDしてWにぶち込む
		MOVWF	TMP0			;WをTMP0へ

		MOVF	PORTB, W		;ポートBをWレジスタにぶち込む
		ANDLW	B'11110000'		;RB(B)をWへ
		MOVWF	TMP1			;WをTMP1へ

		BCF		STATUS, C		;クリア
		RRF		TMP1,	W		;WにTMP1を1ビットずらしたものをぶち込む
		MOVWF	TMP1			;WからTMP１に戻す
		BCF		STATUS,	C		;クリア
		RRF		TMP1,	W		;Rotate Right TMP1 with C->M
		MOVWF	TMP1
		BCF		STATUS,	C
		RRF		TMP1,	W		;Rotate Right TMP1 with C->M
		MOVWF	TMP1
		BCF		STATUS, C
		RRF		TMP1,	W		;Rotate Right TMP1 with C->M

		ANDWF	TMP0,	W		;TMP0とWをANDしてへW

		MOVWF	PORTA
		GOTO 	LOOP
		
		END