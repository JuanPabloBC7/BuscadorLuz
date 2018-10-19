luz1024		equ	0x22
categoria 	equ	0x23


INICIO
	ORG 0x00
	GOTO START

START
	BSF	STATUS,5 ; PONE UN 1 EN STATUS BIT 5, PARA MOVERNOS AL BANCO 1 
	CLRF	TRISD ; PONE EN 0 TRISB Y LA BANDERA Z
	MOVLW	B'00001111' ; PONEMOS EN BINARIO LAS ENTRADAS QUE QUEREMOS HABILITAR PIN 0 AL 3 ENTRADA DE DIGITOS Y PIN 5 MOSTRAR DIGITO
	MOVWF	TRISC ;MUEVE LO QUE TENGAMOS EN W HACIA TRISC PARA HABILITAR LAS ENTRADAS
	CLRW	;LIMPIAR W
	BCF	STATUS, 5 ; PONE UN 0 EN STATUS EN BIT 5 Y ESTO NOS MUEVE AL BANCO 0	
	


	
	movlw	d'3'
	movwf 	luz1024	

	call GetCategoria
hola
	goto hola
GetCategoria
	movlw	d'0'
	movwf	categoria

	movlw	d'210'
	subwf	luz1024, 0
	BTFSc	STATUS, C
	RETURN	
	incf	categoria,1
	movlw	d'194'
	subwf	luz1024, 0
	BTFSC STATUS, C
	return
	incf	categoria,1
	movlw	d'174'
	subwf	luz1024, 0
	BTFSC STATUS, C
	return
	incf	categoria,1
	movlw	d'158'
	subwf	luz1024, 0
	BTFSC STATUS, C
	return
	incf	categoria,1
	movlw	d'138'
	subwf	luz1024, 0
	BTFSC STATUS, C
	return
	incf	categoria,1
	movlw	d'117'
	subwf	luz1024, 0
	BTFSC STATUS, C
	return
	incf	categoria,1
	movlw	d'82'
	subwf	luz1024, 0
	BTFSC STATUS, C
	return
	incf	categoria,1
	movlw	d'51'
	subwf	luz1024, 0
	BTFSC STATUS, C
	return
	incf	categoria,1
	movlw	d'28'
	subwf	luz1024, 0
	BTFSC STATUS, C
	return
	incf	categoria, 1
	return
	





