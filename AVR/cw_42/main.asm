/*
 * cw_42.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */

.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro

;*** Divide *** 
; X/Y -> Quotient,Remainder 
; Input/Output: R16-19, Internal R24-25 
 
; inputs 
.def XL1=R16 ; divident   
.def XH1=R17  
 
.def YL1=R18 ; divisor 
.def YH1=R19  
 
; outputs 
.def RL=R16 ; remainder 
.def RH=R17  
 
.def QL=R18 ; quotient 
.def QH=R19  
 
; internal 
.def QCtrL=R24 
.def QCtrH=R25 

LOAD_CONST XH, XL, 1200
LOAD_CONST YH, YL, 500

Divide:
	push R24
	push R25
	
	clr QCtrL 
	clr QCtrH

DivideLoop:	
	cp XL, YL
	cpc XH, YH
	brlo ExitDivide
	sub XL, YL
	sbc XH, YH
	adiw QCtrH:QCtrL, 1
	rjmp DivideLoop


ExitDivide:
	mov QL, QCtrL
	mov QH, QCtrH
	pop R25
	pop R24
ret
    