`default_nettype none
/*
module sumItUp_mealy 
(input logic ck,reset_l,go_l,
		input logic [15:0] inA,
		output logic 		done,
		output logic [15:0] sum);

	logic ld_l, cl_l, inAeq;
	logic [15:0] addOut;

	enum bit {sA, sB} state;

	always_ff @(posedge ck, negedge reset_l) begin : st_machine
		if (~reset_l)
				state <= sA;
		else begin
				if (((state==sA) & go_l) | ((state==sB) & inAeq))
						state <= sA;
			 	if (((state==0) & ~go_l) | ((state==sB) & ~inAeq))
						state <= sB;
		end
	end : st_machine

	always_ff @(posedge ck, negedge reset_l)
		begin: reg_sum
			if (~reset_l) sum <= 0;
			else if(~ld_l) sum <=addOut;
			else if(~cl_l) sum <= 0;
		end: reg_sum

	assign addOut = inA+sum,
				 ld_l = ~(((state==sA) & ~go_l) | ((state==sB) & ~inAeq)),
				 cl_l = ~((state==sB) & inAeq),
				 done = (state == sB) & inAeq,
				 inAeq = (inA == 0);
endmodule: sumItUp_mealy
*/
module sumItUp_moore
(input logic ck,reset_l,go_l,
		input logic [15:0] inA,
		output logic 		done,
		output logic [15:0] sum);

	logic ld_l, cl_l, inAeq;
	logic [15:0] addOut;

	enum logic [1:0]  {sA, sB, sC} state;

	always_ff @(posedge ck, negedge reset_l) begin : st_machine
		if (~reset_l)
				state <= sA;
		else begin
				if (((state==sA) & go_l) | (state==sC))
						state <= sA;
			 	if (((state==sA) & ~go_l) | ((state==sB) & ~inAeq))
						state <= sB;
			 	if ((state==sB) & inAeq)
						state <= sC;
		end
	end : st_machine

	always_ff @(posedge ck, negedge reset_l)
		begin: reg_sum
			if (~reset_l) sum <= 0;
			else if(~ld_l) sum <=addOut;
			else if(~cl_l) sum <= 0;
		end: reg_sum

	assign addOut = inA+sum,
				 ld_l = ~(state==sB),
				 cl_l = ~(state==sC),
				 done = (state == sC),
				 inAeq = (inA == 0);
endmodule: sumItUp_moore


module top;

	logic ck, reset_l, go_l, done;
	logic [15:0] inA, sum;
	
//	sumItUp_mealy ex(.*);
	sumItUp_moore myEx(.*);

	initial begin
		reset_l = 0; ck = 0;
		#5 reset_l = 1;
		forever #5 ck = ~ck;
	end
	
	initial begin
		$monitor ("sum = %d", sum);

		go_l <=1;
		@(posedge ck);
		go_l <= 0;
		@(posedge ck);
		go_l <= 1;
		inA <= 7;	
		@(posedge ck);
		inA <= 3;
		@(posedge ck);
		inA <= 0;
		@(posedge ck);
		@(posedge ck);
		@(posedge ck);
		$finish;
	end
endmodule: top

