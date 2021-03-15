		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
		ldr R0, =10				; Delay R0 x 1ms
		ldr R4, =3001
		mul R4, R0, R4
		
main_loop
		subs R4, R4, #1
		bne				main_loop
		nop
		nop
		END

