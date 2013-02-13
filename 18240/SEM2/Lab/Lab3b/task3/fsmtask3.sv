module fsm_task3(
	input logic clk, is_new, eqto8,less5,
	input logic [7:0] key,
	output logic ld_keyshift,en_keyshift, ld_key,clr_key, en_counter,clr_counter,up, clr_message, en_message,new_message);

enum logic {I='d0,A='d1} curr, nxt;

always_comb begin
//setting initial conditions
en_keyshift=0; ld_keyshift=0;
ld_key=0;clr_key=0;
clr_message=0;en_message=0; 
new_message=0; 
up=1; en_counter=0;

	case(curr)
//Indle State: clear the counter and message while waiting for new message
//from reciever
	I:begin
	if (~is_new)begin           //I->I
		clr_counter=1;clr_message=1;
		end
//Once new message is received check to see if it is less than 5, at which
//case it is a valid key 
	else if(is_new&&less5)
		begin					//I->A
		ld_key=1;
		ld_keyshift=1;
		clr_counter =0;
		end
	end
//State A: with every new byte message: 
//enable the shift_register with Key message to shift out the nth key bit. 
//Increment the counter. 
//Enable the PIPO register to shift a byte.
	A:begin
	if (is_new) //A->A
	begin
		en_keyshift=1;
		en_message=1;
        en_counter=1;
	end
//if counter reaches 8 enable new message
	else if(eqto8)begin //A->I
		new_message=1;
		end
	end
	endcase
end


always_ff @ (posedge clk)
	begin
		curr<=nxt;
	end
//State Tranisitions
always_comb begin
nxt=I;
case(curr)
	I:begin
		if(~is_new)
			nxt=I;
		else if (is_new&&less5)
			nxt=A;
		else
			nxt=curr;
	end

	A:begin
	if(is_new)
			nxt=A;
		else if(eqto8)
			nxt=I;
		else
			nxt=curr;
	end
	endcase
end
endmodule: fsm_task3
