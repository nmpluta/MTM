		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
		LDR     R0, =IODIR0
        LDR     R1, =(1<<4):OR:(1<<5):OR:(1<<6):OR:(1<<7)			; IODIR0_value		| <-> :OR:
        STR     R1, [R0]
		
		LDR R0, =10				; Delay R0 x 1ms
		
main_loop
		BL delay_set
		B				main_loop
delay_set
		LDR R2, =3000
		MUL R2, R0, R2
delay_in_ms
		SUBS R2, R2, #1
		BNE delay_in_ms
		BX lr
		END

