; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0		rjmp	_main	 ; skok do programu g³ównego
.org OC1Aaddr	rjmp _timer_isr

; ### INTERRUPT SEERVICE ROUTINES ###
_timer_isr:
		nop
		reti

; ### MAIN PROGAM ###
_main: 
		ldi R16, (1 << WGM12) | (1 << CS10)		; prescaler 1 & ctc mode
		out TCCR1B, R16
	
		.equ CyclesNumbers = 99

		ldi R16,high(CyclesNumbers) 
		out OCR1AH,R16

		ldi R16,low(CyclesNumbers) 
		out OCR1AL,R16 

		ldi R16, (1 << OCIE1A)					; interrupt on A Match
		out TIMSK,R16 

		ldi R16, 0
		out TCNT1L, R16
		out TCNT1H, R16

        sei

ThreadA:   
		nop
		nop
		nop
		nop
		nop
			rjmp ThreadA