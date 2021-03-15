/*
 * cw_17.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

ldi R22, 10         ; R22 - delay in ms --> (formula) R22*1ms

Delay_ms:
ldi R18, 11

OuterLoop:
    ldi R17, 181

InnerLoop: 
    nop
    dec R17
    brne InnerLoop
    dec R18
    brne OuterLoop
    dec R22
    brne Delay_ms
ret

/*
    f = 8 Mhz
    T = 1/f = 0,125 us
    k = 8 000
    t = R22*k*T = 0,125 * 8000 = R22 * 1000 [us]
 */