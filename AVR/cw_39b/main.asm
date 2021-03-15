/*
 * cw_39b.asm
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
.equ Period = 5

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
LOAD_CONST R17, R16, Period
rcall DelayInMs
pop R16
.endmacro 

.def Digit_0 = R2
.def Digit_1 = R3
.def Digit_2 = R4
.def Digit_3 = R5

		

// segment numbers
ldi R16, 2				
mov Digit_0, R16

ldi R16, 4					
mov Digit_1, R16

ldi R16, 6				
mov Digit_2, R16

ldi R16, 8					
mov Digit_3, R16

SET_PORT_B
SET_PORT_D

MainLoop:
	SET_DIGIT 0  
	SET_DIGIT 1  
	SET_DIGIT 2  
	SET_DIGIT 3  
rjmp MainLoop


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
 
Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f			; "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"

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


    