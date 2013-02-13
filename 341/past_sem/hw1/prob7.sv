//Problem 7
//bflores
module fsm_mealy(input bit clk,go_l,inAeq,reset_l,
			output bit cl_l,ld_l,done);

enum logic [1:0] {Load=2'd0, Sum=2'd1}curr,nxt;

always_ff @ (posedge clk)begin
		curr<=nxt;
	end

always_comb begin
	cl_l =1; ld_l=1; done=0;
	case(curr)
	Load:begin
		if(go_l==0)begin
			ld_l=0;
			nxt=Sum;
		end
		else begin
			nxt=curr;
		end
	end

	Sum:begin
		if((inAeq==1) | (reset_l==0))begin
			cl_l = 0;
			nxt=Load;
		end
		else begin
			ld_l=0;
			nxt=curr;
		end
	end
	endcase
end
endmodule: fsm_mealy
//////////////////////////////////////////////////////////
module fsm_D(input bit clk,go_l,inAeq,reset_l,
			output bit cl_l,ld_l,done);

enum logic [1:0] {Load=2'd0, Sum=2'd1, Done=2'd2}curr,nxt;

always_comb begin
	cl_l=1;ld_l=1;done=0;

	case(curr)

	Load: begin
		ld_l=0;
	end

	Sum: ld_l=0;

	Done:begin
		cl_l=0;
		done=1;
	end

	endcase
end

always_ff @ (posedge clk)begin
		curr<=nxt;
	end

always_comb begin
	case(curr)
	Load:begin
		if(go_l==0)
			nxt=Sum;
		else
			nxt=curr;
	end

	Sum:begin
		if(inAeq==1)
			nxt=Done;
		else if (reset_l==0)
			nxt=Load;
		else
			nxt=curr;
		end
	Done: nxt=Load;
	endcase
end
endmodule: fsm_D

module comparator (input logic [3:0] inA, 
					output bit inAeq);

	always_comb begin
		if(inA == 3'd0) 
			inAeq = 1;
		else
			inAeq=0;
	end
endmodule: comparator

module adder (input logic [3:0] inA, sum,
			  output logic [3:0] addOut);
	
	always_comb begin
		if(sum >0)
			addOut = inA + sum;
		else
			addOut = inA;
	end
endmodule: adder

module register (input logic [3:0] addOut,
				 input bit clk,reset_l, cl_l, ld_l,
				 output logic [3:0] sum);

	always_ff @(posedge clk) begin
		if(~cl_l | ~reset_l)
			sum <= 0;
		else if(~ld_l)
			sum <= addOut;
		else
			sum <= sum;
	end
endmodule: register

module tb_prob7 (output logic [3:0] inA,
			output bit clk,go_l,reset_l,
			input logic [3:0]sum,
			input bit cl_l,ld_l,done);

initial begin
	clk = 0;
	forever #5 clk = ~clk;
	end

initial begin
	reset_l=1; go_l=1; inA=3'd0;

	@(posedge clk);
	$display($stime,,"go_l=%b, done=%b, inA=%d, sum=%d", go_l, done, inA,sum);
	go_l=0;
	@(posedge clk);
	$display($stime,,"go_l=%b, done=%b, inA=%d, sum=%d", go_l, done, inA,sum);
	go_l=0; inA=7;

	@(posedge clk);
	$display($stime,,"go_l=%b, done=%b, inA=%d, sum=%d", go_l, done, inA,sum);
	inA=3;

	@(posedge clk);
	$display($stime,,"go_l=%b, done=%b, inA=%d, sum=%d", go_l, done, inA,sum);

	@(posedge clk);
	$display($stime,,"go_l=%b, done=%b, inA=%d, sum=%d", go_l, done, inA,sum);
	
	$finish;
end

endmodule: tb_prob7

module top;

	logic [3:0] inA, sum, addOut;
	bit reset_l, cl_l,ld_l,clk,inAeq, go_l, done;
	
	fsm_mealy mealy(.*);
//	fsm_D fsm(.*);
	comparator comp(.*);
	adder add(.*);
	register sum_reg(.*);
	tb_prob7 tb(.*);

endmodule: top
