`default_nettype none

//EXTRA MODULES/*{{{*/

module crcCalc16 (input bit in,clk, rst_L,
		output bit [15:0] out);	
	bit [15:0] poly;
	
	assign out = poly;	

	always_ff @(posedge clk, negedge rst_L) begin
		if(~rst_L)
			poly <= 16'hFFFF;
		else begin
			poly[15] <= poly[14]^in^poly[15];
			poly[14] <= poly[13];
			poly[13] <= poly[12];
			poly[12] <= poly[11];
			poly[11] <= poly[10];
			poly[10] <= poly[9];
			poly[9] <= poly[8];
			poly[8] <= poly[7];
			poly[7] <= poly[6];
			poly[6] <= poly[5];
			poly[5] <= poly[4];
			poly[4] <= poly[3];
			poly[3] <= poly[2];
			poly[2] <= poly[15]^poly[1]^in;
			poly[1] <= poly[0];
			poly[0] <= in ^ poly[15];
		end			
	end
endmodule : crcCalc16

module counter 
			#(parameter W = 5) 
			(input bit enable, clear, clk, rst_L,
				output bit [W-1:0] count);

	always_ff @(posedge clk, negedge rst_L) begin
		if(~rst_L | clear)	count <= 'b0;
		else if(enable)	count <= count + 1;
		else 		count <= count;
	end	
endmodule : counter

module mux2 (input bit in1, in2, sel,
							output bit out);
	assign out = (sel) ? in2 : in1;
endmodule : mux2

module register(input bit inBit,ld_reg, clk, rst_L,
								output bit outBit);
	always_ff @(posedge clk, negedge rst_L) begin
		if (~rst_L) begin
            outBit <= 1;
            end
		else if (ld_reg) outBit <= inBit;
		else outBit <= outBit;
        end
endmodule : register

module PISO_register
		#(parameter W = 4)	
			(input bit [W-1:0] in,
			input bit load, shift, clk,rst_L,
			 output bit out);

	bit [W-2:0] memory;
	
	always_ff @(posedge clk, negedge rst_L) begin
			if(~rst_L) begin
					memory <='d0;
					out <= 'd0;
			end
			else if (load) begin
					memory <= in[W-2:0];
					out <= in[W-1];
			end
			else if (shift) begin
					memory <= memory << 1;
					out <= memory[W-2];
			end
			else begin
					memory <= memory;
					out <= memory[W-2];
			end
	end
endmodule : PISO_register
/*
module SIPO_register 
    (input bit in, stall, shift,clk, rst_L,                                                                                                                                                      
     output bit[7:0] out);
     always_ff @(posedge clk, negedge rst_L) begin
        if(~rst_L) begin
              out<= 64'd0;
        end
        else if (stall)
              out<=out;
        else if(shift) begin
*/

module SIPO_register 
   #(parameter W = 64)
   (input bit in, shift,clk, rst_L,
	output bit[W-1:0] out);
	
	always_ff @(posedge clk, negedge rst_L) begin
			if(~rst_L) begin
					out<= 'd0;
			end
			else if(shift) begin
					out <= out<<1;
					out[0] <= in;
			end
			else
					out<=out;
	end
endmodule : SIPO_register/*}}}*/

//CRC16 {{{
module crc16Sender (input bit in, clk, rst_L,
		  						output bit bit_out);

	bit [6:0] count;
	bit [15:0] crc_out;
	bit crc_in, en_count,cl_count, 
			en_shift, ld_piso,
			piso_out, sel;
		
	crcCalc16 crc16(.in(crc_in), .out(crc_out),.*);
	
	PISO_register #(15) remainder_reg(.in(~crc_out[14:0]), .out(piso_out),
												.shift(en_shift), .load(ld_piso), .*);

	counter #(7) c(.enable(en_count),.clear(cl_count),.*);

	enum bit [1:0] {IDLE, MESSAGE, REMAINDER} nxt, curr;
	
	assign crc_in = (count == (7'd64)) ? (~crc_out[15]) : ((sel) ? piso_out : in);
	assign bit_out = crc_in;
	assign ld_piso = (count == (7'd64));

	always_ff @(posedge clk, negedge rst_L) begin
			if (~rst_L) curr <= MESSAGE;
			else curr <= nxt;
	end
	
	always_comb begin
				case (curr)
					IDLE: begin 
						{en_shift,sel} = 2'd0;
						{en_count,cl_count} =2'b01;
						nxt = curr;
					end
					MESSAGE: begin
						{en_shift,sel} = 2'd0;
						{en_count,cl_count} =2'b10;
						nxt = (count == (7'd64)) ? REMAINDER : curr;
					end
					REMAINDER:begin
						{en_shift, sel} = 2'b11;
						{en_count,cl_count} =2'b10;
						nxt = (count == (7'd80)) ? IDLE : curr;
					end
				endcase
	end
endmodule : crc16Sender/*}}}*/

module crcReceiver (input bit bit_in, clk, rst_L,/*{{{*/
										output bit done, ok,
										output bit [63:0] messageReceived);
	
	bit en_count, en_shift;
	bit [7:0] count; 
	bit [15:0] crc_out;

	crcCalc16 crc(.in(bit_in), .out(crc_out), .*);
	counter #(8) c(.enable(en_count),.clear(),.*);
	SIPO_register #(64) message_reg(.in(bit_in), .shift(en_shift), 
														.out(messageReceived), .*);
	
	enum bit [1:0] {IDLE, MESSAGE} nxt,curr;
	
	assign done = ((count == 8'd80));
	assign ok = (count == 8'd80) ? (crc_out == 16'b1000_0000_0000_1101) : 0;
	
	always_ff @(posedge clk, negedge rst_L) begin
		if (~rst_L) curr <= MESSAGE;
		else curr <= nxt;
	end

	always_comb begin
		case (curr) 
			IDLE:begin
				{en_shift,en_count} = 2'b01;
				nxt = curr;
			end
			MESSAGE:begin
				{en_shift, en_count}  = 2'b11;
				nxt = (count == 8'd63) ? IDLE : curr;  //14 or 10
			end
		endcase
	end
endmodule : crcReceiver/*}}}*/

module top;

	bit clk, rst_L;
	bit in_message, transBit;
	bit done, ok;
	bit [63:0] messageReceived, send;
	bit [7:0]	i;
	
	crc16Sender s(.in(in_message), .bit_out(transBit),.*);
	crcReceiver r(.bit_in(transBit),.*);
	
	initial begin
		#5 clk = 0; rst_L <= 1;
		forever #10 clk = ~clk;
	end
	
	task sendMessage(bit [63:0] message);
			@(posedge clk);
			rst_L <= 0;
			@(posedge clk);
			rst_L <= 1;
			for(i =0; i<64; i++) begin
					in_message <= message[63-i];
					@(posedge clk);
			end
			repeat(20)@(posedge clk);
	endtask

	initial begin
			$monitor($stime,,"messageReceived: %X, done: %b, ok: %b", messageReceived, done, ok);
			sendMessage(64'hcafebabedeadbeef);
			$finish;
	end
endmodule : top
