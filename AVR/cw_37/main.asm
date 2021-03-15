/*
 * cw_37.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */


MainLoop:
ldi R17, 9
	L1:
	mov R16, R17
	rcall Square
	dec R17
	brne L1
rjmp MainLoop

// IN: R16 OUT: R16^2
Square:
	ldi R30, low(Table<<1)   
	ldi R31, high(Table<<1)
	add R30, R16
	lpm R16, Z  
ret
 
Table: .db 0x00, 0x01, 0x02, 0x09, 0x10, 0x19, 0x24, 0x31, 0x40, 0x51			; 1, 2, 4, 9, 16, 25, 36, 49, 64, 81