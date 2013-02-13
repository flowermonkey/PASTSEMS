module cksumTB
	#(parameter w = 8);
	logic	clock, reset_L, done, start, cksumOK;		
	logic	[w-1:0] dIn;	//to your input
	logic	[w-1:0] tbCksum;	//used to calculate cksum of message being sent
	 
	cksum #(w) c (.*);		// Your design is instantiated here
	 
	 
	initial begin
	 	clock = 0;
	 	#5;			// this puts all positive edges on time = multiples of 10
	 	forever #5 clock = ~clock;
	end
	 
	initial begin: testbench		//// An implicit FSM
		reset_L = 1;			// reset sequence
		#1 dIn = 8'h00;
		reset_L = 0;
		start = 0;
		done = 0;
		
		#1 reset_L = 1;
	 	
	 	@(posedge clock);					//statement will wait until time 10
	 	@(posedge clock); dIn <= 8'h00;		// statement executes at time 20
	 	@(posedge clock);
	 	@(posedge clock);	//let's start a message
	 		start <= 1;	//output the start byte
	 		$display ("Starting messge, time=%4d", $stime);
	 		tbCksum <= 8'd17;
	 		dIn <= 8'd17;	//first byte
	 	@(posedge clock);
	 		start <= 0;
	 		dIn <= 8'd50;	//second byte
	 		tbCksum <= tbCksum + 8'd50;
	 	@(posedge clock);
	 		dIn <= 8'd1;	//third byte
	 		tbCksum <= tbCksum + 8'd1;
	 	@(posedge clock);
	 		done <= 1;
	 		dIn <= -tbCksum; //send checksum
	 	@(posedge clock);
	 		done <= 0;
	 		dIn <= 0; //idle lines, no message
	 		// this message is correct
	 		if (done & cksumOK)	$display("At %4d, Message received correctly (%d)", $stime, dIn);
	 		else	$display("Oops, At %4d, tbCksum=%d, done=%b, cksumOK=%b", $stime, dIn, done, cksumOK);
	 	@(posedge clock);
	 		 //idle lines, no message
/*
 *
 *
 *Next message
 *
 */
    	reset_L = 0;		// reset the machine
	 	dIn = 8'h00;		// set our outputs to zero
	 	#1 reset_L = 1;
	 	
	 	@(posedge clock);	//let's start a message -- number 2
	 		start <= 1;
	 		$display ("\n\n\n");
	 		$display ("Starting messge, time=%4d", $stime);
	 		dIn <= 8'd77;	//first byte
	 		tbCksum <= 8'd77;
	 	@(posedge clock);
	 		start <= 0;
	 		dIn <= 8'd22;	//second byte
	 		tbCksum <= tbCksum + 8'd22;
	 	@(posedge clock);
	 		dIn <= 8'd11;	//third byte
	 		tbCksum <= tbCksum + 8'd11;
	 	@(posedge clock);
	 		dIn <= 8'd7;	//fourth byte
	 		tbCksum <= tbCksum + 8'd7;
	 	@(posedge clock);
	 		done <= 1;
	 		dIn <= -tbCksum; //send checksum
	 	@(posedge clock);
	 		done <= 0; 	
	 		// this message is correct
	 		if (done & cksumOK)	$display("At %4d, Message received correctly (%d)", $stime, dIn);
	 		else	$display("Oops, At %4d, tbCksum=%d, done=%b, cksumOK=%b", $stime, dIn, done, cksumOK);
/*
 *
 *
 *Next message -- this one starts immediately (asap), and is correct
 *
 */
	 	$display ("\n\n\n");
	 	$display ("Starting messge, time=%4d", $stime); 
	
	 		start <= 1;
	 		dIn <= 8'd77;	//first byte
	 		tbCksum <= 8'd77;
	 	@(posedge clock);
	 		start <= 0;
	 		dIn <= 8'd22;	//second byte
	 		tbCksum <= tbCksum + 8'd22;
	 	@(posedge clock);
	 		done <= 1;
	 		dIn <= -tbCksum; //send checksum
	 	@(posedge clock);
	 		done <= 0; 
	 		// this message is correct
	 		if (done & cksumOK)	$display("At %4d, Message received correctly (%d)", $stime, dIn);
	 		else	$display("Oops, At %4d, tbCksum=%d, done=%b, cksumOK=%b", $stime, dIn, done, cksumOK);
	 	@(posedge clock);
	 		//idle lines, no message
/*
 *
 *
 *Next message -- this one puts some junk on the line to see if the receiver ignores it
 *
 */
	 	$display ("\n\n\n");
	 	$display ("Starting messge (just junk), time=%4d", $stime); // 
	 	@(posedge clock);
	 		done <= 1;
	 		dIn <= 8'd25;	
	 	@(posedge clock);
	 		done <= 0;
	 	@(posedge clock);
	 		reset_L <= 0;		//reset everything just in case design screwed up!
	 		#1 reset_L <= 1;
/*
 *
 *
 *Next message -- this one is incorrect, bad checksom
 *
 */
	 	@(posedge clock);	//let's start a message
	 		start <= 1;
	 		$display ("\n\n\n");
	 		$display ("Starting messge, time=%4d", $stime);
	 		dIn <= 8'd2;	
	 		tbCksum <= 8'd2;
	 	@(posedge clock);
	 		dIn <= 8'd77;	//first byte
	 		tbCksum <= tbCksum + 8'd77;
	 	@(posedge clock);
	 		start <= 0;		// possible problem, start doesn't immediately go back to 0
	 		dIn <= 8'd22;	//second byte
	 		tbCksum <= tbCksum + 8'd22 + 1;	//add 1 to make checksum wrong
	 	@(posedge clock);
	 		done <= 1;
	 		dIn <= -tbCksum; //send checksum
	 	@(posedge clock);
	 		done <= 0; 	
	 		// this message is NOT correct
	 		if (done & cksumOK)	$display("At %4d, Message received correctly (%d)", $stime, dIn);
	 		else	$display("Oops, At %4d, tbCksum=%d, done=%b, cksumOK=%b", $stime, dIn, done, cksumOK);
	 	@(posedge clock);
	 	#1 $finish;
end
endmodule: cksumTB
