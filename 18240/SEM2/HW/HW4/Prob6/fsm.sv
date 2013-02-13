module fsm
 #(parameter w = 30)
(input logic clk, reset,
  input logic d_in_ready, lowBit,
  input logic [$clog2(w)-1:0] BCount,
  output logic Cclr, Cinc, Oclr, Oinc, load, d_out_ready);

enum logic [4:0] {I = 5'd0, F1 = 5'd1, F2 = 5'd2, F3 = 5'd3, F4= 5'd4, F5 = 5'd5,
		F6 = 5'd6, F7 = 5'd7, F8 = 5'd8, F9 = 5'd9,F10 = 5'd10,
		F11 = 5'd11, F12 = 5'd12, F13 = 5'd13, F14 = 5'd14, F15 = 5'd15,
		F16 = 5'd16, F17 = 5'd17, F18 = 5'd18, F19 = 5'd19, F20 = 5'd20,
		F21 = 5'd21,F22 = 5'd22, F23 = 5'd23, F24 = 5'd24, F25 = 5'd25,
		F26 = 5'd26, F27 = 5'd27, F28 = 5'd28, F29 = 5'd29,F30 = 5'd30, 
		D = 5'd31} curr, nxt;
	always_comb begin
	  Cinc = 0; Cclr = 0; Oinc = 0; Oclr = 0; d_out_ready = 0;
	  case (curr)
	    I: begin 
		if (!d_in_ready)
		  nxt<=curr;
		else begin
		  Cclr = 1; load = 1; Oclr = 1;
		  nxt<=F1;
		   end 
	       end
	   F1:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F2;
	      end
	   F2:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F3;
	      end
	   F3:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F4;
	      end
	   F4:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F5;
	      end
	   F5:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F6;
	      end
	   F6:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F7;
	      end
	   F7:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F8;
	      end
	   F8:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F9;
	      end
	   F9:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F10;
	      end
	   F10:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F11;
	      end
	   F11:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F12;
	      end
	   F12:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F13;
	      end
	   F13:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F14;
	      end
	   F14:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F15;
	      end
	   F15:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F16;
	      end
	   F16:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F17;
	      end
	   F17:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F18;
	      end
	   F18:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F19;
	      end
	   F19:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F20;
	      end
	   F20:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F21;
	      end
	   F21:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F22;
	      end
	   F22:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F23;
	      end
	   F23:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F24;
	      end
	   F24:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F25;
	      end
	   F25:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F26;
	      end
	   F26:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F27;
	      end
	   F27:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F28;
	      end
	   F28:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F29;
	      end
	   F29:begin
		Cinc =1;
		if(lowBit)begin
		  Oinc = 1;
		 end
		nxt<=F30;
	      end
	   F30:begin
		if(lowBit)begin
		  Oinc = 1;
		 end
		d_out_ready = 1;
		nxt<=I;
	      end
   endcase
end
always_ff @(posedge clk, negedge reset)
	begin
	  if(~reset) curr<=I;
	  else curr <= nxt;
	end

endmodule: fsm
