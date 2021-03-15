/*
 * cw_0.asm
 *
 *  Created: 10/7/2020 2:14:54 PM
 *   Author: student
 */
 
  
;### MACROS & defs (.equ)###

.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro


	ldi R16, 5
Loop: nop
	nop
	nop
	LOAD_CONST R16, R17, 300, 400
	dec R16
	dec R17
	rjmp Loop