typedef enum bit [3:0] {NONE, NUMBER, PLUS, MINUS, EQUALS, NEGATE, LP, RP, CLEAR} keyOp_t;

typedef struct packed {
keyOp_t op; //operation key hit
bit [7:0] num; //data key hit (0-9)
} keyStroke_t;

module tiCalc
(input keyStroke_t keyIn,
 input bit rst_b, clk,
 output bit [7:0]  display,
 output bit  error);

//Wires
logic push,pop,empty,two_num;
logic load, ld_alu_1,ld_alu_2,clr_alu,ld_result;
logic clr_op,ld_op, sel_add,negate, overflow;
logic [2:0] sel_1, sel_2,sel_3,sel_4;
logic [3:0] op_out;
logic [7:0] new_value,out_alu_1,out_alu_2,out_result,
			mux1_out,mux3_out,mux4_out, stack_out;
logic [7:0] reg0_in,reg1_in,reg2_in,reg3_in,
			reg4_in,reg5_in,reg6_in,reg7_in,
			reg0_out,reg1_out,reg2_out,reg3_out,
			reg4_out,reg5_out,reg6_out,reg7_out;
logic [11:0] in;

//Modules

//calc_fsm controls the change of states of the calculator
//outputs display and error, as well as all other control points
calc_fsm calc(.*);


//regular registers the make up the stack
//intentionally do not have a clear control bit
register #(8) reg0(clk, load,reg0_in ,reg0_out),
			reg1(clk, load,reg1_in ,reg1_out),
			reg2(clk, load,reg2_in ,reg2_out),
			reg3(clk, load,reg3_in ,reg3_out),
			reg4(clk, load,reg4_in ,reg4_out),
			reg5(clk, load,reg5_in ,reg5_out),
			reg6(clk, load,reg6_in ,reg6_out),
			reg7(clk, load,reg7_in ,reg7_out);

//registers that hold values that will enter the ALU of the system
//includes a clear bit for reset to -1
alu_reg #(8) alu_reg_1(clk, clr_alu, ld_alu_1, mux3_out, out_alu_1),
		 	alu_reg_2(clk,clr_alu, ld_alu_2, mux4_out, out_alu_2);
			
//Input register to system. 
//Holds the 12 bit value of keyIn
register #(12) input_reg(clk, ld_input, keyIn, in);

//Operation register of system holds the previous operation 
//processed by the system
register #(4) op_reg(clk, ld_op,in[11:8], op_out);

//4-to-1 8-bit mutiplexors 
mux_4 #(8) mux1 (in[7:0],stack_out,new_value,out_alu_1,sel_1,mux1_out),
       	   mux2 (in[7:0],stack_out,new_value,,sel_2,display),
       	   mux3 (in[7:0],stack_out,new_value,,sel_3,mux3_out),
       	   mux4 (in[7:0],stack_out,new_value,,sel_4,mux4_out);

//comparator used to tell if both alu registers hold values
comparator #(8) comp(out_alu_1, out_alu_2,two_num);

//ALU that is able to add (A+B), subtract (A-B) and negate (only A) values given.
alu #(8) mini_alu(out_alu_1, out_alu_2,sel_add,negate,new_value,overflow);

//A stack of eight 8-bit registers.
stack #(8) reg_stack(mux1_out, clk, push, pop, empty,
			reg0_out, reg1_out, reg2_out, reg3_out, reg4_out,
			reg5_out,reg6_out, reg7_out,
			reg0_in, reg1_in, reg2_in, reg3_in, reg4_in,
			reg5_in,reg6_in,reg7_in, stack_out);

endmodule: tiCalc
/*///////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Module Library

////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

module calc_fsm(
	input logic clk,rst_b,overflow,two_num,
	input logic [3:0] op_out,
	input logic [7:0] out_alu_1,out_alu_2,
	input keyStroke_t keyIn,
	input logic [11:0] in,
	output logic [2:0] sel_1,sel_2,sel_3,sel_4,
	output logic sel_add,negate,load,ld_alu_1,ld_alu_2,
				ld_input, ld_op,clr_op,error,push,pop,empty,clr_alu);

enum logic [2:0]{Sleep=3'd0,Get_Num=3'd1, Operation= 3'd2, Error=3'd3} curr, nxt;

///////////////////////////////////////////////////
always_comb begin
	{sel_1,sel_2,sel_3,sel_4,sel_add, negate}=5'd0; 
    load=0; clr_alu=0; ld_alu_1=0;
	ld_alu_2=0;ld_result=0; ld_input=0; ld_op =0;
	clr_op=0; error=0; push=0; pop = 0; empty=0;
	
	case(curr)
	Sleep:begin
	//load input and clear registers 
	//while waiting for a number to be entered
		ld_input=1;
		{clr_op,empty,clr_alu} = 3'b111;
	end

	Get_Num:begin
		//ALWAYS load next input
		ld_input=1;

		//SAW_NUM (first number)
		if(out_alu_1==8'hff)
			begin
			push =1; load =1;
		 	ld_alu_1=1;
			ld_op=1;
			end
		//SAW_NUM (second number)
		else if(~two_num) 
			begin
			push=1; load =1;
			ld_alu_2=1;
			end
		//SAW_NUM (third and plus)
		else begin
			//update value from before
			sel_3=1;  
			ld_alu_1=1;
			
			//update second value
			push=1; load=1;
			ld_alu_2=1;

		end
		
	end

	Operation:begin
		//ALWAYS load input and store previous operation
		ld_input=1;
		ld_op=1;
		
		//if it is not a valid entry after a number
		if((op_out==4'd1) && ((in[11:8]== 4'd1) ||(in[11:8]== 4'd6)))
			error=1;
		
		//if NEGATE
		if(in[11:8]==4'd5)begin
			negate =1;
			sel_2=2'd2;//display new_value
			sel_1=2'd2;push=1;load=1; //push into stack
			ld_alu_1 = 1; sel_3 = 2'd2;
		end

		//if PLUS
		//with alu regs NOT full
		else if((in[11:8]==4'd2) && (~two_num))begin
			sel_2=1;  //display last value
			pop=1;
			end
		//with alu regs full
		else if ((op_out==4'd2) && (two_num))begin
			sel_add=1; //add
			sel_2=2'd2;//display new_value
			sel_1=2'd2;push=1;load=1; //push into stack
		end

		//if MINUS
		//with alu regs NOT full
		else if((in[11:8]==4'd3) && (~two_num))begin
			sel_2=1; //display last value
			pop=1;
		end
		//with alu regs full
		else if((op_out==4'd3) && (two_num)) begin
			sel_2=2'd2;//display new_value
			sel_1=2'd2;push=1;load=1; //push into stack
		end
		
		//if EQUALS
		else if(in[11:8]==4'd4)begin
			if(op_out == 4'd2)
				sel_add=1;
			sel_2=2'd2;//display new_value
			sel_1=2'd2;push=1;load=1; //push into stack
		end
	
		//if CLEAR
		else if(in[11:8] == 4'd8)begin
			{clr_op,empty,clr_alu} = 3'b111;
		end

		//if LP
		else if(in[11:8] == 4'd6)begin
			//store previous numbers on stack
			sel_1=2'd3; push=1;load=1;
			
			//empty alu_registers
			clr_alu=1;
		end
		
		//if RP
		else if(in[11:8] == 4'd7)begin	
			//load result of subequation
			//and previosly stacked value
			//into alu registers
			ld_alu_1 = 1; sel_3 = 2'd2;
			ld_alu_2 = 1; sel_4 = 2'd1;
			pop=1;
			sel_2=2'd2;
			end
		
	end

	Error:begin
		error=1;
	end
	endcase
end
//////////////////////////////////////////////////
always_ff @ (posedge clk)
	begin
		curr<=nxt;
	end
//////////////////////////////////////////////////
always_comb begin
nxt=Sleep;
case(curr)
	Sleep:begin
	//if next op is NUMBER change state to Get_Num
		if(keyIn[11:8]==4'd1)
			nxt=Get_Num;
	//else remain sleeping
		else
			nxt=curr;
	end
	
	Get_Num:begin
	//if there is an invalid entering of ops
	//enter error state
	//else always jump to Operation state
		if(error)
			nxt=Error;
		else
			nxt=Operation;
	end

	Operation:begin
	//if op NUMBER comes up go to Get_Num state
	//else if EQUALS or CLEAR go to Sleep state
	//else if error go to Error state
	//else remain in Operation state
		if(keyIn[11:8]==4'd1)
			nxt=Get_Num;
		else if((keyIn[11:8]==4'd4)||(keyIn[11:8]==4'd8))
			nxt=Sleep;
		else if(error)
			nxt=Error;
		else
			nxt=curr;
	end
	
	Error: begin
	//remain in Error state till rst_b is hit	
		if(~rst_b)
			nxt=Sleep;
		else
			nxt=curr;
	end
	endcase
end
endmodule: calc_fsm

//////////////////////////////////////////////////////////////////////


module stack
 #(parameter w = 4)
 (input  logic [w-1:0] value, 	
  input logic clk, push, pop,empty,
  input logic [w-1:0] in0,in1,in2,in3,in4,in5,in6,in7,
  output logic [w-1:0] out0,out1,out2,out3,out4,out5,out6,out7,dis);

 always_ff @(posedge clk)begin
 	if(push)begin
		dis <= value;
		out0 <= value;
		out1 <= in0;
		out2 <= in1;
		out3 <= in2;
		out4 <= in3;
		out5 <= in4;
		out6 <= in5;
		out7 <= in6;
		end
	else if (pop) begin
		out7 <= 0;
		out6 <= in7;
		out5 <= in6;
		out4 <= in5;
		out3 <= in4;
		out2 <= in3;
		out1 <= in2;
		out0 <= in1;
		dis <= in0;
		end
	else if (empty)begin
		out7 <= 0;
		out6 <= 0;
		out5 <= 0;
		out4 <= 0;
		out3 <= 0;
		out2 <= 0;
		out1 <= 0;
		out0 <= 0;
		dis <= 0;
		end
	else begin
		out7 <= out7;
		out6 <= out6;
		out5 <= out5;
		out4 <= out4;
		out3 <= out3;
		out2 <= out2;
		out1 <= out1;
		out0 <= out0;
		dis <= out0;
		end
 end
endmodule: stack
/////////////////////////////////////////////////////////////////////////

module comparator 
#(parameter w = 4)
	(input logic [w-1:0] num1, num2,
	output logic two_num);

always_comb begin
	if((num1=='hff) || (num2=='hff))
		two_num=0;
	else
		two_num=1;
	end

endmodule:comparator
///////////////////////////////////////////////////////////////////

module alu
#(parameter w =4)
	(input logic [w-1:0] A, B,
	 input logic add,negate,
	 output logic [w-1:0] new_value,
	 output logic overflow);

always_comb
	if(add)
	{overflow,new_value} = A + B;
	else if(negate)begin
		new_value = ~A+1;
		overflow=0;
	end
	else
	{overflow,new_value} = A - B;

endmodule: alu
//////////////////////////////////////////////////////////////////

module mux_4
#(parameter w = 4)
	(input logic [w-1:0] in0,in1,in2,in3,
	 input logic [2:0] sel,
	 output logic [w-1:0] out);

always_comb begin
	case (sel)
	4'd0: out = in0;
	4'd1: out = in1;
	4'd2: out = in2;
	4'd3: out = in3;
	default out =0;
	endcase
  end
endmodule: mux_4
//////////////////////////////////////////////////////////////

module alu_reg
#(parameter w = 4)
	(input logic clk,clr,load,
	 input logic [w-1:0] data_in,
	 output logic [w-1:0] data_out);

always_ff @(posedge clk) begin
	if(clr)
		data_out <= 'hff;
	else if (load) 
		data_out <= data_in;
	else
		data_out <= data_out;
	end
endmodule: alu_reg
////////////////////////////////////////////////////////////////

module register
#(parameter w = 4)
	(input logic clk,load,
	 input logic [w-1:0] data_in,
	 output logic [w-1:0] data_out);

always_ff @(posedge clk) begin
if (load) 
	data_out <= data_in;
	else
	data_out <= data_out;
	end
endmodule: register
