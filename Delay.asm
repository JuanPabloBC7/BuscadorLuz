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
