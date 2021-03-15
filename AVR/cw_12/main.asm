/*
 * cw_12.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 


ldi R20, 5
Loop:   nop
        dec R20         ; DEC – Decrement
        breq carry
        rjmp Loop
carry:  nop 

    