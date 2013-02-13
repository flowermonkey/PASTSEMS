/****************
*  Brian Flores *
*  Logic Design *
*  Project 1    * 
***************/

module priQueue
	#(parameter W = 8)
		(input bit[W-1:0] newVal,
 			input bit ck,r,clear,loadIn,shiftOut,
 			output bit [W-1:0] top);

//variables
	logic [2:0] count;
	bit [W-1:0] r1_in, r1_out,
			r2_in, r2_out,
			r3_in, r3_out,
			r4_in, r4_out,
			r5_in, r5_out,
			r6_in, r6_out;

//instantiations of modules
	register r1(r1_in, loadIn, ck, ~r, clear, r1_out),
					 r2(r2_in, loadIn, ck, ~r, clear, r2_out),
					 r3(r3_in, loadIn, ck, ~r, clear, r3_out),
					 r4(r4_in, loadIn, ck, ~r, clear, r4_out),
					 r5(r5_in, loadIn, ck, ~r, clear, r5_out),
					 r6(r6_in, loadIn, ck, ~r, clear, r6_out);

	counter c1((~clear & ~loadIn & shiftOut),ck,~r,clear,count);

//Combinational logic will insert values correctly into pq
	always_comb begin
	//gauntees that shiftOut will not have priority over other ctl pts
		if (~clear & ~loadIn & shiftOut)			
			//based on count value, give top the values in registers from
			//greatest to lowest
			case (count)
				'd0: top = r1_out;
				'd1: top = r2_out;
				'd2: top = r3_out;
				'd3: top = r4_out;
				'd4: top = r5_out;
				'd5: top = r6_out;
				default: begin
						top=0;
				end
			endcase
	//when count is zero, no shifting is occurring so top is always
	//greatest value (r1 value)
		else if(count==0)
				top=r1_out;
	//when count is not zero and shiftOut is not asserted, assume all
	//values have been shifted out and top is always 0
		else 
				top=0;

	//case statement for the shifting of values in pq registers during the
	//insertion of a newVal
	//General Concept: r1 has highest value, r2 second highest and so on.
	// New values will bump other values down if they are greater 
		casex({(newVal>r1_out),
					(newVal>r2_out),
					(newVal>r3_out),
					(newVal>r4_out),
					(newVal>r5_out),
					(newVal>r6_out)})
			6'b1xxxxx: begin
				r1_in<=newVal; r2_in <= r1_out; r3_in<=r2_out;
				r4_in<=r3_out; r5_in<=r4_out; r6_in<=r5_out;
			end
			6'bx1xxxx:  begin
				r2_in<=newVal; r1_in<= r1_out; r3_in<=r2_out; 
				r4_in<=r3_out; r5_in<=r4_out; r6_in<=r5_out;
			end
			6'bxx1xxx:  begin
				r3_in<=newVal; r1_in<= r1_out; r2_in<=r2_out;
				r4_in<=r3_out; r5_in<=r4_out; r6_in<=r5_out;
			end
			6'bxxx1xx:  begin
				r4_in<=newVal; r1_in<= r1_out; r2_in<=r2_out;
				r3_in<=r3_out; r5_in<=r4_out; r6_in<=r5_out;
			end
			6'bxxxx1x:  begin
				r5_in<=newVal; r1_in<= r1_out; r2_in<=r2_out;
				r3_in<=r3_out; r4_in<=r4_out; r6_in<=r5_out;
			end
			6'bxxxxx1:  begin
				r6_in<=newVal; r1_in<= r1_out; r2_in<=r2_out;
				r3_in<=r3_out; r4_in<=r4_out; r5_in<=r5_out;
			end
			default:   begin
				r1_in<= r1_out; r2_in<= r2_out; r3_in<=r3_out;
				r4_in<=r4_out; r5_in<=r5_out; r6_in<=r6_out;
			end
		endcase
		end
endmodule: priQueue

//Clock-based Register 
module register
	#(parameter W = 8)
		(input logic [W-1:0] in,
		 input bit load,clk,reset_L, clear,
		 output logic [W-1:0] out);

//active on a clk or reset_L for sync and async functionality
	always_ff @ (posedge clk, negedge reset_L) begin
		if (~reset_L | clear)
			out <= 'h00;
		else if (load)
			out <= in;
	end
endmodule: register

//Clock-based 3-bit counter
module counter 
		(input bit enable,clk, reset_L,clear,
		 output logic [2:0] count);

//active on a clk or reset_L for sync and async functionality
	always_ff @ (posedge clk, negedge reset_L)
		if(~reset_L | clear) 
			count = 0;
		else if (enable)
			count <= count+1;
		else if (count==7)
			count <= 7;
endmodule: counter
