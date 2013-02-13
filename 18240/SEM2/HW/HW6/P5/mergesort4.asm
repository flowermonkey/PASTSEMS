A_addr	.EQU	$A000	
scrap	.EQU	$B000	
A_size	.EQU	$0032

		.ORG	$0010
begin	LDI		R7,$0		;Main function
		LDSP	R7			;initiates stack and parameter values
		LDI		R0,A_addr
		LDI		R1,A_size
		PUSH	R1
		PUSH	R0
		JSR		sort
		POP		R0
		POP		R1
		BRA		done

		.ORG	$1000	
sort	PUSH	R0			;Sort Funtion: Parameters: A_addr, A_size
		PUSH	R1
		PUSH	R2			;this function recursively takes a list
		PUSH	R3			;divides it in half
		LDSF	R0,$6		;defines a pointer to a left half
		CMI		R0,$1		;and a right half
		BRZ		jump2		;when the halfs are 1 word in size
		LSHR	R0			;the lists will begin to merge
		LDSF	R1,$5		; left=R1
		MOV     R2,R1
		ADD		R2,R0		; right =R2
		PUSH	R0
		PUSH	R1
		JSR		sort		;recursively split left
		POP		R1
		PUSH	R2
		JSR		sort		;recursively split right
		POP		R2
		POP		R1
		PUSH	R1
		PUSH	R0
		PUSH	R2
		LDI		R3,scrap
		PUSH	R3
		JSR		merge		;recursively merge lists
		POP		R3
		POP		R2
		POP		R0
		POP		R1
		MOV		R6,R0
		BRA		loop

loop	LDR		R7,R2 		;this looop is meant to
		STR		R3,R7 		;store words that are in scrap mem words
		INCR	R3			;to listA at A_addr
		INCR	R2
		DECR	R6			;this is a destructive copy
		BRZ		jump2
		BRA		loop
							;Merge Function
merge	PUSH	R0
		PUSH	R1
		PUSH	R2
		PUSH	R3
		PUSH	R4
		PUSH	R5
		PUSH	R6
		PUSH	R7
		LDSF	R0,$b		;Loading inital values for counters
		LDSF	R1,$b		;(R0 counts for listA, R1 counts for listB)
		LDSF	R2,$c		;and loading addr locations of lists A,B,C,
		LDSF	R3,$a		;into registers (for incrementing)
		LDSF	R4,$9

check	LDR		R5,R2		;updates registers R5 and R6 with the first words
		LDR		R6,R3		;in listA and listB
		LDR		R7,R4		;updates R7 w/value after last word in listC
		CMI 	R0,$0		;checks to see if listA has run out of words 
		BRZ		whileB		
		CMI		R1,$0		;checks to see if listB has run out of words
		BRZ		whileA		
	
comp	CMR 	R5,R6		;compares first words from listA and listB
		BRN		A			;and jumps to proper if condition;
		BRZ		AB			;that is, if A>B (A), A=B (AB), or B>A (B)

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
		BRZ		jump1		;jumps to done if listB runs out of words
		BRN		jump1
		BRA 	check		;still jumps back to check for updates

whileA	MOV		R7,R5		;similar to the above looped but now for
		INCR	R2			;listA when listB runs out of words
		INCR	R4
		DECR	R0
		BRZ		jump1
		BRN		jump1
		BRA 	check

jump	RTN
jump1	POP		R7
		POP		R6
		POP		R5
		POP		R4
		POP		R3
		POP		R2
		POP		R1
		POP		R0
		RTN
jump2	POP		R3				
		POP		R2
		POP		R1
		POP		R0
		RTN
done	STOP				;STOP THE PROGRAM....or less the world will blow

;code for checking
		.ORG	$A000
lisA	.DW		$0004
		.DW		$000d
		.DW		$0003
		.DW		$0001
		.DW		$000c
		.DW		$000f
		.DW		$0002
		.DW		$000a
		.DW		$0010
		.DW		$0008
		.DW		$000b
		.DW		$0005
		.DW		$0007
		.DW		$000e
		.DW		$0006
		.DW		$0009
