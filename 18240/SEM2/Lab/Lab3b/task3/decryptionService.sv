module decryptionService(
	input logic clk, reset, serial_in,
	output logic [63:0] message_bytes,
	output logic new_message);
	
	
logic [3:0] countA;
logic is_new, keybit,ld_key,clr_key,ld_keyshift,en_keyshift,eqto8,less5,up, en_counter, clr_counter,clr_message, en_message;
logic [7:0] recmsg, bytemsg, keymsg, keymsg_in, key, added_byte, decrypt_byte;

//modules in use:
receiver rec(clk, serial_in, recmsg, is_new); // receives messages 
dmux d(recmsg,less5,keymsg_in, bytemsg); //chooses which key message to use
muxulator notdmux(keymsg_in, keymsg); //chooses what incoming message is a key or not
register #(8)	 keyreg(clk, ld_key, clr_key, keymsg, key); // register that holds key
shift_register_PISO #(8) piso(keymsg,clk,ld_keyshift,en_keyshift,keybit);//shifts key bits
comparator #(4) compto8(countA,4'd8,,eqto8,);
comparator #(8)	compto5(recmsg,8'd5,less5,,);
counter #(4) counterA(clk, up, en_counter, clr_counter,,,countA);
mux #(8) m(added_byte,(key^bytemsg),keybit, decrypt_byte);//chooses which operated message to add to register: added or xor'd
adder #(8) add(key, bytemsg,1'b0,added_byte,);
byte_shift_register pipo(decrypt_byte, clk,clr_message,en_message,message_bytes); // holds 8 bytes for output
fsm_task3 fsm(.*);

endmodule: decryptionService

//additional modules 

module muxulator(input logic [7:0] sel, 
			output logic [7:0] dmuxmsg);
always_comb begin
	case(sel)
		8'd0: dmuxmsg = 8'd0;
		8'd1: dmuxmsg = 8'b1010_0101;
		8'd2: dmuxmsg = 8'b0000_1111;
		8'd3: dmuxmsg = 8'b1111_0000;
		8'd4: dmuxmsg = 8'b1000_0111;
		default: dmuxmsg = 8'd1;
	endcase
  end
endmodule: muxulator

module dmux(input logic [7:0] msg_in, 
			input logic sel,
			output logic [7:0]msg_out1, msg_out2);

always_comb begin
	if(sel)begin
		msg_out1 = msg_in;
		msg_out2 = 0;
	  end 
	else begin
		msg_out2 = msg_in;
		msg_out1 = 6;
	  end
  end
endmodule: dmux

module byte_shift_register (
	input logic [7:0] inpbyte,
	input logic clk, clr, en,
	output logic [63:0] message);

always_ff @(posedge clk) begin
	if(clr)
		message<=64'd0;
	else if(en) begin
		message <= message<<8;
		message[7:0] <= inpbyte;
	end
	else 
		message <= message;
	end
endmodule: byte_shift_register
