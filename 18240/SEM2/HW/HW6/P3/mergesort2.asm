listA	.EQU	$A000	;created local varibles
listB	.EQU	$B000	;for address locations of
listC	.EQU	$C000	;the lists
size	.EQU	$0005	;size of lists

		.ORG	$0000
A_addr	.DW		$A000	;Starting Address if bank A
A_size	.DW		$0005	;Size of bank A (and also bank B)
B_addr	.DW		$B000	;Starting Address of bank B
C_addr	.DW		$C000	;Starting Address of bank C		

		.ORG	$0010	
		LDA		R0,A_addr
		STA		listA, R0
		LDA		R0,B_addr
		STA		listB, R0
		LDA		R0,C_addr
		STA		listC, R0
		LDA		R0,A_size
		STA		size, R0
		BRA		start

		.ORG	$1000		;start executing code at addr $1000
start	LDI		R0,$0		;Loading inital values for counters
		LDI		R1,$0		;(R0 counts for listA, R1 counts for listB)
		LDI		R2,listA	;and loading addr locations of lists A,B,C,
		LDI		R3,listB 	;into registers (for incrementing)
		LDI		R4,listC	;

check	LDR		R5,R2		;updates registers R5 and R6 with the first words
		LDR		R6,R3		;in listA and listB
		LDR		R7,R4		;updates R7 w/value after last word in listC
		CMI 	R0,size		;checks to see if listA has run out of words 
		BRZ		whileB		;
		CMI		R1,size		;checks to see if listB has run out of words
		BRZ		whileA		;
	
comp	CMR 	R5,R6		;compares first words from listA and listB
		BRN		A			;and jumps to proper if condition;
		BRZ		AB			;that is, if A>B (A), A=B (AB), or B>A (B)
		BRA		B			;

A		MOV		R7,R5		;moves first word in listA to bottom of listC
		INCR	R0			;increments the listA counter, the addr of 
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
		INCR	R0
		INCR	R1
		BRA		check

B		MOV		R7,R6		;similar to condition A exept now for listB
		INCR	R1			
		INCR	R3			
		INCR	R4			
		BRA		check

whileB	MOV		R7,R6		;case when listA is out of words and so 
		INCR	R3			;the rest of the words from listB need to
		INCR	R4			;be added onto listC without changing the
		INCR	R1			;order they are in
		CMI		R1,size
		BRZ		done		;jumps to done if listB runs out of words
		BRA 	check		;still jumps back to check for updates

whileA	MOV		R7,R5		;similar to the above looped but now for
		INCR	R2			;listA when listB runs out of words
		INCR	R4
		INCR	R0
		CMI		R0,size
		BRZ		done
		BRA 	check

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
