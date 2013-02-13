module tb(output bit clk, rst_b, output pkt_t pkt_in[6],
  output bit pkt_in_avail[6],
  input pkt_t pkt_out[6],
  input bit pkt_out_avail[6]);
 
 	bit [5:0] test_assert;
	bit [4:0] out;

 	initial begin
		rst_b=0;clk=0;
		#5 rst_b = 1;
		forever #5 clk = ~clk;
	end

	task reset;
		@(posedge clk);
		rst_b = 0;
		@(posedge clk);
		rst_b = 1;
		@(posedge clk);
	endtask	
	
	task pkt_in_avail_gen(bit [5:0] avail);
		pkt_in_avail[0] <= avail[0];
		pkt_in_avail[1] <= avail[1];
		pkt_in_avail[2] <= avail[2];
		pkt_in_avail[3] <= avail[3];
		pkt_in_avail[4] <= avail[4];
		pkt_in_avail[5] <= avail[5];
	endtask

	initial begin
		
		$display("\n************* TEST 1a: Zero Pkts *****************");
		$display("* Are zero pkts treated as packages when they    *");
		$display("*            are NOT actually sent?              *");
		$display("**************************************************\n");
		
		test_assert <= 'b1; 
		repeat (10) @(posedge clk);
		
		reset;
		$display("************* TEST 1b: Zero Pkts *****************");
		$display("* Are zero pkts treated as packages when they    *");
		$display("*              ARE actually sent?                *");
		$display("**************************************************\n");
		
		test_assert <= 'b10;
		
		@(posedge clk);
	//send first value
		pkt_in[2] <= 32'h20000000;
		pkt_in_avail_gen('b000100);
		
		@(posedge clk);
	//zero first value
		pkt_in[2] <= 32'h00000000;
		pkt_in_avail[2] <= 0;
	
	//send second value
		pkt_in[1] <= 32'h10000000;
		pkt_in_avail[1] <= 1;

		@(posedge clk);
	//zero second value
		pkt_in[1] <= 32'h00000000;
		pkt_in_avail[1] <= 0;
	
	//send all zero value
		pkt_in[0] <= 32'h0;
		pkt_in_avail[0] <= 1;
		
		@(posedge clk);
		pkt_in_avail[0] <= 0;

	//allow time to propagate
		repeat (20) @(posedge clk);
	
		reset;
		$display("************* TEST 2: Wild Pkts ******************");
		$display("* What happens when a wild number appears as     *");
		$display("*                 the destID?                    *");
		$display("**************************************************\n");

		test_assert <= 'b100; 
		
		@(posedge clk);
		pkt_in[1] <= 32'h28000000;
		pkt_in[3] <= 32'h3EADBEEF;
		pkt_in[4] <= 32'hFF002300;
	
		pkt_in_avail_gen('b011010);

		@(posedge clk);
		pkt_in[1] <= 32'h0;
		pkt_in[3] <= 32'h0;
		pkt_in[4] <= 32'h0;
		
		pkt_in_avail_gen('b000000);
		
		repeat (20) @(posedge clk);

	//What would happen if every node sent to the same node at once?
	//They should all get to that node.
		reset;
		$display("************* TEST 3: Conflicts *****************");
		$display("*           ALL ABOARD THE ONE TRAIN          	*");
		$display("*************************************************\n");
			
		test_assert <= 'b1000; 
		
		@(posedge clk);
		pkt_in[0] <= 32'h01010101;
		pkt_in[2] <= 32'h21F00200;
		pkt_in[3] <= 32'h31ADBEEE;
		pkt_in[4] <= 32'h41FEA143;
		pkt_in[5] <= 32'h51123456;
		
		pkt_in_avail_gen('b111101);
		
		@(posedge clk);
		pkt_in[0] <= 32'h0;
		pkt_in[2] <= 32'h0;
		pkt_in[3] <= 32'h0;
		pkt_in[4] <= 32'h0;
		pkt_in[5] <= 32'h0;

		pkt_in_avail_gen('b000000);

		repeat (40) @(posedge clk);

//Can nodes send messages at the same time to different locations?
		reset;
		$display("************* TEST 4: Concurrency ***************");
		$display("*              All together now             	*");
		$display("*************************************************\n");
		
		test_assert <= 'b10000; 

		@(posedge clk);
		pkt_in[0] <= 32'h01010101;
		pkt_in[2] <= 32'h20F00200;
		pkt_in[3] <= 32'h34ADBEEE;
		pkt_in[4] <= 32'h45FEA143;
		
		pkt_in_avail_gen('b011101);

		@(posedge clk);
		pkt_in[0] <= 32'h0;
		pkt_in[2] <= 32'h0;
		pkt_in[3] <= 32'h0;
		pkt_in[4] <= 32'h0;

		pkt_in_avail_gen('b000000);

		repeat (60) @(posedge clk);

//Does the established priority cause great startvation?
		reset;
		$display("************* TEST 5: Priority ******************");
		$display("*           Don't starve them             	*");
		$display("*************************************************\n");
	
		test_assert <= 'b100000; 

		@(posedge clk);
		pkt_in[5] <= 32'h51123456;
		pkt_in[4] <= 32'h43FEA143;
		pkt_in[3] <= 32'h31ADBEEE;
		pkt_in[2] <= 32'h23F00200;
		pkt_in[0] <= 32'h01010101;
	
		pkt_in_avail_gen('b111101);
		
		@(posedge clk);
		pkt_in[5] <= 32'h0;
		pkt_in[4] <= 32'h0;
		pkt_in[3] <= 32'h0;
		pkt_in[2] <= 32'h0;
		pkt_in[0] <= 32'h0;
		
		pkt_in_avail_gen('b000000);
		
		repeat (30) @(posedge clk);

		$finish;
	end 

/////////////////////////////--ASSERTIONS--//////////////////////////////////////

	assert property (checkTest1a) begin 
			$display ("\nTest Passed:");
			$display ("No messages sent. Therefore, zero pkts aren't always messages.\n");
		end
	else
			$display("\nMessage sent...somethings wrong\n");

	assert property (checkTest1b) begin 
			$display ("\nTest Passed:");
			$display ("Zero Message Sent\n");
	end
	else
			$display("\nMessage did not send\n");

	assert property (checkTest2)begin
			$display ("\nTest Passed:");
			$display ("No Wild Message Appeared!\n");
	end
	else
			$display("\nA Wild Message appeared...prepare to battle!\n");

	assert property (checkTest3) begin
			$display ("\nTest Passed:");
			$display ("All messages were received!\n");
	end
	else
			$display("\nLost a message...never liked the 1 Train anyways...\n");

	assert property (checkTest4a)begin
			$display ("Messages to N0 and N5 were concurrent!\n");
			$display ("Test Passed\n");
	end
	else
			$display("\nSorry not concurrent...\n");
	assert property (checkTest4b)
			$display ("\nMessages to N1 and N4 were concurrent!");
	else
			$display("\nSorry not concurrent...\n");

	assert property (checkTest5_1)
				$display ("Message received at N1 arrived!");
	assert property (checkTest5_3) begin
				$display ("Message received at N3 arrived!");
	end
	else
				$display("\nDude...this isn't Africa. Prioritize better!\n");

//Checks to see if pkt_out indicator is ever set if no messages are
//sent. This should justify that initialized zeros aren't treated as
//pkts
	property checkTest1a;
		@(posedge clk) disable iff(test_assert != 'b1)
				((pkt_out_avail [0] == 1'b0) & (pkt_out_avail [1] == 1'b0) 
				&(pkt_out_avail [2] == 1'b0) & (pkt_out_avail [3] == 1'b0) 
				&(pkt_out_avail [4] == 1'b0) &(pkt_out_avail [5] == 1'b0)) ;
	endproperty 

//Checks to see if all zero packs can be sent to nodes. Also proves that
//nodes can send messages to them selves
	property checkTest1b;
		@(posedge clk) disable iff(test_assert != 'b10)
			(pkt_out_avail[0]) |-> (pkt_out[0] == 32'h10000000) or
			(pkt_out[0] == 32'h20000000) or (pkt_out[0] == 32'h0);
	endproperty 

//Checks to see if all pkt_outs are ever one of the wild pkts over a
//long period of time.
	property checkTest2;
		@(posedge clk) disable iff(test_assert != 'b100)
			 ((pkt_out[0] != 'h28000000) || (pkt_out[0] != 'h3EADBEEF) || (pkt_out[0] != 'hFF002300)) and
			 ((pkt_out[1] != 'h28000000) || (pkt_out[1] != 'h3EADBEEF) || (pkt_out[1] != 'hFF002300)) and
			 ((pkt_out[2] != 'h28000000) || (pkt_out[2] != 'h3EADBEEF) || (pkt_out[2] != 'hFF002300)) and
			 ((pkt_out[3] != 'h28000000) || (pkt_out[3] != 'h3EADBEEF) ||	(pkt_out[3] != 'hFF002300)) and
			 ((pkt_out[4] != 'h28000000) || (pkt_out[4] != 'h3EADBEEF) ||	(pkt_out[4] != 'hFF002300)) and
			 ((pkt_out[5] != 'h28000000) || (pkt_out[5] != 'h3EADBEEF) ||	(pkt_out[5] != 'hFF002300));
	endproperty 
	
//Checks the pkts coming out of N1 in the correct order in which the
//priority scheme demands. If all pkts come out no pkts were then
//droppped.
	property checkTest3; 
		@(posedge clk) disable iff(test_assert != 'b1000)
		(	(pkt_out_avail[1]) and (pkt_out[1] == 'h01010101)) |-> (pkt_out[1] == 'h01010101) ##6
			(pkt_out[1] == 'h31ADBEEE) ##6 (pkt_out[1] == 'h41FEA143) ##6
			(pkt_out[1] == 'h51123456) ##6 (pkt_out[1] == 'h21F00200);
	endproperty 
	
//Checks if the possible concurrent movements were able to occur at the
//sametime. pkts to N0 and N5 were concurrent. Similarly for N1 and N4. 
	property checkTest4a;
		@(posedge clk) disable iff(test_assert != 'b10000)
			(pkt_out_avail [0] & pkt_out_avail[5]) |-> 
					(pkt_out[0] == 'h20F00200) and (pkt_out[5] == 'h45FEA143);
	endproperty 
	property checkTest4b;
		@(posedge clk) disable iff(test_assert != 'b10000)
			(pkt_out_avail [1] & pkt_out_avail[4]) |-> 
			(pkt_out[1] == 'h01010101) and (pkt_out[4] == 'h34ADBEEE);
	endproperty 
	
//Checks to see if all sent in pkts are receieved in the correct nodes.
//This would mean a packet will get to its location with out high levels
//of starvation by the priority scheme.
	property checkTest5_1;
		@(posedge clk) disable iff(test_assert != 'b100000)
				pkt_out_avail[1] |-> ((pkt_out[1] == 32'h01010101) or
															 (pkt_out[1] == 32'h31ADBEEE)	or
															 (pkt_out[1] == 32'h51123456));
	endproperty
	property checkTest5_3;
		@(posedge clk) disable iff(test_assert != 'b100000)
				pkt_out_avail[3] |-> ((pkt_out[3] == 32'h43FEA143) or
														 (pkt_out[3] == 32'h23F00200));
	endproperty

endmodule 
