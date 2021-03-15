/*
 * cw_38.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */


MainLoop:
ldi R17, 9
	L1:
	mov R16, R17
	rcall DigitTo7segCode
	dec R17
	brne L1
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