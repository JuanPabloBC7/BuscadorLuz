;;; 160 PASOS EN X
DATO	EQU 0X21
d1   	EQU 0X22
d2	EQU 0X23
d3	EQU 0X24
d4	EQU 0x25
d5	EQU 0X26
d6	EQU 0X27
d7	EQU 0X28
d8	EQU 0x29
d9	EQU 0X2A
x	EQU 0x2B
y	EQU 0x2C
x_f	EQU 0x2D
y_f	EQU 0X2E
cond_x	EQU 0x30
cond_y	EQU 0x31
d10	EQU 0x32
d11	EQU 0x33
luzAct	EQU 0x34

INICIO
	ORG	0X00


	BSF	STATUS, 5 ; Colocamos en 1 el bit 5 de reg. estatus 
; en el banco 1 tenemos trisa, trisb, ... , trisd
; debemos configurar puerto de entrada y salida..
; puerto b
	CLRF	TRISB		; CLEAR FILE CONFIGURA EL PUERTO B PARA QUE SEA SALIDA (0 = SALIDA)
	;BSF TRISC, 7		; PUERTO C -> ENTRADA
	CLRF 	TRISD		; PUERTO D -> SALIDA
	CLRF 	TRISC		; PUERTO C -> SALIDA


	BCF	STATUS, RP0		;BITCLEAR FILE DE RP0 = BIT CLEARFY 5
	
	movlw 0x00;
	movwf	portb;
	movlw 0x00;
	movwf portd;



START
	movlw	d'14'
	movwf	x_f
	movlw	d'50'
	movwf	y_f
	
	movlw	d'3'
	movwf	luzact
	
	movlw   d'0'
	movwf	x
	movlw	d'0'
	movwf	y
	CALL MOSTRARDISPLAY

HOLA
	GOTO HOLA


	CALL Buscar_X
	CALL Buscar_Y

	CALL MovimientoDelanteCompleto
	CALL MovimientoDetrazCompleto

END
	


REC_FINAL
	CALL Buscar_X
	CALL Buscar_Y
	RETURN
	
;;;;;
BUSCAR_X
	CALL MOVIMIENTOADELANTE
	INCF x, 1
	movf x_f, W
	movwf d11
INICIOBUSCAx
	decfsz d11, 1
	GOTO b13
	RETURN
B13
	CALL MOVIMIENTOADELANTE		; 10 PASOADELANTE
	INCF x, 1	
	GOTO INICIOBUSCAx
;;;;
;;;;;
BUSCAR_Y
	CALL PASOBDELANTE
	CALL PASOBDELANTE
	INCF Y, 1
	movf y_f, W
	movwf d10
INICIOBUSCAy
	decfsz d10, 1
	GOTO B14
	RETURN
B14
	CALL PASOBDELANTE
	CALL PASOBDELANTE
	INCF Y, 1
	GOTO INICIOBUSCAy
;;;;



PASOADELANTE
	CALL PASO1A
	CALL DELAY
	CALL PASO2A
	CALL DELAY
	CALL PASO3A
	CALL DELAY
	CALL PASO4A
	CALL DELAY
	RETURN	
PASOAREVEZ
	CALL PASO4A
	CALL DELAY
	CALL PASO3A
	CALL DELAY
	CALL PASO2A
	CALL DELAY
	CALL PASO1A
	CALL DELAY
	RETURN	

PASOBDELANTE
	CALL PASO1B
	CALL DELAY
	CALL PASO2B
	CALL DELAY
	CALL PASO3B
	CALL DELAY
	CALL PASO4B
	RETURN

PASOBREVEZ
	CALL PASO4B
	CALL DELAY
	CALL PASO3B
	CALL DELAY
	CALL PASO2B
	CALL DELAY
	CALL PASO1B
	RETURN

	
PASO1A
	MOVLW	B'00001100' 	; EN W SE ENCUENTRA 0001100
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	CALL DISPLAYA
	RETURN
PASO2A
	MOVLW	B'00000110' ; EN W SE ENCUENTRA 0001100
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	CALL DISPLAYA
	RETURN
PASO3A
	MOVLW	B'00000011' ; EN W SE ENCUENTRA 0001100
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	CALL DISPLAYA
	RETURN
PASO4A
	MOVLW	B'00001001' ; EN W SE ENCUENTRA 0001100
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	CALL DISPLAYA
	RETURN

PASO1B
	MOVLW	B'00001100' ; EN W SE ENCUENTRA 0001100
 	MOVWF	DATO		; DE W A F LE MOVEMOS F
	CALL DISPLAYB
	RETURN
PASO2B
	MOVLW	B'00000110' ; EN W SE ENCUENTRA 0001100
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	CALL DISPLAYB
	RETURN
PASO3B
	MOVLW	B'00000011' ; EN W SE ENCUENTRA 0001100
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	CALL DISPLAYB
	RETURN
PASO4B
	MOVLW	B'00001001' ; EN W SE ENCUENTRA 0001100
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	CALL DISPLAYB
	RETURN



DISPLAYA
	MOVF	DATO, W
	MOVWF	PORTB	
	RETURN

DISPLAYB
	; Se limpia mitad de puertos inservibles
	BCF PORTB, 4
	BCF PORTB, 5
	BCF PORTB, 6
	BCF PORTB, 7

	
	; Shift para colocar en parte m�s significativa
	RLF DATO, 1
	RLF DATO, 1
	RLF DATO, 1
	RLF DATO, 1

	MOVF	DATO, W
	IORWF	PORTB, 1 ; OR ENTRE DATO Y PUERTOB
	RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVIMIENTOBDELANTE
	movlw d'10'
	movwf d5
INICIOMOVIMIENTOB1
	decfsz d5, 1
	GOTO B1
	RETURN
B1
	CALL PASOBDELANTE 	; 32 PASOS
	CALL PASOBDELANTE
	INCF y, 1
	GOTO INICIOMOVIMIENTOB1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVIMIENTOBDETRAZ
	movlw d'5'
	movwf d6
INICIOMOVIMIENTOB2
	decfsz d6, 1
	GOTO B2
	RETURN
B2
	CALL PASOBREVEZ	; 32 PASOS
	CALL PASOBREVEZ
	DECF y, 1
	GOTO INICIOMOVIMIENTOB2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVIMIENTOADELANTE
	movlw d'5'
	movwf d7
INICIOMOVIMIENTOA1
	decfsz d7, 1
	GOTO A1
	RETURN
A1
	CALL PASOADELANTE	; 32 PASOS
	CALL PASOADELANTE
	GOTO INICIOMOVIMIENTOA1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MovimientoDelanteCompleto
	movlw d'17'
	movwf d8
INICIOMOVIMIENTOC1
	decfsz d8, 1
	GOTO C1
	RETURN
C1
	CALL MOVIMIENTOADELANTE		; 10 PASOADELANTE
	INCF x, 1	
	CALL MOVIMIENTOBDELANTE
	CALL MOVIMIENTOADELANTE		; 10 PASOADELANTE
	INCF x, 1
	CALL MOVIMIENTOBDETRAZ
	GOTO INICIOMOVIMIENTOC1

MovimientoDetrazCompleto
	movlw d'255'
	movwf d9
INICIOMOVIMIENTOD1
	decfsz d9, 1
	GOTO MOVD1
	MOVLW	B'0' 	; EN W SE ENCUENTRA 0
	MOVWF	x	; Movemos a x, w -> x = 0 (reseteamos x)


	RETURN
MOVD1
	CALL PASOAREVEZ			
	GOTO INICIOMOVIMIENTOD1		


	
Delay
			;1693 cycles
	movlw	0x52
	movwf	d1
	movlw	0x02
	movwf	d2
Delay_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	Delay_0

			;3 cycles
	goto	$+1
	nop

			;4 cycles (including call)
	return
; Generated by http://w

;;;;;;; ;;;;MOSTRAR DISPLAY ;;;;;;;;;
MOSTRARDISPLAY	
	BTFSS luzAct, 0		; SALTA L�NEA SI PRIMER BIT ES 1
	GOTO BITXXX0		; SI PRIMER BIT ES 0
	GOTO BITXXX1		; SI PRIMER BIT ES 1	
	
; PRIMER BIT ES 0
BITXXX0
	BTFSS luzAct, 1	; SALTA L�NEA SI SEGUNDO BIT ES 1
	GOTO BITXX00		; 00
	GOTO BITXX10		; 10
; PRIMER BIT ES 1
BITXXX1
	BTFSS luzAct, 1	; SALTA SI SEGUNDO BIT ES 1
	GOTO BITXX01		; 01
	GOTO BITXX11		; 11
;00
BITXX00
	BTFSS luzAct, 2	; SALTA L�NEA SI TERCER BIT ES 1
	GOTO BITX000		; 000
	GOTO BITX100		; 100		-> 4	0110011
;10
BITXX10
	BTFSS luzAct, 2	; SALTA L�NEA SI TERCER BIT ES 1
	GOTO BITX010		; 010		-> 2	1101101
	GOTO BITX110		; 110		-> 6	1011111
	
;01
BITXX01
	BTFSS luzAct, 2	; SALTA L�NEA SI TERCER BIT ES 1
	GOTO BITX001		; 001		
	GOTO BITX101		; 101		-> 5	1011011
	
;11
BITXX11
	BTFSS luzAct, 2	; SALTA L�NEA SI TERCER BIT ES 1
	GOTO BITX011		; 011		-> 3	1111001
	GOTO BITX111		; 111		-> 7	1110000
		
;000
BITX000
	BTFSS	luzAct, 3	; SALTA L�NEA SI CUARTO BIT ES 1
	GOTO BIT0000	; 0000		-> 0		1111110
	GOTO BIT1000	; 1000		-> 8		1111111
	
;001
BITX001
	BTFSS luzAct, 3	; SALTA L�NEA SI CUARTO BIT ES 1
	GOTO BIT0001	; 0001		-> 1		0110000
	GOTO BIT1001	; 1001		-> 9		0001100
	
	
; #0
BIT0000
	MOVLW	B'10000001' ; EN W SE ENCUENTRA 1111110
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	
; #1
BIT0001
	MOVLW	B'11100111' ; EN W SE ENCUENTRA 0110000
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	
; #2
BITX010
	MOVLW	B'01001001' ; EN W SE ENCUENTRA 1101101
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	
; #3
BITX011
	MOVLW	B'01000011'
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	
; #4
BITX100
	MOVLW	B'00100111'
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	RETURN
; #5
BITX101
	MOVLW	B'00010011'
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	RETURN
; #6
BITX110
	MOVLW	B'00010001'
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	
; #7
BITX111
	MOVLW	B'11000111'
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	RETURN
; #8
BIT1000
	MOVLW	B'00000001' ; EN W SE ENCUENTRA 1111111
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	RETURN
; #9
BIT1001
	MOVLW	B'00000011' ; EN W SE ENCUENTRA 0001100
	MOVWF	DATO		; DE W A F LE MOVEMOS F
	GOTO DISPLAY
	

DISPLAY
	MOVF	DATO, W
	MOVWF	PORTC	
	RETURN
;;;;;;; FINALIZA MOSTRAR DISPLAY ;;;;;;;;;