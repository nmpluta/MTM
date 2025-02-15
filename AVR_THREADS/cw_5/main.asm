; Cw_5

; ### MACRO ###
.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro

.macro TOGGLE_DIGIT
in R16, Digits_P
ldi R17, 0x10>>@0
eor R16, R17
out Digits_P, R16
.endmacro

.macro SET_PORT_B
push R16
ldi R16, 0b11000		; pins: 3, 4 of port B
//ldi R16, 0x02
out DDRB, R16
pop R16
.endmacro

.macro SET_PORT_D
push R16
ldi R16, 0b1111111		; 7 pins of port D
//ldi R16, 0xFF
out DDRD, R16
pop R16
.endmacro

/*** Display ***/
.equ Digits_P = PORTB
.equ Segments_P = PORTD
.equ QuarterPeriodA = 25			// 25ms * 4 = 100ms - okres
.equ QuarterPeriodB = 100			// 100ms * 4 = 400 ms

; ### GLOBAL VARIABLES ###
.def CtrA = R17
.def CtrB = R18 
.def CurrentThread = R19
.def ThreadA_LSB = R20
.def ThreadA_MSB = R21
.def ThreadB_LSB = R22
.def ThreadB_MSB = R23
.def ThreadA_SREG = R0
.def ThreadB_SREG = R1 

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pami�ci kodu programu 

.org	 0		rjmp	_main	 ; skok do programu g��wnego
.org OC1Aaddr	rjmp _timer_isr

; ### INTERRUPT SEERVICE ROUTINES ###
_timer_isr:
		in R2, SREG
		
		inc CurrentThread
		andi CurrentThread, 1
		cpi CurrentThread, 1 
		breq _thread_B

_thread_A:
		pop ThreadB_MSB
		pop ThreadB_LSB
		push ThreadA_LSB
		push ThreadA_MSB
		mov ThreadB_SREG, R2
		out SREG, ThreadA_SREG
		reti

_thread_B:
		pop ThreadA_MSB
		pop ThreadA_LSB
		push ThreadB_LSB
		push ThreadB_MSB
		mov ThreadA_SREG, R2
		out SREG, ThreadB_SREG
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

		// Ports
		SET_PORT_B
		SET_PORT_D

		// 0x07 - '7'
		ldi R16, 0x07
        out Segments_P, R16
		clr R16

		// global interrupts
        sei

ThreadA:   
		cli
		inc CtrA
		TOGGLE_DIGIT 0
		sei

		LOAD_CONST R25, R24, QuarterPeriodA
		// *** DelayInMs ***
		// In: R24 - LSB, R25 - MSB 
		DelayInMsA:        
				LOAD_CONST R27, R26, 2000         
		OneMsLoopA: 		
				sbiw  R27:R26, 1 
				brne  OneMsLoopA

				sbiw  R25:R24, 1
				brne  DelayInMsA
		rjmp ThreadA

ThreadB:
		cli   
		inc CtrB
		TOGGLE_DIGIT 1
		sei
		
		LOAD_CONST R29, R28, QuarterPeriodB
		// *** DelayInMs ***
		// In: R28 - LSB, R29 - MSB 
		DelayInMsB:        
				LOAD_CONST R31, R30, 2000         
		OneMsLoopB: 		
				sbiw  R31:R30,1 
				brne  OneMsLoopB

				sbiw  R29:R28, 1
				brne  DelayInMsB
		rjmp ThreadB
		ret


