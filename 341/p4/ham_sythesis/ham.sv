/*********************
* Brian Flores       *
* bflores            *
* Project 4          *
* Hamming Decoder    *
*********************/

//`default_nettype none

module ham_decoder(input bit [6:0] message,
										output bit [6:0] correctMessage);
	bit p1,p2,p4;
	bit [2:0] error;


	always_comb begin
		p1 = ^({message[2],message[4],message[6]});
		p2 = ^({message[2],message[5],message[6]});
		p4 = ^({message[4],message[5],message[6]});
		error = {message[3],message[1],message[0]} ^ {p4,p2,p1};
		correctMessage = message;

		if(error!=3'd0)
				correctMessage[error-1] = message[error-1]^1;
		else
				correctMessage = message;
	end
endmodule: ham_decoder
/*
module top;

	bit [6:0] message, correctMessage,i;
	bit clk;
	
	ham_decoder md(.*);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	initial begin
		message = 7'b0;
		for(i=0;i<7'b1111111; i++)
			@(posedge clk) message = i;
		@(posedge clk) message = i;
		@(posedge clk) $finish;
	end

	property checkTheCheck();	
		@(posedge clk)
		( message < 8'b10000000 ) |-> (correctMessage == 7'b0000000) or
		(correctMessage == 7'b0000111) or (correctMessage == 7'b0011001) or
		(correctMessage == 7'b0011110) or (correctMessage == 7'b0101010) or
		(correctMessage == 7'b0101101) or (correctMessage == 7'b0110011) or
		(correctMessage == 7'b0110100) or (correctMessage == 7'b1001011) or
		(correctMessage == 7'b1001100) or (correctMessage == 7'b1010010) or
		(correctMessage == 7'b1010101) or (correctMessage == 7'b1100001) or
		(correctMessage == 7'b1100110) or (correctMessage == 7'b1111000) or
    (correctMessage == 7'b1111111);
	endproperty 
	
	assert property (checkTheCheck)
		$display("message correctly decoded :)");
		else $display("outputed message is not one of the possible codes!");

endmodule : top */
