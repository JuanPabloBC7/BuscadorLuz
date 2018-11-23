var2shift	equ	0x29
d1		equ	0x30
d2		equ	0x31


START
	BSF	STATUS, RP0
	BCF	STATUS, RP1

	CLRF	TRISB

	BCF	STATUS, RP0

	MOVLW	b'0000001'
	MOVWF	var2shift
Inicio
	CALL Shift
	CALL Delay1
	GOTO Inicio

Shift
	RLF var2shift, 1
	MOVF var2shift, W
	MOVWF PORTB
	RETURN


Delay1
	CALL delay
	CALL delay
	RETURN


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
