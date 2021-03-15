/*
 * cw_24.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

 /* PROGRAM NIEDZIALAJACY ze wzgledu na brak ochrony rejestru */

MainLoop:
    ldi R20, 8
    DecLoop:                     
        rcall DelayOneMs ;
        dec R20
        ldi R25, 3
        rcall DelayInMs
        dec R20
        brne DecLoop
rjmp MainLoop

DelayInMs:                              ; zwyk³a etykieta,          NIEPOPRAWNE R25 - delay in ms --> (formula) R25*1ms
    rcall DelayOneMs
    dec R25                             ; niepoprawne!!! Jak widaæ podprogram wywo³ywany (DelayOneMs) modyfikuje zawartoœæ zmiennej podprogramu wywo³uj¹cego (DelayInMs, licznik pêtli) czyli innymi s³owy gubi jego stan.
    brne DelayInMs
ret ;powrót do miejsca wywo³ania


DelayOneMs:
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
ret ;powrót do miejsca wywo³ania



/*
    f = 8 Mhz
    T = 1/f = 0,125 us
    k = 8 000
    t = R22*k*T = 0,125 * 8000 = R22 * 1000 [us]
 */