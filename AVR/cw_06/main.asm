/*
 * cw_6.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

ldi R20,100
ldi R21,200
add R20,R21
ldi R21,0
adc R21,R21

ldi R22,200
ldi R23,200
add R22,R23
ldi R23,0
adc R23,R23

add R20, R22
adc R21, R23


/*
 300 - 256 = 44  --> 44 in hexadecimal is 0x2C
 R21 0x01
 R20 0x2C
 (hex) 0x12C --> (dec) 300

 400 - 256 = 144 --> 144 in hex is 0x90
 R23 0x01
 R22 0x90
 (hex) 0x190 --> (dec) 400

 44 + 144 = 188 --> 188 in hex is 0xBC              LSB
 1 + 1 = 2 --> 2 in hex is 0x02                     MSB

 300 + 400 = 700 --> 700 in hex is 0x2BC
 R21 0x02
 R20 0xBC
 */