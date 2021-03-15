/*
 * cw_18.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

ldi R22, 10                      ; R22 - delay in ms --> (formula) R22*1ms

Delay_ms:
    nop
    nop
    nop
    ldi R18, 250                ; MSB
    ldi R17, 204                ; LSB
    ldi R21, 1                  ; R21 = 1 

InnerLoop: 
    nop
    add R17, R21
    adc R18, R0                 ; R0 is equal to 0 during whole program
    cp R18, R0
    brne InnerLoop
    dec R22
    brne Delay_ms
ret



/*
    f = 8 Mhz
    T = 1/f = 0,125 us
    k = 8 000
    t = R22*k*T = 0,125 * 8000 = R22 * 1000 [us]
 */