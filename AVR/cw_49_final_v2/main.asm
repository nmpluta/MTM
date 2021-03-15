/*
 * cw_49_final.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: Natalia Pluta
 */

.macro LOAD_CONST		
ldi @1, low(@2)		
ldi @0, high(@2)		
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD
.equ QuarterPeriod = 5		

.macro SET_DIGIT		
push R16
ldi R16, 0x10>>@0
out Digits_P, R16
mov R16, Digit_@0
rcall DigitTo7segCode
out Segments_P, R16
push R17
LOAD_CONST R17, R16, QuarterPeriod
rcall DelayInMs
pop R17
pop R16
.endmacro

.macro SET_PORT_B
push R16
ldi R16, 0b11110		
out DDRB, R16
pop R16
.endmacro

.macro SET_PORT_D
push R16
ldi R16, 0b1111111		
out DDRD, R16
pop R16
.endmacro

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Digit_0 = R2
.def Digit_1 = R3
.def Digit_2 = R4
.def Digit_3 = R5

.cseg									
.org 0 rjmp _main							
.org OC1Aaddr rjmp _timer_isr				
.org PCIBaddr   rjmp _ExtPB0_ISR

_ExtPB0_ISR: 
	
	push R16
	in R16, SREG
	push R16

	ldi R16, 1
	add PulseEdgeCtrL, R16
	clr R16
	adc PulseEdgeCtrH, R16

	pop R16
	out SREG, R16
	pop R16
reti


_timer_isr:									
	    push R16						
        push R17	
        push R18
        push R19
		in R16,SREG							
	    push R16

		mov R16,PulseEdgeCtrL
		mov R17,PulseEdgeCtrH       
		lsr R17
		ror R16 
		rcall NumberToDigits
		mov Digit_0,R16 
		mov Digit_1,R17 
		mov Digit_2,R18 
		mov Digit_3,R19 

		clr PulseEdgeCtrL
		clr PulseEdgeCtrH

		pop R16
	    out SREG,R16						
		pop R19								
        pop R18
        pop R17
        pop R16
reti										

_main:
	.equ Period=31250

	ldi R16, 12
	out TCCR1B, R16

	ldi R16,high(Period)
	out OCR1AH,R16

	ldi R16,low(Period) 
	out OCR1AL,R16 

	ldi R16, 64
	out TIMSK, R16
	ldi R16, 0
	out TCNT1L, R16
	out TCNT1H, R16
	ldi R16, 32					
	out GIMSK, R16				
	ldi R16, 1					
	out PCMSK0, R16				

	ldi R16, 0				
	mov Digit_0, R16				
	mov Digit_1, R16		
	mov Digit_2, R16			
	mov Digit_3, R16

	SET_PORT_B
	SET_PORT_D

	sei

MainLoop:
	SET_DIGIT 0					
	SET_DIGIT 1
	SET_DIGIT 2
	SET_DIGIT 3
rjmp MainLoop

;*** NumberToDigits ***  
.def Dig0=R22  
.def Dig1=R23 
.def Dig2=R24 
.def Dig3=R25 

NumberToDigits:
	push Dig0
	push Dig1
	push Dig2
	push Dig3

	LOAD_CONST R19, R18, 1000			
	rcall Divide
	mov Dig3, R18					

	LOAD_CONST R19, R18, 100
	rcall Divide
	mov Dig2, R18

	LOAD_CONST R19, R18, 10
	rcall Divide
	mov Dig1, R18
	
	mov Dig0, R16

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
.def XL=R16   
.def XH=R17  
 
.def YL=R18 
.def YH=R19  
 
.def RL=R16
.def RH=R17  
 
.def QL=R18 
.def QH=R19  
  
.def QCtrL=R24 
.def QCtrH=R25 

Divide:
	push R24
	push R25
	
	clr QCtrL 
	clr QCtrH

DivideLoop:	
	cp XL, YL
	cpc XH, YH
	brcs ExitDivide
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

;*** To7Seg ***
DigitTo7segCode:
	push R30						
	push R31

	ldi R30, low(Table<<1)			
	ldi R31, high(Table<<1)
	
	add R30, R16					
	lpm R16, Z  

	pop R31						
	pop R30
ret
 
Table: .db 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0xff,0x6f

;*** Delays ***
DelayInMs:                             
    push R24
	push R25 
	mov R24, R16					
	mov R25, R17					
	LoopOneMs:
		rcall DelayOneMs
		sbiw R25:R24, 1                             
		brne LoopOneMs
	pop R25
	pop R24 
ret 

DelayOneMs:
push R24                            
push R25                            
ldi R25, $6                
ldi R24, $32               

InnerLoop:
    nop
    sbiw R25:R24,1                 
    brne InnerLoop
pop R25                           
pop R24                            
ret                                 
    