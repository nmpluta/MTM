/*
 * cw_43.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */

.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro


LOAD_CONST XH1, XL1, 9876			; divident

;*** NumberToDigits *** 
;input : Number: R16-17 
;output: Digits: R16-19 
;internals: X_R,Y_R,Q_R,R_R - see _Divide 
 
; internals 
.def Dig0=R22 ; Digits temps 
.def Dig1=R23 ;  
.def Dig2=R24 ;  
.def Dig3=R25 ; 

NumberToDigits:
	push Dig0
	push Dig1
	push Dig2
	push Dig3

	LOAD_CONST YH1, YL1, 1000			; divisor 1000
	rcall Divide
	mov Dig3, QL					; quotient --> Dig3

	LOAD_CONST YH1, YL1, 100
	rcall Divide
	mov Dig2, QL

	LOAD_CONST YH1, YL1, 10
	rcall Divide
	mov Dig1, QL
	
	mov Dig0, RL

	mov R16, Dig0
	mov R17, Dig1
	mov R18, Dig2
	mov R19, Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0
ret

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


Divide:
	push R24
	push R25
	
	clr QCtrL 
	clr QCtrH

DivideLoop:	
	cp XL1, YL1
	cpc XH1, YH1
	brlo ExitDivide
	sub XL1, YL1
	sbc XH1, YH1
	adiw QCtrH:QCtrL, 1
	rjmp DivideLoop


ExitDivide:
	mov QL, QCtrL
	mov QH, QCtrH
	pop R25
	pop R24
ret

    