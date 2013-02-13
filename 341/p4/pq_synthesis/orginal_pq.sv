/****************
*  Brian Flores *
*  Logic Design *
*  Project 1    * 
***************/
//`default_nettype none

module priQueue
	#(parameter W = 8)
		(input bit[W-1:0] newVal,
 			input bit ck,r,clear,loadIn,shiftOut,
 			output bit [W-1:0] top);

//variables
	bit load;
	bit [1:0] sel1, sel2, sel3, sel4, sel5, sel6;
	bit [W-1:0] zero, r1_out,
							r2_out,r3_out,
							r4_out,r5_out,
							r6_out;
	bit [W-1:0] m1_out,m2_out,m3_out,
							m4_out,m5_out,m6_out;
//instantiations of modules
	
	mux #(W)			m1(newVal, zero,   r2_out, r1_out, sel1, m1_out),
								m2(newVal, r1_out, r3_out, r2_out, sel2, m2_out),
								m3(newVal, r2_out, r4_out, r3_out, sel3, m3_out),
								m4(newVal, r3_out, r5_out, r4_out, sel4, m4_out),
								m5(newVal, r4_out, r6_out, r5_out, sel5, m5_out),
								m6(newVal, r5_out, zero,   r6_out, sel6, m6_out);

 	register #(W) 		r1(m1_out, clear, load, ck, ~r, r1_out),
										r2(m2_out, clear, load, ck, ~r, r2_out),
					 					r3(m3_out, clear, load, ck, ~r, r3_out),
					 					r4(m4_out, clear, load, ck, ~r, r4_out),
					 					r5(m5_out, clear, load, ck, ~r, r5_out),
						 				r6(m6_out, clear, load, ck, ~r, r6_out);	

 /*	mux_register #(W) r1(newVal, zero,   r2_out, r1_out, clear, load, ck, ~r, sel1, r1_out),
										r2(newVal, r1_out, r3_out, r2_out, clear, load, ck, ~r, sel2, r2_out),
					 					r3(newVal, r2_out, r4_out, r3_out, clear, load, ck, ~r, sel3, r3_out),
					 					r4(newVal, r3_out, r5_out, r4_out, clear, load, ck, ~r, sel4, r4_out),
					 					r5(newVal, r4_out, r6_out, r5_out, clear, load, ck, ~r, sel5, r5_out),
						 				r6(newVal, r5_out, zero,   r6_out, clear, load, ck, ~r, sel6, r6_out);	
*/
	assign zero = 0;
	assign top = r1_out;
	assign load = (shiftOut | loadIn);
	
//Combinational logic will insert values correctly into pq
	always_comb begin
	//gauntees that shiftOut will not have priority over other ctl pts
		if (~clear & ~loadIn & shiftOut)			
			 {sel1,sel2,sel3,sel4,sel5,sel6}= 12'hAAA; 
	//case statement for the shifting of values in pq registers during the
	//insertion of a newVal
		else begin	
				case({(newVal>top),
						(newVal>r2_out),
						(newVal>r3_out),
						(newVal>r4_out),
						(newVal>r5_out),
						(newVal>r6_out)})
				6'b111111: begin
					sel1 = 2'b00; 
					{sel2,sel3,sel4,sel5,sel6} = 10'b0101010101;
				end
				6'b011111:  begin
				  sel1 = 2'b11; 
					sel2 = 2'b00; 
					{sel3,sel4,sel5,sel6} = 8'b01010101;
				end
				6'b001111:  begin
				  {sel1,sel2}= 4'b1111; 
					sel3 = 2'b00; 
					{sel4,sel5,sel6} = 6'b010101;
				end
				6'b000111:  begin
				  {sel1,sel2,sel3}= 6'b111111; 
					sel4 = 2'b00; 
					{sel5,sel6} = 4'b0101;
				end
				6'b000011:  begin
				  {sel1,sel2,sel3,sel4}= 8'b11111111; 
					sel5 = 2'b00; 
					sel6 = 2'b01;
				end
				6'b000001:  begin
				  {sel1,sel2,sel3,sel4,sel5}= 10'b1111111111; 
					sel6 = 2'b00; 
				end
				default:   begin
				  {sel1,sel2,sel3,sel4,sel5,sel6}= 12'hFFF; 
				end
			endcase
		end
	end
endmodule: priQueue

//Clock-based 4to1 Mux_Register 
module register
	#(parameter W = 8)
		(input bit [W-1:0] in1,
		 input bit clear,load,ck,r,
		 output logic [W-1:0] out);

//active on a clk or reset_L for sync and async functionality
	always_ff @ (posedge ck, negedge r) begin
		if (~r) 				out <= 'h00;
		else if (clear) out <= 'h00;
		else if (load)	out <= in1;
	end
endmodule: register 

module mux
	#(parameter W = 8)
		(input bit [W-1:0] in1, in2, in3, in4,
		 input bit [1:0] sel,
		 output bit [W-1:0] out);
	always_comb
		unique case (sel) 
				2'b00: out <= in1;
				2'b01: out <= in2;
				2'b10: out <= in3;
				2'b11: out <= in4;
		endcase
endmodule : mux

/*
//Clock-based 4to1 Mux_Register 
module mux_register
	#(parameter W = 8)
		(input bit [W-1:0] in1,in2,in3,in4,
		 input bit clear,load,ck,r,
		 input bit [1:0] sel,
		 output logic [W-1:0] out);

//active on a clk or reset_L for sync and async functionality
	always_ff @ (posedge ck, negedge r) begin
		if (~r) out <= 'h00;
		else if (clear) out <= 'h00;
		else if (load)
				unique case (sel) 
					2'b00: out <= in1;
					2'b01: out <= in2;
					2'b10: out <= in3;
					2'b11: out <= in4;
				endcase 
	end
endmodule: mux_register */
