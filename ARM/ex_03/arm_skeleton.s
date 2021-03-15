		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
		ldr R0, =10				; Delay R0 x 1ms
		
main_loop
		bl delay_set
		b				main_loop
delay_set
		ldr R4, =3000
		mul R4, R0, R4
delay_in_ms
		subs R4, R4, #1
		bne delay_in_ms
		bx lr
		end

