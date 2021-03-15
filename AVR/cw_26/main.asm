/*
 * cw_26.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 


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

DelayInMs:                              ; zwyk³a etykieta,          R25 - delay in ms --> (formula) R25*1ms
    rcall DelayOneMs
    dec R25                             
    brne DelayInMs
ret ;powrót do miejsca wywo³ania


DelayOneMs:
sts $60, R24                        ; Ochrona rejestrów
sts $61, R25                        ; Zapis danych z rejestrow do adresow 0x60 oraz 0x61
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
lds R24, $60                        ; Ochrona rejestrów
lds R25, $61                        ; Wpisanie danych z adresow 0x60 i 0x61 do rejestrow R24, R25
ret                                 ;powrót do miejsca wywo³ania


    