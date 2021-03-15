/*
 * cw_14.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 



ldi R18, 50
OuterLoop:
    ldi R17, 10
    InnerLoop: 
        nop
        dec R17
        brne InnerLoop
        dec R18
        brne OuterLoop
ret
    