/*
 * cw_15.asm
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
    R18 - 68
    R17 - 36
    one nop in InnerLoop == 9996 cycle register
 */
    