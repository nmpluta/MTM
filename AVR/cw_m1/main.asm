/*
 * cw_m1.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

 .macro LOAD_CONST		; argumenty MSB, LSB, number
 ldi @1, low(@2)		; MSB
 ldi @0, high(@2)		; LSB
 .endmacro

MainLoop:
LOAD_CONST R17, R16, 287			; R17:R16 = (hex) 0x11F = (dec) 287
dec R16
dec R17
rjmp MainLoop

    