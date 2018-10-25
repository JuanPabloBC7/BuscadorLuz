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
inciso	EQU 0x35

dato1	EQU 0x36
dato2	EQU 0x37
dato3	EQU 0X38
dato4	EQU 0x39

categoria	EQU	0x3A
luz512		EQU	0x3B

var2show EQU 0x3C

;; Variables FotoResistencia
ADC	EQU	0x3D
CON	EQU	0X3F
CON2	EQU	0X40
CON3	EQU	0X41

luzmax	EQU	0x42
luzmin	EQU	0X43

ndispositivo EQU 0x44
;; variables 

INICIO
	ORG	0X00

	bcf STATUS,RP0 ;Ir banco 0
	bcf STATUS,RP1
	movlw b'01000001' ;A/D conversion Fosc/8
	movwf ADCON0
	;     	     7     6     5    4    3    2       1 0
	; 1Fh ADCON0 ADCS1 ADCS0 CHS2 CHS1 CHS0 GO/DONE ? ADON
	bsf STATUS,RP0 ;Ir banco 1
	bcf STATUS,RP1
	movlw b'00000111'
	movwf OPTION_REG ;TMR0 preescaler, 1:156

	;                7    6      5    4    3   2   1   0 
	; 81h OPTION_REG RBPU INTEDG T0CS T0SE PSA PS2 PS1 PS0
	movlw b'00001110' ;A/D Port AN0/RA0
	movwf ADCON1
	;            7    6     5 4 3     2     1     0 
	; 9Fh ADCON1 ADFM ADCS2 ? ? PCFG3 PCFG2 PCFG1 PCFG0
	bsf TRISA,0 ;RA0 linea de entrada para el ADC
	;clrf TRISB
	bcf STATUS,RP0 ;Ir banco 0
	bcf STATUS,RP1




	BSF	STATUS, 5 ; Colocamos en 1 el bit 5 de reg. estatus 
; en el banco 1 tenemos trisa, trisb, ... , trisd
; debemos configurar puerto de entrada y salida..
; puerto b
	CLRF	TRISB		; CLEAR FILE CONFIGURA EL PUERTO B PARA QUE SEA SALIDA (0 = SALIDA)
	;BSF TRISA, 7		; PUERTO A -> ENTRADA
	CLRF 	TRISC		; PUERTO C -> SALIDA
	BSF TRISD, 7
	
	BCF	STATUS, RP0		;BITCLEAR FILE DE RP0 = BIT CLEARFY 5
	
	movlw 0x00;
	movwf	portb;
	movlw 0x00;
	movwf portd;



START
	; Declaramos variables
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
	
	movlw	d'1'
	movwf	inciso

	; primer inciso
	movlw	d'1'
	movwf	dato1

	movlw	d'2'
	movwf	dato2

	movlw	d'3'
	movwf	dato3

	movlw	d'4'
	movwf	dato4
	
	MOVLW	d'0'
	movwf	luzmax

	movlw	d'19'
	movwf	luzmin

		
	movlw d'8'
	movwf	ndispositivo

	CALL MovimientoDelanteCompleto
	
	
	CALL Buscar_X
	CALL Buscar_Y
	
infinite
	CALL MENUBTN
	goto infinite

END
MENUBTN
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	CALL delay
	BTFSS PORTD, 1	; VERIFICA SI BOTÓN ESTÁ PRESIONADO
	GOTO MENUBTN		; SI NO ESTÁ PRESIONADO
	
	BTFSC inciso, 0 ; SALTA SI EL PRIMER BIT ESTÁ APAGADO
	GOTO inciso1	; PRIMER BIT ENCENDIDO
	BTFSC inciso, 1	; SALTA SI EL SEGUNDO BIT ESTÁ APAGADO
	GOTO inciso2	; SEGUNDO BIT ENCENDIDO
	BTFSC inciso, 2	; SALTA SI EL TERCER BIT ESTÁ APAGADO
	GOTO inciso3	; TERCER BIT ENCENDIDO
	BTFSC inciso, 3	; SALTA SI EL CUARTO BIT ESTÁ APAGADO
	GOTO inciso4	; CUARTO BIT ENCENDIDO
		
	RETURN


	

	
	
	

inciso1
	
	movlw	b'10'
	movwf	inciso
	
	CALL AsignarLuz512
	CALL getCategoria
	movf categoria, w
	movwf	var2show
	call mostrardisplay	
	RETURN		; SI NO ESTÁ PRESIONADO
inciso2

	movlw	b'100'
	movwf	inciso
	movf luzmax, w
	movwf var2show
	CALL MOSTRARDISPLAY
	RETURN
inciso3
	
	movlw	b'1000'
	movwf	inciso
	movf luzmin, w
	movwf var2show
	CALL MOSTRARDISPLAY
	RETURN
inciso4
	
	movlw b'1'
	movwf	inciso
	movf ndispositivo, w
	movwf var2show
	CALL MOSTRARDISPLAY
	RETURN


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

	
	; Shift para colocar en parte más significativa
	RLF DATO, 1
	RLF DATO, 1
	RLF DATO, 1
	RLF DATO, 1

	MOVF	DATO, W
	IORWF	PORTB, 1 ; OR ENTRE DATO Y PUERTOB
	RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVIMIENTOBDELANTE
	movlw d'80'			;160 (150)
	movwf d5	
INICIOMOVIMIENTOB1
	decfsz d5, 1
	GOTO B1
	RETURN
B1
	CALL PASOBDELANTE 	; 32 PASOS
	CALL PASOBDELANTE
	INCF y, 1
	CALL ASSMAXMIN_P	
	GOTO INICIOMOVIMIENTOB1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVIMIENTOBDETRAZ
	movlw d'80'			; 160 (170)
	movwf d6
INICIOMOVIMIENTOB2
	decfsz d6, 1
	GOTO B2
	RETURN
B2
	CALL PASOBREVEZ	; 32 PASOS
	CALL PASOBREVEZ
	CALL ASSMAXMIN_P	
	DECF y, 1
	GOTO INICIOMOVIMIENTOB2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVIMIENTOADELANTE
	movlw d'17'
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
	movlw d'9'			; 8 es el correc
	movwf d8
INICIOMOVIMIENTOC1
	decfsz d8, 1
	GOTO C1
	RETURN
C1
	CALL MOVIMIENTOADELANTE		; 10 PASOADELANTE
	INCF x, 1
	CALL ASSMAXMIN_P	
	CALL MOVIMIENTOBDELANTE
	CALL MOVIMIENTOADELANTE		; 10 PASOADELANTE
	INCF x, 1
	CALL ASSMAXMIN_P	
	CALL MOVIMIENTOBDETRAZ
	GOTO INICIOMOVIMIENTOC1

MovimientoDetrazCompleto
	movlw d'255'			; 255 es el correcto
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
	BTFSS var2show, 0		; SALTA LÍNEA SI PRIMER BIT ES 1
	GOTO BITXXX0		; SI PRIMER BIT ES 0
	GOTO BITXXX1		; SI PRIMER BIT ES 1	
	
; PRIMER BIT ES 0
BITXXX0
	BTFSS var2show, 1	; SALTA LÍNEA SI SEGUNDO BIT ES 1
	GOTO BITXX00		; 00
	GOTO BITXX10		; 10
; PRIMER BIT ES 1
BITXXX1
	BTFSS var2show, 1	; SALTA SI SEGUNDO BIT ES 1
	GOTO BITXX01		; 01
	GOTO BITXX11		; 11
;00
BITXX00
	BTFSS var2show, 2	; SALTA LÍNEA SI TERCER BIT ES 1
	GOTO BITX000		; 000
	GOTO BITX100		; 100		-> 4	0110011
;10
BITXX10
	BTFSS var2show, 2	; SALTA LÍNEA SI TERCER BIT ES 1
	GOTO BITX010		; 010		-> 2	1101101
	GOTO BITX110		; 110		-> 6	1011111
	
;01
BITXX01
	BTFSS var2show, 2	; SALTA LÍNEA SI TERCER BIT ES 1
	GOTO BITX001		; 001		
	GOTO BITX101		; 101		-> 5	1011011
	
;11
BITXX11
	BTFSS var2show, 2	; SALTA LÍNEA SI TERCER BIT ES 1
	GOTO BITX011		; 011		-> 3	1111001
	GOTO BITX111		; 111		-> 7	1110000
		
;000
BITX000
	BTFSS	var2show, 3	; SALTA LÍNEA SI CUARTO BIT ES 1
	GOTO BIT0000	; 0000		-> 0		1111110
	GOTO BIT1000	; 1000		-> 8		1111111
	
;001
BITX001
	BTFSS var2show, 3	; SALTA LÍNEA SI CUARTO BIT ES 1
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
;;;;;;; INICIA METODO PARA CATEGORIZAR;;;;
GetCategoria
	movlw	d'9'
	movwf	categoria

	movlw	d'210'
	subwf	luz512, 0
	BTFSc	STATUS, C
	RETURN	
	decf	categoria,1
	movlw	d'194'
	subwf	luz512, 0
	BTFSC STATUS, C
	return
	decf	categoria,1
	movlw	d'174'
	subwf	luz512, 0
	BTFSC STATUS, C
	return
	decf	categoria,1
	movlw	d'158'
	subwf	luz512, 0
	BTFSC STATUS, C
	return
	decf	categoria,1
	movlw	d'138'
	subwf	luz512, 0
	BTFSC STATUS, C
	return
	decf	categoria,1
	movlw	d'117'
	subwf	luz512, 0
	BTFSC STATUS, C
	return
	decf	categoria,1
	movlw	d'82'
	subwf	luz512, 0
	BTFSC STATUS, C
	return
	decf	categoria,1
	movlw	d'51'
	subwf	luz512, 0
	BTFSC STATUS, C
	return
	decf	categoria,1
	movlw	d'28'
	subwf	luz512, 0
	BTFSC STATUS, C
	return
	decf	categoria, 1
	return
;;;;;;;;;; FINALIZA METODO PARA CATEGORIZAR ;;;;;;;;;;
;;;;;;;;;; FINALIZA LECTURA DE FOTORESISTOR ;;;;;;;;;;

AsignarLuz512

_bucle
	;btfss INTCON,T0IF
	;goto _bucle ;Esperar que el timer0 desborde
	; SE DEBE DE COLOCAR UN DELAY PARA QUE ESPERE LA CONVERSION
	BSF  STATUS,Z
	CALL _PRESPERA
	bcf INTCON,T0IF ;Limpiar el indicador de desborde
	bsf ADCON0,GO ;Comenzar conversion A/D
_espera
	btfsc ADCON0,GO ;ADCON0 es 0? (la conversion esta completa?)
	goto _espera ;No, ir _espera
	movf ADRESH,W ;Si, W=ADRESH
	; 1Eh ADRESH A/D Result Register High Byte
	; 9Eh ADRESL A/D Result Register Low Byte 
	movwf ADC ;ADC=W
	;rrf ADC,F ;ADC /4
	;rrf ADC,F
	;bcf ADC,7
	;bcf ADC,6
	movfw ADC ;W = ADC
	movwf luz512 ;luz512 = W
	call getCategoria
	return
	movlw D'32' ;Comparamos el valor del ADC para saber si es menor que 128
	subwf ADC,W
	;btfss STATUS,C ;Es mayor a 128?
	goto _desactivar ;No, desactivar RB7
	bsf PORTC,7 ;Si, RB7 = 1 logico
	goto _bucle ;Ir bucle
_desactivar
	bcf luz512,7 ;RB7 = 0 logico
	goto _bucle ;Ir bucle
	
_PRESPERA
	MOVLW 0XFF
	MOVWF CON
	MOVWF CON2
	MOVWF CON3	
	CALL ESPE
	RETURN	
	
ESPE
	DECFSZ	CON,0X01
	GOTO	ESPE
	CALL	ESPE2
	RETURN
ESPE2
	DECFSZ	CON2,0X01
	GOTO	ESPE2
	CALL	ESPE3
	RETURN
ESPE3
	DECFSZ	CON3,0X01
	GOTO	ESPE3
	RETURN		
;;;;;;;;;; FINALIZA LECTURA DE FOTORESISTOR ;;;;;;;;;;
;;;;;;;;;; COMPARACION PROPIA DE LUZ 	    ;;;;;;;;;;
ASSMAXMIN_P	
	CALL AsignarLuz512			;quitar comentario
	CALL getCategoria
	movf categoria, w
	movwf	var2show
	call mostrardisplay


	MOVF	categoria,W
	SUBWF	luzmin,W	
	BTFSC	STATUS,C
	CALL	EntradaMenor

	MOVF	categoria,W
	SUBWF	luzmax,W
	BTFSS	STATUS,C
	CALL 	EntradaMayor
	return
EntradaMayor
	MOVF	categoria,W
	MOVWF	luzmax
	movf	x,	w
	movwf	x_f
	movf	y,	w
	movwf	y_f
	RETURN

EntradaMenor
	MOVF	categoria,W
	MOVWF	luzmin
	RETURN
;;;;;;;;; COMPARACION AJENA DE LUZ	     ;;;;;;;;;;