/*
 * cw_35.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */
 
 // f = 50 Hz --> T = 1/f = 0,02 s --> T = 4*t --> t = 0,02/4 = 0,005 s = 5ms 

.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD

.def Digit_0 = R2
.def Digit_1 = R3
.def Digit_2 = R4
.def Digit_3 = R5

ldi R19, 0b11110		; pins: 1,2,3,4 of port B
ldi R20, 0b1111111		; 7 pins of port D
clr R21

out DDRD, R20
out DDRB, R19			

// segment numbers
ldi R16, 0b111111			; "0"
mov Digit_0, R16
ldi R16, 0b0110				; "1"
mov Digit_1, R16
ldi R16, 0b1011011			; "2"
mov Digit_2, R16
ldi R16, 0b1001111			; "3"
mov Digit_3, R16

// delay
LOAD_CONST R17, R16, 5

MainLoop:
	out Digits_P, R21
	ldi R19, 2
	out Segments_P, Digit_0
	out Digits_P, R19
	rcall DelayInMs
	
	out Digits_P, R21
	ldi R19, 4
	out Segments_P, Digit_1 
	out Digits_P, R19
	rcall DelayInMs
	
	out Digits_P, R21
	ldi R19, 8
	out Segments_P, Digit_2
	out Digits_P, R19
	rcall DelayInMs
	
	out Digits_P, R21
	ldi R19, 16
	out Segments_P, Digit_3
	out Digits_P, R19
	rcall DelayInMs
rjmp MainLoop


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
    cp R25, R0                      ; R0 is equal to 0 during whole program
    brne InnerLoop
/* Ochrona rejestrów */
pop R25                             ; Sciagniecie danych ze stosu do rejestru R25
pop R24                             ; Sciagniecie danych ze stosu do rejestru R24
ret                                 ;powrót do miejsca wywo³ania


    