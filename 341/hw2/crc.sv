`default_nettype none
//EXTRA MODULES/*{{{*/
module crcCalc (input bit in,ck, rst,
		output bit [4:0] out);	
	bit [4:0] poly;
	
	assign out = poly;	

	always_ff @(posedge ck, negedge rst) begin
		if(~rst)
			poly <= 5'h1F;
		else begin
			poly[4] <= poly[3];
			poly[3] <= poly[2];
			poly[2] <= poly[4]^poly[1]^in;
			poly[1] <= poly[0];
			poly[0] <= in ^ poly[4];
		end			
	end
endmodule : crcCalc

module counter(input bit enable, ck, rst,
		output bit [4:0] count);

	always_ff @(posedge ck, negedge rst) begin
		if(~rst)	count <= 5'b0;
		else if(enable)	count <= count + 1;
		else 		count <= count;
	end	
endmodule : counter

module PISO_register(input bit [3:0] in,
										 input bit load, shift,ck,rst,
										 output bit out);
	bit [2:0] memory;
	
	always_ff @(posedge ck, negedge rst) begin
			if(~rst) begin
					memory <=4'd0;
					out <= 0;
			end
			else if (load) begin
					memory <= in[2:0];
					out <= in[3];
			end
			else if (shift) begin
					memory <= memory << 1;
					out <= memory[2];
			end
			else begin
					memory <= memory;
					out <= memory[2];
			end
	end

endmodule : PISO_register

module SIPO_register (input bit in, shift,ck, rst,
											output bit[10:0] out);
	always_ff @(posedge ck, negedge rst) begin
			if(~rst) begin
					out<= 11'd0;
			end
			else if(shift) begin
					out <= out<<1;
					out[0] <= in;
			end
			else
					out<=out;
	end
endmodule : SIPO_register/*}}}*/

module crcSender (input bit in, ck, rst,/*{{{*/
		  output bit bit_out);

	bit [4:0] count, crc_out;
	bit crc_in, en_count, 
			en_shift, ld_piso,
			piso_out, sel;
		
	crcCalc crc(.in(crc_in), .out(crc_out),.*);
	counter c(.enable(en_count),.*);
	PISO_register remainder_reg(.in(~crc_out[3:0]), .out(piso_out),
												.shift(en_shift), .load(ld_piso), .*);

	enum bit [1:0] {IDLE, MESSAGE, REMAINDER} nxt, curr;
	
	assign crc_in = (count == 5'd11) ? (~crc_out[4]) : ((sel) ? piso_out : in);
	assign bit_out = crc_in;
//	assign bit_out = crc_out[4];
	//	assign bit_out = (count == 5'd11) ? (~crc_out[4]) : ((sel) ? piso_out : crc_out[4]);
	assign ld_piso = (count == 5'd11);

	always_ff @(posedge ck, negedge rst) begin
		if (~rst) curr <= MESSAGE;
		else curr <= nxt;
	end
	
	always_comb begin
		case (curr)
			IDLE: begin 
				{en_shift,sel} = 2'd0;
				en_count =1'd0;
				nxt = curr;
			end
			MESSAGE: begin
				{en_shift,sel} = 2'd0;
				en_count = 1'b1;
				nxt = (count == 5'd11) ? REMAINDER : curr;
			end
			REMAINDER:begin
				{en_shift, sel} = 2'b11;
				en_count = 1'b1;
				nxt = (count == 5'd16) ? IDLE : curr;
			end
		endcase
	end
endmodule : crcSender/*}}}*/

module crcReceiver (input bit bit_in, ck, rst,/*{{{*/
										output bit done, ok,
										output bit [10:0] messageReceived);
	
	bit en_count, en_shift;
	bit [4:0] count, crc_out;

	crcCalc crc(.in(bit_in), .out(crc_out), .*);
	counter c(.enable(en_count),.*);
	SIPO_register message_reg(.in(bit_in), .shift(en_shift), 
														.out(messageReceived), .*);
	
	enum bit [1:0] {IDLE, MESSAGE} nxt,curr;
	
	assign done = ((count == 5'd16));
	assign ok = (count == 5'd16) ? (crc_out == 5'b01100) : 0;
	
	always_ff @(posedge ck, negedge rst) begin
		if (~rst) curr <= MESSAGE;
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
				nxt = (count == 5'd10) ? IDLE : curr;  //14 or 10
			end
		endcase
	end
endmodule : crcReceiver/*}}}*/

module top;

	bit ck, rst;
	bit in_message, transBit;
	bit done, ok;
	bit [10:0] messageReceived, send;
	bit [3:0]	i;
	
	crcSender s(.in(in_message), .bit_out(transBit),.*);
	crcReceiver r(.bit_in(transBit),.*);
	
	initial begin
		#5 ck = 0; rst <= 1;
		forever #10 ck = ~ck;
	end
	
	task sendMessage(bit [10:0] message);
			@(posedge ck);
			rst <= 0;
			@(posedge ck);
			rst <= 1;
			for(i =0; i<11; i++) begin
					in_message <= message[10-i];
					@(posedge ck);
			end
			repeat(10)@(posedge ck);
	endtask

	initial begin
			$monitor($stime,,"messageReceived: %b, done: %b, ok: %b", messageReceived, done, ok);
			sendMessage(11'b1010000_0010);
			sendMessage(11'b0000_1000_111);
			sendMessage(11'b1010_1000_111);
			@(posedge ck);
			send <= 11'b0101_1100_101;
			rst <= 0;
			@(posedge ck);
			rst <= 1;
			for(i =0; i<11; i++) begin
					in_message <= send[10-i];
					@(posedge ck);
			end
		  force transBit = 1'b0;
			repeat(2)@(posedge ck);
			release transBit;
			repeat(8)@(posedge ck);
			$finish;
	end
endmodule : top
