		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		

		ldr R4, =1000
		
main_loop
		subs R4, R4, #1
		bne				main_loop
		nop
		END

