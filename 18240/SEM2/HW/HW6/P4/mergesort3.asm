A_addr	.EQU	$A000	
B_addr	.EQU	$B000
C_addr	.EQU	$C000	
A_size	.EQU	$0080

		.ORG	$0010
begin	LDI		R7,$0			;initiates the stack and sets parameter values
		LDSP	R7
		LDI		R0,A_addr
		LDI		R1,B_addr
		LDI		R2,C_addr
		LDI		R3,A_size
		PUSH	R0
		PUSH	R3
		PUSH	R1
		PUSH	R2
		JSR		merge
		POP		R2
		POP		R1
		POP		R3
		POP		R0
		BRA		done

		.ORG	$1000		;start executing code at addr $1000
merge	LDSF	R0,$3		;Loading inital values for counters
		LDSF	R1,$3		;(R0 counts for listA, R1 counts for listB)
		LDSF	R2,$4		;and loading addr locations of lists A,B,C,
		LDSF	R3,$2 		;into registers (for incrementing)
		LDSF	R4,$1		;

check	LDR		R5,R2		;updates registers R5 and R6 with the first words
		LDR		R6,R3		;in listA and listB
		LDR		R7,R4		;updates R7 w/value after last word in listC
		CMI 	R0,$0		;checks to see if listA has run out of words 
		BRZ		whileB		;
		CMI		R1,$0		;checks to see if listB has run out of words
		BRZ		whileA		;
	
comp	CMR 	R5,R6		;compares first words from listA and listB
		BRN		A			;and jumps to proper if condition;
		BRZ		AB			;that is, if A>B (A), A=B (AB), or B>A (B)
		BRA		B			;

A		MOV		R7,R5		;moves first word in listA to bottom of listC
		DECR	R0			;increments the listA counter, the addr of 
		INCR	R2			;listA, and the addr of listC
		INCR	R4			;(this way updates to regs will hold true)
		BRA		check		;jumps back to check for updates

AB		MOV		R7,R5		;similar to condition A except that 
		INCR	R4			;both words in listA and listB
		LDR		R7,R4		;are being added to listC
		MOV		R7,R6		;listC is being incremented and updated here
		INCR	R4			;once before heading to check
		INCR	R3			
		INCR	R2
		DECR	R0
		DECR	R1
		BRA		check

B		MOV		R7,R6		;similar to condition A exept now for listB
		DECR	R1			
		INCR	R3			
		INCR	R4			
		BRA		check

whileB	MOV		R7,R6		;case when listA is out of words and so 
		INCR	R3			;the rest of the words from listB need to
		INCR	R4			;be added onto listC without changing the
		DECR	R1			;order they are in
		BRZ		jump		;jumps to done if listB runs out of words
		BRA 	check		;still jumps back to check for updates

whileA	MOV		R7,R5		;similar to the above looped but now for
		INCR	R2			;listA when listB runs out of words
		INCR	R4
		DECR	R0
		BRZ		jump
		BRA 	check

jump	RTN

done	STOP				;STOP THE PROGRAM....or less the world will blow

;code for checking
		.ORG	$A000
lisA	.DW		$0001
		.DW		$0003
		.DW		$0004
		.DW		$0008
		.DW		$000a

		.ORG	$B000
lisB	.DW		$0000
		.DW		$0002
		.DW     $0003
		.DW     $0003
		.DW		$000b
