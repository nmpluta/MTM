/*
 * cw_5.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

ldi R20, 100
ldi R21, 200
add R20, R21
clc                     ; CLC - Clear Carry Flag

/*
 300 - 256 = 44  --> 44 in hexadecimal is 0x2C
 program is working properly
 */