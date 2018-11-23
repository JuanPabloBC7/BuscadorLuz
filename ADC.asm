ans equ 0x21


START
	BCF 	STATUS, RP0		; Banco
	BCF 	STATUS, RP1		; 0

	MOVLW 	b'11000001'	; 11 Frecuencia del reloj
				; 000 Primer canal de entrada
				; 0 Aún no empieza
				; 0 -
				; 1 Se encinde el módulo
	MOVWF 	ADCON0

	BSF 	STATUS, RP0		; Banco 1
	MOVLW 	b'00001110'
	MOVWF 	ADCON1

	BSF	TRISA, 0

	BCF	STATUS,	RP0
	BCF	STATUS,	RP1

Inicio
	CALL 	Convertir
	GOTO 	Inicio

Convertir
	BCF 	STATUS, RP0
	BCF 	STATUS, RP1
	
	BSF 	ADCON0, GO		; Inicia conversión
Espera
	BTFSC 	ADCON0, GO
	GOTO 	Espera
	

	MOVF 	ADRESH, W
	MOVWF 	ans

	BSF 	STATUS, RP0
	RETURN