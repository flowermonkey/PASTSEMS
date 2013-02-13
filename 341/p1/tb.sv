/****************
*  Brian Flores *
*  Logic Design *
*  Project 1    * 
****************/

module tb_pq;

///////////////////////////INSTANTIATIONS////////////////////////////// 
	bit [7:0] newVal, top;
	bit ck, r, clear, loadIn, shiftOut;
	bit [4:0] i;
	bit [6:0] test_indicator; //restricts assertion property influences

	priQueue pq(.*);

////////////////////////////////TASKS////////////////////////////////// 
	
	//Will reset pq between tests
	task reset();
		@(posedge ck);
		r = 1;
		#10 r = 0;
	endtask 

/*--------------------------------------------------------------*/ 

//Sends a seqence of 'len' random numbers to pq
//Shifts out the kept 6
	task sendNshift(input bit [4:0] len);
		
		loadIn <= 1;
		for(i=0; i<len;i++) begin
				//gives newVal a random unsign number between 1 and 255
				newVal <= $urandom_range(255,1);
				@(posedge ck);
		end		
		loadIn <= 0;
		
		//i keeps track of shifted values for assertion properties
		i=0;
		shiftOut <= 1;
		repeat (10) begin
			i<=i+1;
			@(posedge ck);
			end
		shiftOut <= 0;
	endtask

/*--------------------------------------------------------------*/ 

//Asynchronously resets pq in the middle of an insertion sequence
	task test_asyncReset;
		loadIn <= 1;	
		repeat(5) begin
			newVal <= $urandom_range(255,1);
			@(posedge ck);
		end
		
		r =#3 1;
		r =#15 0; 
	
		repeat(5) begin
			newVal <= $urandom_range(255,1);
			@(posedge ck);
		end
		loadIn <= 0;
	endtask


/*--------------------------------------------------------------*/ 

//Synchronously clears pq in the middle of an insertion sequence
	task test_syncClear;
		loadIn <= 1;	
		repeat(5) begin
			newVal <= $urandom_range(255,1);
			@(posedge ck);
		end
		
		clear <=1;
		@(posedge ck);
		clear <=0;

		repeat(3) begin
			newVal <= $urandom_range(255,1);
			@(posedge ck);
		end
		loadIn <= 0;
		
		shiftOut <= 1;
		repeat (7) @(posedge ck);
		shiftOut <= 0;
	endtask

/*--------------------------------------------------------------*/ 

//Tests hiearchy of control points by shifting in and out one value
	task test_controlPoints;
		clear<=1;loadIn<=1;shiftOut<=1;
		newVal <= $urandom_range(255,1);
		@(posedge ck);
		
		clear<=0;loadIn<=1;shiftOut<=1;
		newVal <= $urandom_range(255,1);
		@(posedge ck);
		
		clear<=0;loadIn<=0;shiftOut<=1;
		@(posedge ck);
		shiftOut<=0;

	endtask

/*--------------------------------------------------------------*/ 

//Test pq against a duplicate value sequence (1,1,1,3,3,3,2,2)
	task test_dups;
	  i<=0;
		loadIn <= 1;
		repeat (3) begin
				newVal <= 1;
				@(posedge ck);
		end

		repeat (3) begin
				newVal <= 3;
				@(posedge ck);
		end

		repeat (3) begin
				newVal <= 1;
				@(posedge ck);
		end
		
		repeat (2) begin
				newVal <= 2;
				@(posedge ck);
		end
		loadIn <= 0;
		
		shiftOut <= 1;
		repeat (10) begin
			i<= i+1;
			@(posedge ck);
		end
		shiftOut <= 0;
	endtask

///////////////////////////INITIAL BLOCKS////////////////////////////// 

//Simulate clock and start from reset
	initial begin
		ck = 0; r = 1;
		#10 r = 0;
	  forever #5 ck = ~ck;
	end
	
//Run all tasks with a reset in between each test
	initial begin
		$monitor ("%d newVal=%d, top=%d, shiftOut=%b, loadIn=%b, clear=%b", 
							$time, newVal, top, shiftOut, loadIn, clear);
		
		$display("\n\t\t\tTest 1: Will only 6 values shift out?");
		test_indicator <= 'b1000000; 
		sendNshift(20);
		
		reset();

		@(posedge ck);
		$display("\n\t\t\tTest 2: Will values shift in correct Order?");
		test_indicator <= 'b0100000;
		sendNshift(20);

		reset();
		
		@(posedge ck);
		$display("\n\t\t\t\tTest 3: Asych Reset");
		test_indicator <= 'b0010000;
		test_asyncReset;
		
		reset();
		
		@(posedge ck);
		$display("\n\t\t\t\tTest 4: Sych Clear");
		test_indicator <= 'b0001000;
		test_syncClear;

		reset();
		
		@(posedge ck);
		$display("\n\t\t\tTest 5: Hiearchy of Control Points");
		test_indicator <= 'b0000100;
		test_controlPoints;
		
		reset();
		
		@(posedge ck);
		$display("\n\t\t\t\tTest 6: Dupicate Values");
		test_indicator <= 'b0000010;
		test_dups;
		
		reset();
	
		@(posedge ck);
		$display("\n\t\t\tTest 7: Is top always the greatest value?");
		test_indicator <= 'b0000001;
		sendNshift(10);
		
		$finish;
	end

//////////////////////ASSERTIONS AND PROPERTIES////////////////////////
	
//Checks if all register values are zero'd
	sequence allClear;
		top==0 & ~pq.r1_out & ~pq.r2_out & ~pq.r3_out &
 ~pq.r4_out & ~pq.r5_out & ~pq.r6_out;
	endsequence

//Checks if, after 6 shifted values, there exists a nonzero number
	property check_onlySixVals;
		@(posedge ck) disable iff (test_indicator != 'b1000000) 
		(shiftOut & i==6) |=> (top==0);
	endproperty

//Checks if the previous shifted top value was greater than the current
	property check_shiftOrder;
		@(posedge ck)  disable iff (test_indicator != 'b0100000) 
		(shiftOut & i>1 & i<7) |-> (top<=$past(top,1));
	endproperty
	
//Checks if at the assertion of a reset if all registers are cleared
	property check_asyncReset;
		@(posedge ck)  disable iff (test_indicator != 'b0010000) 
		r |-> allClear;
	endproperty

//Checks if at the clock egde after the assertion of a clear if all
//registers are cleared
	property check_syncClear;
		@(posedge ck)  disable iff (test_indicator != 'b0001000) 
		clear |=> allClear;
	endproperty

//Checks to see if clear has priority over loadIn and shiftOut
	property check_controlPoints_1;
		@(posedge ck)  disable iff (test_indicator != 'b0000100)
		(clear & loadIn & shiftOut) |=> allClear;
	endproperty
	
//Checks to see if loadIn has priority over shiftOut
	property check_controlPoints_2;
		@(posedge ck)  disable iff (test_indicator != 'b0000100)
		(~clear & loadIn & shiftOut) |=> (top!=0);	
	endproperty

//Checks if shiftOut works
	property check_controlPoints_3;
		@(posedge ck)  disable iff (test_indicator != 'b0000100)
		(~clear & ~loadIn & shiftOut) |=> (top==0);
	endproperty

//Checks if sequence (1,1,1,3,3,3,2,2) is shifted out correctly
//that is (3,3,3,2,2,1)
	property check_dups;
		@(posedge ck)  disable iff (test_indicator != 'b0000010) 
		(shiftOut & i==1) |-> (top==3) [*3] ##1 (top==2) [*2] ##1 (top==1);
	endproperty

//Checks if top is always the greatest value on the pq
	property check_topGreatest;
		@(posedge ck)  disable iff (test_indicator != 'b0000001) 
		(loadIn) |=> (top>pq.r2_out) & (top>pq.r3_out) &(top>pq.r4_out)
								& (top>pq.r5_out) & (top>pq.r6_out);
	endproperty

									//Assertions of properties//
/*--------------------------------------------------------------*/ 
	assert property (check_onlySixVals) 
		$display ("Test 1 Passed :)");

	assert property (check_shiftOrder)
		$display ("Test 2 Passed :)");
		
	assert property (check_asyncReset)
		$display ("Test 3 Passed :)");
		
	assert property (check_syncClear)
		$display ("Test 4 Passed :)");

	assert property (check_controlPoints_1)
		$display ("Test 5 Passed :)");
	assert property (check_controlPoints_2)
		$display ("Test 5 Passed :)");
	assert property (check_controlPoints_3)
		$display ("Test 5 Passed :)");

	assert property (check_dups)
		$display ("Test 6 Passed :)");

	assert property (check_topGreatest)
		$display ("Test 7 Passed :)");

endmodule : tb_pq

