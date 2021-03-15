/*
 * cw_28.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */  

clr R16
ldi R17, 0b11110
OUT DDRB,R17

MainLoop:
OUT PORTB, R16
OUT PORTB, R17
rjmp MainLoop


    