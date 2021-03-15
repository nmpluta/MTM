/*
 * cw_16.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 


ldi R18, 33
OuterLoop:
    ldi R17, 75
    InnerLoop: 
        nop
        dec R17
        brne InnerLoop
        dec R18
        brne OuterLoop
        nop
ret


/*
    f = 8 Mhz
    T = 1/f = 0,125 us
    k = 10 000
    t = k*T = 0,125 * 10 000 = 1250 [us]
 */
    