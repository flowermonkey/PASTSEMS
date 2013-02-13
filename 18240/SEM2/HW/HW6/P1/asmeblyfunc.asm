		.ORG	$0000  ;start at addr 0000 and branch to code
		BRA		start

		.ORG	$1000	;code starts at 1000
start	LDI		R7,$0	;initiate the stack pointer
		LDSP	R7
		LDI		R0,$10	;give R0 initial value of 10
		PUSH 	R0		;put on stack for parameter use
		PUSH	R7
		JSR		func	;call to func
		POP 	R7		;pop off rest of registers on stack
		POP		R0	
		BRA		done	; end program

jump	POP		R7		;jump returns stack to return addr
		POP		R0		;then returns to main
		RTN

func 	PUSH 	R0		;func: Parameters: R0,R7
		PUSH 	R7		;push registers that may be motified to stack
		LDSF	R0,$3	;load parameters
		LDSF	R7,$4	
		ADD		R0,R7	;add registers
		BRA		jump	;branch to jump
		
done 	STOP
		
		
