		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
		LDR     R5, =IODIR0
        LDR     R6, =(1<<16):OR:(1<<17):OR:(1<<18):OR:(1<<19)			; IODIR0_value		| <-> :OR:
        STR     R6, [R5]
		
		LDR     R5, =IODIR1
        LDR     R6, =(1<<16):OR:(1<<17):OR:(1<<18):OR:(1<<19):OR:(1<<20):OR:(1<<21):OR:(1<<22):OR:(1<<23)			; IODIR1_value		
        STR     R6, [R5]		
		
		LDR     R5, =IOSET0
        LDR     R6, =(1<<18)			; IOSET0_value = 2 digit   [0, 1, 2, 3]		
        STR     R6, [R5]		

		LDR     R5, =IOSET1
        LDR     R6, =(1<<16):OR:(1<<17):OR:(1<<18)			; IOSET1_value = '7'		
        STR     R6, [R5]
		
		LDR R0, =10				; Delay R0 x 1ms
		
main_loop
		BL delay_set
		B				main_loop
delay_set
		LDR R1, =3000
		MUL R1, R0, R1
delay_in_ms
		SUBS R1, R1, #1
		BNE delay_in_ms
		BX lr
		END

