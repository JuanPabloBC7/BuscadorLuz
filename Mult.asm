multiplicando equ 0x24
multiplicador equ 0x25
resultmult    equ 0x26
tmp1	      equ 0x27

START
	MOVLW	d'3'
	MOVWF	multiplicando

	MOVLW	d'4'
	MOVWF	multiplicador	

	MOVF multiplicando, w
	MOVWF tmp1

	MOVLW 0
	MOVWF resultmult
Inicio
	CALL IniciaMult
Infinito
	GOTO Infinito



IniciaMult
	MOVF	multiplicador, W
	ADDWF	resultmult, 1
	DECFSZ	tmp1, 1
	GOTO IniciaMult
	RETURN