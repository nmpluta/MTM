/*
 * cw_5.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

ldi R20,100
ldi R21,200
add R20,R21
ldi R21,0
adc R21,R21

/*
 300 - 256 = 44  --> 44 in hexadecimal is 0x2C
 R21 0x01
 R20 0x2C
 (hex) 0x12C --> (dec) 300
 */