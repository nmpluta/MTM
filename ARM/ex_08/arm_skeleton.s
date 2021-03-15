		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
		
; Directives
CURRENT_DIGIT RN R12
		

		LDR     R5, =IODIR0
        LDR     R4, =(1<<16):OR:(1<<17):OR:(1<<18):OR:(1<<19)			; IODIR0_value		| <-> :OR:
        STR     R4, [R5]												; enable every display Port 0 
		
		LDR     R5, =IODIR1
        LDR     R4, =(1<<16):OR:(1<<17):OR:(1<<18):OR:(1<<19):OR:(1<<20):OR:(1<<21):OR:(1<<22):OR:(1<<23)			; IODIR1_value		
        STR     R4, [R5]																							; enable every segments Port 1

		;LDR     R5, =IOSET1
		;LDR	R4, =(0x3f)<<16						; == (1<<16):OR:(1<<17):OR:(1<<18)
        ;STR     R4, [R5]
		
		LDR CURRENT_DIGIT, =0
		
main_loop
		;LDR 	R8, =((2_1111)<<16)
		LDR     R5, =IOCLR0
        LDR     R4, =(1<<16):OR:(1<<17):OR:(1<<18):OR:(1<<19)			; IOCLR0_value
        STR     R4, [R5]

		LDR     R5, =IOCLR1
        LDR     R4, =(1<<16):OR:(1<<17):OR:(1<<18):OR:(1<<19):OR:(1<<20):OR:(1<<21):OR:(1<<22):OR:(1<<23)			; IODIR1_value		
        STR     R4, [R5]

		LDR     R5, = IOSET0
        LDR     R4, =(1<<19)
		MOV		R4, R4, LSR CURRENT_DIGIT			; Rm, LSR #n: Content of Rm shifted right with zero extension by #n bits;
        STR     R4, [R5]

		ADR		R4, Table							; Load addresses of table to a register
		ADD		R4, R4, CURRENT_DIGIT
		LDRB	R6, [R4]							; Load register byte value to Memory.
		
		MOV		R6, R6, LSL #16						; Rm, LSL #n: Content of Rm shifted left with zero extension by #n bits;	
		LDR     R5, =IOSET1
        STR     R6, [R5]		

		ADD CURRENT_DIGIT, CURRENT_DIGIT, #1
		CMP CURRENT_DIGIT, #4						; compare if equal set Z flag (CURRENT_DIGIT - 4)
		EOREQ CURRENT_DIGIT, CURRENT_DIGIT			; Logical Exclusive OR if before CURRENT_DIGIT = 4
		
		LDR R0, =1500				; Delay R0 x 1ms
		BL delay_set
		B				main_loop
delay_set
		LDR R1, =3000
		MUL R1, R0, R1
delay_in_ms
		SUBS R1, R1, #1
		BNE delay_in_ms
		BX lr
		
Table
		DCB 0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0xff,0x6f
		
		END

