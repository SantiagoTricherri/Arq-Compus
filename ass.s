.text

.global cohete

cohete
		;PUSH	{R4, R5, R6, R7, LR}
		
		;LDR		R0, =msg_cohete
		;BL		printf
		
		MOV		R5, #0x80
		MOV		R6, #0xC0
		MOV		R4, #0x0
		MOV		R7, #5
		
		MOV		R0, R4
		;BL		disp
		;BL		leeds
		MOV		R0, R2
		;BL		retardo
		
loopC
		mov		R4, R6
		MOV		R0, R4
		;BL		disp
		;BL		leeds
		LSR		R6, R6, #1
		MOV		R0, R2
		;BL		retardo
		
		SUBS		R7, R7, #1
		BNE		loopC
		
end_loopC
		MOV		R5, #0xFF
		MOV		R7, #2
		
loopF
		MOV		R0, R5
		;BL		disp
		;BL		leeds
		MOV		R0, R2
		;BL		retardo
		
		SUBS		R7, R7, #1
		BNE		loopF
		
		;wait_enterC
		;BL		getchar
		;CMP		R0, #'\n'
		;BNE		wait_enterC
		
		;MOV		R0, #0
		;BL		set_input_mode
		
		;POP		{R4, R5, R6, R7, PC}

