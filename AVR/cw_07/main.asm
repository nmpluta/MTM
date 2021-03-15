/*
 * cw_7.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 


ldi R16, 6
ldi R17, 8
ldi R18, 6
ldi R19, 8
; Subtract r1:r0 from r3:r2
sub R16, R17 ; Subtract low byte
sbc R18, R19 ; Subtract with carry high byte

