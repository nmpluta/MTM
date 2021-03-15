/*
 * cw_21.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

MainLoop:
    ldi R20, 5
    InnerLoop:
        rcall DelayNCycles ;
        dec R20
        brne InnerLoop
rjmp MainLoop

DelayNCycles: ;zwyk³a etykieta
nop
nop
nop
ret ;powrót do miejsca wywo³ania