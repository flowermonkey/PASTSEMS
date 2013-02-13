module fsm(
	input logic clk, twoerr, eqto0, eqto1, eqto13, eqto10,
	input logic [3:0] countA, countB,
	input logic [7:0] message_byte,
	output logic clr_SIPO, en_SIPO,sel, ld_A, clr_A, up_cA, up_cB,
	en_cA,en_cB, clr_cA, clr_cB, ld_cA, ld_cB, is_new,
	output logic [3:0] inp_cA, inp_cB);

enum logic [1:0] {I=2'd0,A=2'd1,B=2'd2} curr, nxt;
///////////////////////////////////////////////////
always_comb begin
en_cB=0;en_cA=0;is_new=0;up_cB=1; up_cA=1;clr_cB=1;clr_cA=1;ld_A=0;en_SIPO=0;
	case(curr)
	I:begin
		if(eqto0 && !eqto10)begin
			clr_cB=0; en_cB=1;
			end
		else if (eqto10 && eqto0)begin
			sel=1;ld_A=1;
			end
	end
	
	A:begin
		if (countA!=4'd13)begin
			clr_cA=0; en_cA=1;en_SIPO=1;
			end
		else if((~eqto0 || twoerr)&&eqto13)begin
			ld_A=1; sel=1;
			end
		else if (eqto0&&~twoerr&&eqto13)begin
			clr_cA=1; ld_A=1; sel=0;
			end
	end

	B:begin is_new=1;
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
nxt=I;
case(curr)
	I:begin
		if(eqto0 && !eqto10)
			nxt=I;
		else if (eqto10 && eqto1)
			nxt=B;
		else if (eqto1)
			nxt=A;
		else
			nxt=curr;
	end
	A:begin
		if(countA!=4'd13)
			nxt=A;
		else if(((~eqto0 || twoerr)&&eqto13)||(eqto0&&~twoerr&&eqto13))
			nxt=B;
		else
			nxt=curr;
	end

	B:nxt=I;

	endcase
end
//////////////////////////////////////////////////
endmodule: fsm
