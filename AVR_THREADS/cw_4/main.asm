; Cw_4

; ### GLOBAL VARIABLES ###
.def CurrentThread = R19
.def ThreadA_LSB = R20
.def ThreadA_MSB = R21
.def ThreadB_LSB = R22
.def ThreadB_MSB = R23
.def CtrA = R24
.def CtrB = R25 

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0		rjmp	_main	 ; skok do programu g³ównego
.org OC1Aaddr	rjmp _timer_isr

; ### INTERRUPT SEERVICE ROUTINES ###
_timer_isr:
		inc CurrentThread
		andi CurrentThread, 1
		cpi CurrentThread, 1 
		breq _thread_change

		pop ThreadB_MSB
		pop ThreadB_LSB
		push ThreadA_LSB
		push ThreadA_MSB
		reti

_thread_change:
		pop ThreadA_MSB
		pop ThreadA_LSB
		push ThreadB_LSB
		push ThreadB_MSB
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

		clr CurrentThread

		ldi ThreadA_MSB, high(ThreadA)
		ldi ThreadA_LSB, low(ThreadA)
		ldi ThreadB_MSB, high(ThreadB)
		ldi ThreadB_LSB, low(ThreadB)

        sei

ThreadA:   
		inc CtrA
			rjmp ThreadA

ThreadB:   
		inc CtrB
			rjmp ThreadB
		reti