/*
 * cw_23.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

MainLoop:
    ldi R20, 5
    DecLoop:                     
        rcall DelayOneMs ;
        dec R20
        brne DecLoop
rjmp MainLoop

DelayInMs:                              ; zwyk³a etykieta
Delay_ms:                               ; R22 - delay in ms --> (formula) R22*1ms
    nop
    nop
    nop
    nop
    ldi R25, $6                 ; MSB
    ldi R24, $33                ; LSB

InnerLoop: 
    nop
    sbiw R25:R24,1                 
    cp R25, R0                      ; R0 is equal to 0 during whole program
    brne InnerLoop
    dec R22
    brne Delay_ms
ret ;powrót do miejsca wywo³ania

DelayOneMs:
    ldi R22, 1                          ; R22 - delay in ms   <--- delay = 1ms
    rcall DelayInMs
ret



/*
    f = 8 Mhz
    T = 1/f = 0,125 us
    k = 8 000
    t = R22*k*T = 0,125 * 8000 = R22 * 1000 [us]
 */