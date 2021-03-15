/*
 * cw_13.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

Invinite_loop: nop
    ldi R20, 6
    Loop:   nop
            dec R20         ; DEC – Decrement
            breq zero       ; cycle counter == 2 if condition is true OR 1 if condition is false
            rjmp Loop
    zero:  nop 
    nop
    rjmp Invinite_loop
    

/*
        Cycles=(R20*5)+5
 */