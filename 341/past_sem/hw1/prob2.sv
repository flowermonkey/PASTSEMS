//Problem 2
//bflores

typedef enum bit [2:0]{
	ADD= 3'b100, 
	SUB= 3'b010, 
	AND= 3'b001, 
	OR= 3'b110, 
	XOR= 3'b011} aluFun_t;

module testbench
(input bit [7:0] result,
  output bit [7:0] a,b,
  output aluFun_t op);
	
	int unsigned i;
	
	initial begin
	
	$monitor($stime,, " %x = %x %s %x",result, a, op, b);
	a=8'h35; b=8'h15;

	op=op.first();
	forever begin 
		if(op == op.last()) break;
		#5 op=op.next;
	end
	#5 $finish;
	end

endmodule:testbench

module aluWithEnums
	(input bit [7:0] a, b,
	 output bit [7:0] result,
	  input aluFun_t op);
	always_comb
	unique case (op)
	ADD:result = a + b;
	SUB:result = a - b;
	AND:result = a & b;
	OR: result = a | b;
	XOR:result = a ^ b;
	endcase
endmodule: aluWithEnums

module top;

	bit [7:0] a,b,result;
	aluFun_t op;

	aluWithEnums alu(.*);
	testbench tb(.*);
endmodule:top

/*
		SIMULATION RESULTS

         0  4a = 35 ADD 15
         5  20 = 35 SUB 15
        10  15 = 35 AND 15
        15  35 = 35 OR 15
        20  20 = 35 XOR 15
$finish called from file "../prob2.sv", line 28.
$finish at simulation time                   25
   V C S   S i m u l a t i o n   R e p o r t 
Time: 25
*/

