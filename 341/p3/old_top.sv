// Brian Flores
// bflores
// top.sv

`ifndef STRUCTS
`define STRUCTS
    typedef enum bit [3:0] {
        start=4'h1, 
        enter=4'h2, 
        arithOp=4'h4, 
        done=4'h8
    } oper;

    typedef struct packed {
        oper op;
        bit[15:0] payload;
    } keyIn;
`endif


//////////////////////
////             ////
////    top     ////
////           ////
//////////////////

module top();

    //outputs to calculator
    bit    ck, rst_l;
    keyIn  data;

    //inputs from calculator
    bit [15:0]  result;
    bit         stackOverflow, unexpectedDone,
                protocolError, dataOverflow, correct, finished;
 		
		//My Varibales
		bit [19:0] inputQ [$];
		bit [15:0] intA, intB, intC, intD,
							 intE, intF;
		bit[5:0] inputQ_size, test_indicator;

		TA_calc  brokenCalc(.*);

    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

//MAIN TASK/*{{{*/
    task runTestbench();
			reset();
			testAdd(16'd3, 16'd5);
			reset();
			testSub(16'd10, 16'd4);
			reset();
			testAnd(16'd7, 16'd15);
			reset();
			testSwap(16'd9, 16'd10);
			reset();
			testNeg(16'd10);
			reset();
			testPop(16'd15);
			reset();
			insertXtimes(16'd1, 5'd8);
			reset();
			insertXtimes(16'd1, 5'd10);
			reset();
			testDone();
			reset();
			testArithOverflow();
			reset();
			testProtocol();
//			testOps();
			@(posedge ck);
    endtask
		/*}}}*/

//BEGIN - OTHER TASKS/*{{{*/
		task dataIn(input keyIn in);/*{{{*/
			data <= in;
			if(in.op.name == "arithOp")
       	case(in.payload)
					16'h1: begin //add
							intA <= inputQ.pop_front(); 
							intB <= inputQ.pop_front();
						  #1 inputQ.push_front(intA + intB); 
					end
					16'h2: begin //sub
							intA <= inputQ.pop_front(); 
							intB <= inputQ.pop_front();
						  #1 inputQ.push_front(intB - intA); 
					end
					16'h4: begin //and
							intA <= inputQ.pop_front(); 
							intB <= inputQ.pop_front();
						  #1 inputQ.push_front(intA & intB); 
					end
					16'h8: begin  					 //swap
							intC <= inputQ.pop_front(); 
							intD <= inputQ.pop_front();
						  #1 inputQ.push_front(intC); 
								 inputQ.push_front(intD); 
					end
					16'h10: begin						 //Negate
							intE <= ~inputQ.pop_front() + 1'b1;
						  #1 inputQ.push_front(intE); 
					end
					16'h20: begin						 //Pop
							intF <= inputQ.pop_front(); 
					end
				endcase
      else if (in.op.name == "done");
			else inputQ.push_front(in); 
			
			inputQ_size <= inputQ.size();
		endtask
		
		task reset();
      rst_l <= 0; inputQ_size <= 0;
			inputQ.delete;
      @(posedge ck);
      rst_l <= 1;
      @(posedge ck);
		endtask
		
		task testAdd(input bit [15:0] A,B);
			dataIn({4'h1, A}); // start, load A
      @(posedge ck);
      dataIn({4'h2, B}); // enter B
      @(posedge ck);
      dataIn({4'h4, 16'h1}); // add
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
		endtask

		task testSub(input bit [15:0] A,B);
		  dataIn({4'h1, A}); // enter A
      @(posedge ck);
      dataIn({4'h2, B}); // enter B
      @(posedge ck);
      dataIn({4'h4, 16'h2}); // sub
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
		endtask

		task testAnd(input bit [15:0] A,B);
		  dataIn({4'h1, A}); // start, load A
     	@(posedge ck);
      dataIn({4'h2, B}); // enter B
      @(posedge ck);
      dataIn({4'h4, 16'h4}); // and
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
		endtask

		task testSwap(input bit [15:0] C,D);
	    dataIn({4'h1, C}); // start, load C
     	@(posedge ck);
      dataIn({4'h2, D}); // enter D
      @(posedge ck);
      dataIn({4'h4, 16'h8}); // swap
     	@(posedge ck);
      dataIn({4'h4, 16'h20}); // pop
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
			@(posedge ck);
		endtask

		task testNeg(input bit [15:0] E);
      dataIn({4'h1, E}); // start, load E
      @(posedge ck);
      dataIn({4'h4, 16'h10}); // negate
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
			@(posedge ck);
		endtask

		task testPop(input bit [15:0] F);
      dataIn({4'h1, F}); // start, load F
     	@(posedge ck);
      dataIn({4'h4, 16'h20}); // pop
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
		endtask
		
		task insertXtimes(bit [15:0] num,bit [4:0] times);
      dataIn({4'h1, num}); // start, load num
     	@(posedge ck);
			
			while(times > 0) begin
      	dataIn({4'h2, num}); //enter num
     		times <= times -1;
				@(posedge ck);
			end		
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
		endtask

		task testDone();
      dataIn({4'h1, 16'd21}); // start, load 21
     	@(posedge ck);
      dataIn({4'h2, 16'd18}); // start, load 18
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
		endtask

		task testArithOverflow();
			dataIn({4'h1, 16'h8000}); //start, load Tmin
			@(posedge ck);
			dataIn({4'h2, 16'h0001}); //enter, load 1
			@(posedge ck);
      dataIn({4'h4, 16'h0002}); // sub
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  

			dataIn({4'h1, 16'h8000}); //start, load Tmin
			@(posedge ck);
			dataIn({4'h2, 16'h8000}); //enter, load Tmin
			@(posedge ck);
      dataIn({4'h4, 16'h0002}); // sub
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  

			dataIn({4'h1, 16'h7FFF}); //start, load Tmax
			@(posedge ck);
			dataIn({4'h2, 16'h0001}); //enter, load 1
			@(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  

			dataIn({4'h1, 16'h8000}); //start, load 0xFFFF
			@(posedge ck);
			dataIn({4'h2, 16'h8000}); //enter, load 1
			@(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
		endtask
	/*}}}*/
		task testProtocol();
			test_indicator <=6'd1;
//two starts
			dataIn({4'h1, 16'h0007}); // start, load 7
      @(posedge ck);
      dataIn({4'h2, 16'h0002}); // enter 2
     	@(posedge ck);
			dataIn({4'h1, 16'h0007}); // start, load 7
      @(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
      @(posedge ck);  

			reset();
//Wrong Value
			dataIn({4'h1, 16'h0007}); // start, load 7
      @(posedge ck);
      dataIn({4'h2, 16'h0002}); // enter 2
     	@(posedge ck);
      dataIn({4'h4, 16'h0012}); // enter wrong value
     	@(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
      @(posedge ck);  

			reset();
//Too many ops
			dataIn({4'h1, 16'h0007}); // start, load 7
      @(posedge ck);
      dataIn({4'h2, 16'h0002}); // enter 2
     	@(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
     	@(posedge ck);
			test_indicator <=6'd0;

		endtask
/*{{{*/
		task testOps();
			dataIn({4'h1, 16'h0007}); // start, load 7
      @(posedge ck);
      dataIn({4'h2, 16'h0006}); // enter 6
      @(posedge ck);
      dataIn({4'h2, 16'h0002}); // enter 2
     	@(posedge ck);
      dataIn({4'h4, 16'h0002}); // sub
      @(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
		endtask
	
		//will run at the end of all test and says what may be cay
		task printFaultMessage(bit [5:0] faults);
			$display("This calc may have these problems:");
			case (faults)
				5'd0: begin
				end
			endcase
		endtask
/*}}}*/
//END - OTHER TASKS/*}}}*/

//BEGIN - ASSERTIONS/*{{{*/

//BEGIN - SEQUENCES /*{{{*/
		sequence notEnough ();
			((inputQ_size < 6'd2) and
				 ((data == {4'h4, 16'h1}) or
					(data == {4'h4, 16'h2}) or
					(data == {4'h4, 16'h4}) or
					(data == {4'h4, 16'h8})))
			or
			((inputQ_size < 6'd1) and
					((data == {4'h4, 16'h10}) or
					(data == {4'h4, 16'h20}))) 
			or
			((inputQ_size !=6'd1) and
					(data[19:16] == 4'h8) and
					(rst_l != 0))
			or
			((inputQ_size != 6'd1) and
					(data[19:16] == 4'h1)); 
		endsequence 
	
		sequence startAgain();
		 		(data[19:16]==4'h1) within (data[19:16] == 4'h1) ##[1:$] (finished);
		endsequence 

		sequence atLeast1Stack();
		 		(inputQ_size == 6'h0) within (data == {4'h1,16'd15}) ##[1:$] (finished);
		endsequence 

		sequence wrongCommands();
				($countones(data) != 2 and data[19:16] == 4'h4) or 
				(data > 20'h80020) or 
				(data < 20'h10000); 
		endsequence 
//END - SEQUENCES /*}}}*/

//BEGIN - PROPERTIES/*{{{*/ 
		property correctAdd;
			@(posedge ck) //disable iff (test_indicator != 5'b0)
				(data == {4'h4, 16'h1}) 
						|=> ((intA + intB) == result); 
		endproperty 
		
		property correctSub;
			@(posedge ck) //disable iff (test_indicator != 5'b0)
				(data == {4'h4, 16'h2})
						|=> ((intB - intA) == result);
		endproperty 

		property correctAnd;
			@(posedge ck) //disable iff (test_indicator != 5'b0)
				(data == {4'h4, 16'h4}) 
						|=> ((intA&intB) == result);
		endproperty 

		property correctSwap;
			bit [15:0] temp;
			@(posedge ck) //disable iff (test_indicator != 5'b0)
				((data == {4'h4, 16'h8}), temp = result) 
						|=> (intD == result) and (intC == temp) ##1 (intC == result);
		endproperty 

		property correctNeg;
			@(posedge ck) //disable iff (test_indicator != 5'b0)
				(data == {4'h4, 16'h10})
						|=> (intE == result);
		endproperty 
		
		property correctPop;
			bit [15:0] temp;
			@(posedge ck) //disable iff (test_indicator != 5'b0)
				((data == {4'h4, 16'h20}), temp = result) 
						|=> (intF != result) and (intF == temp);
		endproperty 
		
//TODO test to see when "ON" and "OFF"

		property stackOK;
			@(posedge ck) //disable iff (test_indicator != 5'b0)
				((inputQ_size>6'h8) throughout 
				       stackOverflow ##[1:$] done) or
				((inputQ_size<=6'h8) throughout
								(~stackOverflow));
		endproperty

		property doneOK;
			@(posedge ck) ///disable iff (test_indicator != 5'b0)
				((unexpectedDone) throughout (finished and (inputQ_size>1))) or
				((~unexpectedDone) throughout (finished and (inputQ_size<=1)) or (~finished));
		endproperty
		
		property arithOK (bit [16:0] tempAdd,tempSub, bit [19:0] op);
			@(posedge ck) // disable iff ((op != {4'h4, 16'h0001}) & (op != {4'h4,16'h2}))
			((dataOverflow) throughout 
				(op == {4'h4, 16'h1} and (tempAdd != result)) or //if add
				(op == {4'h4, 16'h2} and (tempSub != result))) //if sub
				or
				((~dataOverflow) throughout 
				(op == {4'h4, 16'h1} ##1 (tempAdd == result)) or //if add
				(op == {4'h4, 16'h2} ##1 (tempSub == result)) or 
				((op != {4'h4, 16'h1}) and  (op != {4'h4, 16'h2}))); //if sub
		endproperty	
		
		property protoK ();
			@(posedge ck) disable iff (test_indicator != 6'b1)
					((notEnough) or 
					(startAgain) or 
					(atLeast1Stack) or
					(wrongCommands))|-> protocolError;
		endproperty	
//END - PROPERTIES/*}}}*/

//BEGIN - ASSERTS /*{{{*/
		assert property (correctAdd)
			else
				$display("Bad add!, %d+%d = %d?\n", $sampled(intA),
								$sampled(intB), $sampled(result));
	
		assert property (correctSub)
			else
				$display("Bad sub!, %d-%d = %d?\n", $sampled(intA),
								$sampled(intB), $sampled(result));
		
		assert property (correctAnd)
			else
				$display("Bad and!, %d&&%d = %d?\n", $sampled(intA),
								$sampled(intB),$sampled(result));
	
		assert property (correctSwap)
			else
				$display("Bad swap!, Tried to swap %d and %d but result = %d?\n", 
								$sampled(intD), $sampled(intC),$sampled(result));
		
		assert property (correctNeg)
			else
				$display("Bad negation!, %x != %x?\n",
								$sampled(intE),$sampled(result));
		
		assert property (correctPop)
			else
				$display("Bad pop!, should have popped %d but result =%d\n",
								$sampled(intF), $sampled(result));
		
		assert property (stackOK)
			else
				$display("Bad stack maintenance!");

		assert property (doneOK)
			else
				$display("Bad done signal maintenance!");

		assert property (arithOK((intA + intB), (intB - intA), data))
			else
				$display("Bad Arithmic Overflow signal!");
		
		assert property (protoK)
			else
				$display("Bad Protocol signal!");
//END - ASSERTS/*}}}*/

//END- ASSERTIONS/*}}}*/
endmodule: top
