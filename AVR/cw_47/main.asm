/*
 * cw_47.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */

.cseg										; segment pamiêci kodu programu
.org 0 rjmp _main							; skok po resecie (do programu g³ównego)
.org OC1Aaddr rjmp _timer_isr				; skok do obs³ugi przerwania timera

_timer_isr:									; procedura obs³ugi przerwania timera
	    push R16							;ochrona rejestrow
        push R17	
        push R18
        push R19
		in R16,SREG							; ochrona SREG
	    push R16

		mov R16, PulseEdgeCtrL
		mov R17, PulseEdgeCtrH
		rcall NumberToDigits
		mov Digit_0, R16
		mov Digit_1, R17
		mov Digit_2, R18
		mov Digit_3, R19
		
		ldi R16, 1
		add PulseEdgeCtrL, R16
		clr R16
		adc PulseEdgeCtrH, R16

		pop R16
	    out SREG,R16						; ochrona SREG
		pop R19								; ochrona rejestrow
        pop R18
        pop R17
        pop R16
reti										; powrót z procedury obs³ugi przerwania (reti zamiast ret)

.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.equ Digits_P = PORTB
.equ Segments_P = PORTD
.equ QuarterPeriod = 5			// 5ms * 4 = 20ms - okres

.macro SET_PORT_B
push R16
ldi R16, 0b11110		; pins: 1,2,3,4 of port B
out DDRB, R16
pop R16
.endmacro

.macro SET_PORT_D
push R16
ldi R16, 0b1111111		; 7 pins of port D
out DDRD, R16
pop R16
.endmacro

.macro SET_DIGIT		; argument nr wyswietlacza
push R16
ldi R16, 0x10>>@0
out Digits_P, R16
mov R16, Digit_@0
rcall DigitTo7segCode
out Segments_P, R16
push R17
LOAD_CONST R17, R16, QuarterPeriod
rcall DelayInMs
pop R17
pop R16
.endmacro 

.def Digit_0 = R2
.def Digit_1 = R3
.def Digit_2 = R4
.def Digit_3 = R5


_main:
	ldi R16, 12
	out TCCR1B, R16

	ldi R16, low(31250)					; sta³a prze³adowania
	out OCR1AL, R16
	ldi R16, high(31250)
	out OCR1AH, R16

	ldi R16, 64
	out TIMSK, R16
	ldi R16, 0
	out TCNT1L, R16
	out TCNT1H, R16

	ldi R16, 0				
	mov Digit_0, R16				
	mov Digit_1, R16		
	mov Digit_2, R16			
	mov Digit_3, R16

	SET_PORT_B
	SET_PORT_D

	LOAD_CONST R27, R26, 10000
	sei

Clear:
	clr PulseEdgeCtrL
	clr PulseEdgeCtrH
MainLoop:
	cp PulseEdgeCtrL, R26
	cpc PulseEdgeCtrH, R27 
	brge Clear
	SET_DIGIT 0					
	SET_DIGIT 1
	SET_DIGIT 2
	SET_DIGIT 3
rjmp MainLoop

;*** NumberToDigits *** 
;input : Number: R16-17 
;output: Digits: R16-19 
;internals: X_R,Y_R,Q_R,R_R - see _Divide 
 
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

	LOAD_CONST R19, R18, 1000			; divisor 1000
	rcall Divide
	mov Dig3, R18					; quotient --> Dig3

	LOAD_CONST R19, R18, 100
	rcall Divide
	mov Dig2, R18

	LOAD_CONST R19, R18, 10
	rcall Divide
	mov Dig1, R18
	
	mov Dig0, R16

	mov R16, Dig0
	mov R17, Dig1
	mov R18, Dig2
	mov R19, Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0
ret

;*** Divide *** 
; X/Y -> Quotient,Remainder 
; Input/Output: R16-19, Internal R24-25 
 
; inputs 
.def XL=R16 ; divident   
.def XH=R17  
 
.def YL=R18 ; divisor 
.def YH=R19  
 
; outputs 
.def RL=R16 ; remainder 
.def RH=R17  
 
.def QL=R18 ; quotient 
.def QH=R19  
 
; internal 
.def QCtrL=R24 
.def QCtrH=R25 


Divide:
	push R24
	push R25
	
	clr QCtrL 
	clr QCtrH

DivideLoop:	
	cp XL, YL
	cpc XH, YH
	brlo ExitDivide
	sub XL, YL
	sbc XH, YH
	adiw QCtrH:QCtrL, 1
	rjmp DivideLoop


ExitDivide:
	mov QL, QCtrL
	mov QH, QCtrH
	pop R25
	pop R24
ret

// IN: R16 - number;	 OUT: - segment digit
DigitTo7segCode:
	push R30						; secure of registers
	push R31

	ldi R30, low(Table<<1)			; register Z 
	ldi R31, high(Table<<1)
	
	add R30, R16					
	lpm R16, Z  

	pop R31							; secure of registers
	pop R30
ret
 
Table: .db 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0xff,0x6f			; "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"

// In: R17 - MSB, R16 - LSB; R17:R16 - delay in ms --> formula R17:R16 * 1ms
DelayInMs:                              ; zwyk³a etykieta, 
    push R24
	push R25 
	mov R24, R16						; R24 - LSB
	mov R25, R17						; R25 - MSB
	LoopOneMs:
		rcall DelayOneMs
		sbiw R25:R24, 1                             
		brne LoopOneMs
	pop R25
	pop R24 
ret ;powrót do miejsca wywo³ania 

DelayOneMs:
/* Ochrona rejestrów */
push R24                            ; Zapis R24 na stosie
push R25                            ; Zapis R25 na stosie
ldi R25, $6                 ; MSB
ldi R24, $32                ; LSB

InnerLoop:
    nop
    sbiw R25:R24,1                 
    brne InnerLoop
/* Ochrona rejestrów */
pop R25                             ; Sciagniecie danych ze stosu do rejestru R25
pop R24                             ; Sciagniecie danych ze stosu do rejestru R24
ret                                 ;powrót do miejsca wywo³ania
    