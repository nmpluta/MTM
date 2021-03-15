 ;### MACROS & defs (.equ)###

.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro

/*** Display ***/
.equ Digits_P = PORTB
.equ Segments_P = PORTD
.equ QuarterPeriod = 5			// 5ms * 4 = 20ms - okres

.macro SET_DIGIT		; argument nr wyswietlacza
push R16
ldi R16, 0x10>>@0
out Digits_P, R16			; OUT A,Rr - Store Register to I/O Location: I/O(A) <- Rr
mov R16, Digit_@0
rcall DigitTo7segCode		; RCALL k - return address (the instruction after the RCALL) is stored onto the Stack
out Segments_P, R16			; load to Segments_P return value from DigitTo7segCode subrutine
push R17					
LOAD_CONST R17, R16, QuarterPeriod
rcall DelayInMs
pop R17
pop R16
.endmacro

.macro SET_PORT_B
push R16
ldi R16, 0b11110		; pins: 1,2,3,4 of port B
out DDRB, R16			; DDR (Data Direction Register) of port B
pop R16
.endmacro

.macro SET_PORT_D
push R16
ldi R16, 0b1111111		; 7 pins of port D
out DDRD, R16			; DDR (Data Direction Register) of port D
pop R16
.endmacro

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL = R0
.def PulseEdgeCtrH = R1

.def Digit_0 = R2
.def Digit_1 = R3
.def Digit_2 = R4
.def Digit_3 = R5

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0		rjmp	_main	 ; skok do programu g³ównego
.org OC1Aaddr	rjmp _timer_isr
.org PCIBaddr   rjmp _ExtPB0_ISR ; skok do procedury obs³ugi przerwania zenetrznego 

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtPB0_ISR: 	 ; procedura obs³ugi przerwania zewnetrznego

        push R16
	    in R16,SREG
	    push R16
 
		ldi R16,1
		add PulseEdgeCtrL,R16				; ADD Rd,Rr – Add without Carry: Rd <- Rd + Rr
		clr R16														
		adc PulseEdgeCtrH,R16				; ADC Rd,Rr – Add with Carry: Rd <- Rd + Rr + C
       
	    pop R16
	    out SREG,R16
        pop R16

		reti	; powrót z procedury obs³ugi przerwania (reti zamiast ret) - ustawia bit na fladze I       
				; RETI – Return from Interrupt - Returns from interrupt. The return address is loaded from the STACK and the Global Interrupt Flag is set.

_timer_isr:
        push R16
        push R17
        push R18
        push R19
		in R16,SREG							; IN Rd,A - Load an I/O Location to Register: Rd <- I/O(A)
	    push R16

		mov R16,PulseEdgeCtrL				; MOV Rd,Rr – Copy Register: Rd <- Rr
		mov R17,PulseEdgeCtrH				
		ror R17								; ROR Rd – Rotate Right through Carry
		ror R16								; Shifts all bits in Rd one place to the right. The C Flag is shifted into bit 7 of Rd. Bit 0 is shifted into the C Flag.
		rcall NumberToDigits
		mov Digit_0,R16 
		mov Digit_1,R17 
		mov Digit_2,R18 
		mov Digit_3,R19 

		clr PulseEdgeCtrL
		clr PulseEdgeCtrH

		pop R16
	    out SREG,R16
		pop R19
        pop R18
        pop R17
        pop R16

		reti

; ### MAIN PROGAM ###

_main: 

            // *** Ext. ints ***



			; *** Timer1 ***
			.equ Period=31250

	ldi R16, 12									; 0b1100 : bit3 - WGM12 - CTC (Clear Timer on Compare Mode), bit2 - CS12 - clkI/O/256 (From prescaler)
	out TCCR1B, R16								; Timer/Counter 1 Control Register B

			ldi R16,high(Period); 
			out OCR1AH,R16						; Output Compare Register 1 A - HIGH

			ldi R16,low(Period) 
			out OCR1AL,R16						; Output Compare Register 1 A - LOW

			ldi R16, 64		;interrupt on match			; 64 = (1<<6) - OCIE1A - Output Compare A Match Interrupt Enable
			out TIMSK,R16						; TIMSK – Timer/Counter Interrupt Mask Register

			ldi R16, 0
			out TCNT1L, R16						; Timer/Counter1 - clear
			out TCNT1H, R16

			ldi R16, 32							; enable PCINT7..0		; 32 = (1<<5) - PCIE0: Pin Change Interrupt Enable 0
			out GIMSK,R16						; GIMSK – General Interrupt Mask Register

			ldi R16, 1							;unmask PCINT0			; 1 = (1<<0) - Pin Change Enable Mask 0 
			out PCMSK0,R16						; Pin Change Mask Register 0

			ldi R16, 0				
			mov Digit_0, R16				
			mov Digit_1, R16		
			mov Digit_2, R16			
			mov Digit_3, R16
			
			// *** Display ***

			// Ports
			SET_PORT_B
			SET_PORT_D

			// --- globalne odblokowanie przerwañ
            sei

			// 
MainLoop:   

			SET_DIGIT 0
			SET_DIGIT 1
			SET_DIGIT 2
			SET_DIGIT 3

			RJMP MainLoop

; ### SUBROUTINES ###

;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divider

; internals

.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 

NumberToDigits:

	push Dig0
	push Dig1
	push Dig2
	push Dig3

	; thousands 
	LOAD_CONST R19,R18,1000 ; divider
	rcall _Divide
	mov Dig3,R18       ; quotient - > digit

	; hundreads 
	LOAD_CONST R19,R18,100
	rcall _Divide
	mov Dig2,R18         

	; tens 
	LOAD_CONST R19,R18,10
	rcall _Divide
	mov Dig1,R18        

	; ones 
	mov Dig0,R16      ;reminder - > digit0

	; otput result
	mov R16,Dig0
	mov R17,Dig1
	mov R18,Dig2
	mov R19,Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0

	ret

;*** Divide ***
; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL=R16 ; divident  
.def XH=R17 

.def YL=R18 ; divider
.def YH=R19 

; outputs

.def RL=R16 ; reminder 
.def RH=R17 

.def QL=R18 ; quotient
.def QH=R19 

; internal
.def QCtrL=R24
.def QCtrH=R25

_Divide:push R24 ;save internal variables on stack
        push R25
		
		clr QCtrL ;clr QCtr 
		clr QCtrH

divloop:cp	XL,YL ;exit if X<Y
		cpc XH,YH
		brcs exit   

		sub	XL,YL ;X-=Y
		sbc XH,YH

		adiw  QCtrL:QCtrH,1 ; TmpCtr++

		rjmp divloop			

exit:	mov QL,QCtrL; QoutientCtr to Quotient (output)
		mov QH,QCtrH

		pop R25 ; pop internal variables from stack
		pop R24

		ret

// *** DigitTo7segCode ***
// In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31

ldi R30, Low(Table<<1)  // inicjalizacja rejestru Z 
ldi R31, High(Table<<1)

add R30,R16 // Z + offset
clr R16
adc R31,R16

lpm R16, Z  // Odczyt Z

pop R31
pop R30

ret

// *** DelayInMs ***
// In: R16,R17
DelayInMs:  
            push R24
			push R25

            mov  R24,R16 
			mov  R25,R17                  
  L2: 		rcall OneMsLoop
            SBIW  R24:R25,1 
			BRNE  L2

			pop R25
			pop R24

			ret

// *** OneMsLoop ***
OneMsLoop:	
			push R24
			push R25 
			
			LOAD_CONST R25,R24,2000                    

L1:			SBIW R24:R25,1 
			BRNE L1

			pop R25
			pop R24

			ret