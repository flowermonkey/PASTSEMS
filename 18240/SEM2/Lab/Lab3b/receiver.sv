module receiver(
	input logic clk, serial_in,
	output logic [7:0] message_byte,
	output logic is_new);

logic clr_SIPO, en_SIPO, ld_A, clr_A,twoerr;
logic up_cA, en_cA, clr_cA, ld_cA ,sel;
logic up_cB, en_cB, clr_cB, ld_cB;
logic eqto1, eqto10, eqto13,eqto0;
logic [12:0] msg, dec_msg;
logic [3:0] inp_cA,countA, inp_cB, countB;
logic [7:0] d_msg, ld_msg;

assign d_msg = {dec_msg[12],dec_msg[11],dec_msg[10],dec_msg[9],dec_msg[7],
				 dec_msg[6],dec_msg[5],dec_msg[3]};

shift_register_SIPO #(13) SIPO(serial_in, clk,clr_SIPO,en_SIPO, msg);
secdeddecoder secded(msg,,, twoerr, dec_msg);
mux #(8) m(d_msg,8'h15,sel, ld_msg);
register #(8) A(clk, ld_A, clr_A, ld_msg,message_byte);
counter #(4) counterA(clk, up_cA, en_cA, clr_cA,ld_cA,inp_cA,countA),
 			 counterB(clk, up_cB, en_cB, clr_cB,ld_cB,inp_cB,countB);
comparator #(1) compto1(serial_in,1'b1,,eqto1,),
				compto0(serial_in,1'b0,,eqto0,);
comparator #(4)	compto13(countA,4'd13,,eqto13,),
				compto10(countB,4'd10,,eqto10,);
fsm f(.*);
endmodule: receiver
