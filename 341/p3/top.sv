// Brian Flores
// bflores
// top.sv

//`default_nettype none

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
							 intE, intF, num;
		bit[5:0] 	 inputQ_size, test_indicator;

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
			insertXtimes(16'd1, 5'd7); //to test stack
			reset();
			insertXtimes(16'd1, 5'd9); //to test stack
			reset();
			num <= 16'h0; 
			inAndOut();		//insert 8 0s
			reset();
			num <= 16'hFFFF; 
			inAndOut();   //insert 8 FFFFs
			reset();
			testDone();
			reset();
			testArithOverflow();
			reset();
			testProtocol();
			reset();
			@(posedge ck);
    endtask
		/*}}}*/

//BEGIN - OTHER TASKS/*{{{*/
		
	//This task inserts data into the calculator as well as to my
	//testbenches version of a calculator.
	//It sets important index values for testing (inputQ_size)
		task dataIn(input keyIn in);
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
		
	//This task resets the system
		task reset();
      rst_l <= 0; inputQ_size <= 0; data <= 20'h0;
			inputQ.delete;
      @(posedge ck);
      rst_l <= 1;
      @(posedge ck);
		endtask
	
	//Tests vectors for adding A + B
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
	
	//Test vectors for subtracting A-B
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

	//Test vectors for anding A&B
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

	//Test vectors for swaping C and D, then poping one out
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

	//Test vectors for negating E
		task testNeg(input bit [15:0] E);
      dataIn({4'h1, E}); // start, load E
      @(posedge ck);
      dataIn({4'h4, 16'h10}); // negate
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
			@(posedge ck);
		endtask

	//Test vectors for poping F
		task testPop(input bit [15:0] F);
      dataIn({4'h1, F}); // start, load F
     	@(posedge ck);
      dataIn({4'h4, 16'h20}); // pop
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
		endtask
		
	//Test vectors for inserting a 'num', 'times' times into the
	//calculator. Does not take them out.
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
      @(posedge ck);  
		endtask

	//Test vectors for inserting 'num' 8 times
	//and poping it out 8 times
		task inAndOut();
			test_indicator <= 6'b100;
			@(posedge ck);
      dataIn({4'h1, num}); // start, load num
			@(posedge ck);
      dataIn({4'h2, num}); //enter num
			@(posedge ck);
      dataIn({4'h2, num}); //enter num
			@(posedge ck);
      dataIn({4'h2, num}); //enter num
			@(posedge ck);
      dataIn({4'h2, num}); //enter num
			@(posedge ck);
      dataIn({4'h2, num}); //enter num
			@(posedge ck);
      dataIn({4'h2, num}); //enter num
			@(posedge ck);
      dataIn({4'h2, num}); //enter num
			@(posedge ck);

			dataIn({4'h4, 16'h0020}); //pop num
			@(posedge ck);
			dataIn({4'h4, 16'h0020}); //pop num
			@(posedge ck);
			dataIn({4'h4, 16'h0020}); //pop num
			@(posedge ck);
			dataIn({4'h4, 16'h0020}); //pop num
			@(posedge ck);
			dataIn({4'h4, 16'h0020}); //pop num
			@(posedge ck);
			dataIn({4'h4, 16'h0020}); //pop num
			@(posedge ck);
			dataIn({4'h4, 16'h0020}); //pop num
			@(posedge ck);
			dataIn({4'h4, 16'h0020}); //pop num
			@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
      @(posedge ck);  
			test_indicator <= 6'b0;
		endtask

	//Test vectors for checking if done will error when two inputs are
	//left on the stack when it is inputed
		task testDone();
      dataIn({4'h1, 16'd21}); // start, load 21
     	@(posedge ck);
      dataIn({4'h2, 16'd18}); // start, load 18
     	@(posedge ck);
      dataIn({4'h8, 16'h1}); // done
      @(posedge ck);  
			assert (unexpectedDone)
				else $display("unexpectedDone is not asserted properly!");
		endtask

	//Test vectors for producing Overflows
		task testArithOverflow();
			test_indicator <=6'b10;
			dataIn({4'h1, 16'h8000}); //start, load Tmin
			@(posedge ck);
			dataIn({4'h2, 16'h0001}); //enter, load 1
			@(posedge ck);
      dataIn({4'h4, 16'h0002}); // sub
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
      @(posedge ck);  

			reset();
      @(posedge ck);  
			dataIn({4'h1, 16'h8000}); //start, load Tmin
			@(posedge ck);
			dataIn({4'h2, 16'h8000}); //enter, load Tmin
			@(posedge ck);
      dataIn({4'h4, 16'h0002}); // sub
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
      @(posedge ck);  

			reset();
      @(posedge ck);  
			dataIn({4'h1, 16'h7FFF}); //start, load Tmax
			@(posedge ck);
			dataIn({4'h2, 16'h0001}); //enter, load 1
			@(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
      @(posedge ck);  

			reset();
      @(posedge ck);  
			dataIn({4'h1, 16'h8000}); //start, load 0xFFFF
			@(posedge ck);
			dataIn({4'h2, 16'h8000}); //enter, load 1
			@(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
      @(posedge ck);  
      @(posedge ck);  
			test_indicator <=6'b0;
		endtask

	//Test vectors for checking the 3 protocol errors
		task testProtocol();
			test_indicator <= 1;
//two starts
			dataIn({4'h1, 16'h0007}); // start, load 7
      @(posedge ck);
      dataIn({4'h2, 16'h0002}); // enter 2
     	@(posedge ck);
			dataIn({4'h1, 16'h0007}); // start, load 7
      @(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
		assert (protocolError)
			else $display("protocolError is not asserted when two starts are inputed!");
      @(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
		assert (protocolError)
			else $display("protocolError is not asserted when two starts are inputed!");
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
		assert (protocolError)
			else $display("protocolError is not asserted when two starts are inputed!");
      @(posedge ck);  
      @(posedge ck);  
		assert (~protocolError)
			else $display("protocolError is not asserted when two starts are inputed!\n");
			reset();

//Wrong Value
			dataIn({4'h1, 16'h0007}); // start, load 7
      @(posedge ck);
      dataIn({4'h2, 16'h0002}); // enter 2
     	@(posedge ck);
      dataIn({4'h4, 16'h0012}); // enter wrong value
     	@(posedge ck);
      dataIn({4'h4, 16'h0001}); // add
		assert (protocolError)
			else $display("protocolError is not asserted when weird op is inputed!");
      @(posedge ck);
      dataIn({4'h8, 16'h0001}); // done
		assert (protocolError)
			else $display("protocolError is not asserted when weird op is inputed!");
      @(posedge ck);  
      @(posedge ck);  
		assert (~protocolError)
			else $display("protocolError is not asserted when weird op is inputed!\n");
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
		assert (protocolError)
			else $display("protocolError is not asserted when too many ops are used!");
      @(posedge ck);  
     	@(posedge ck);
		assert (~protocolError)
			else $display("protocolError is not asserted when too many ops are used\n");
			test_indicator <= 0;
		endtask
//END - OTHER TASKS/*}}}*/

//BEGIN - ASSERTIONS/*{{{*/

//BEGIN - PROPERTIES/*{{{*/ 
		property correctAdd;
			@(posedge ck) disable iff (test_indicator != 5'b0)
				(data == {4'h4, 16'h1}) 
						|=> ((intA + intB) == result); 
		endproperty 
		
		property correctSub;
			@(posedge ck) disable iff (test_indicator != 5'b0)
				(data == {4'h4, 16'h2})
						|=> ((intB - intA) == result);
		endproperty 

		property correctAnd;
			@(posedge ck) disable iff (test_indicator != 5'b0)
				(data == {4'h4, 16'h4}) 
						|=> ((intA&intB) == result);
		endproperty 

		property correctSwap;
			bit [15:0] temp;
			@(posedge ck) disable iff (test_indicator != 5'b0)
				((data == {4'h4, 16'h8}), temp = result) 
						|=> (intD == result) and (intC == temp) ##1 (intC == result);
		endproperty 

		property correctNeg;
			@(posedge ck) disable iff (test_indicator != 5'b0)
				(data == {4'h4, 16'h10})
						|=> (intE == result);
		endproperty 
		
		property correctPop;
			bit [15:0] temp;
			@(posedge ck) disable iff (test_indicator != 5'b0)
				((data == {4'h4, 16'h20}), temp = result) 
						|=> (intF != result) and (intF == temp);
		endproperty 

	//Checks to see if result is always the value just inputed
	//so long as there are no errors
		property properValues();
			bit[15:0] temp;
			@(posedge ck) disable iff (~rst_l)
				(((data[19:16] == 4'h1) || (data[19:16] == 4'h2)) and 
					({stackOverflow,unexpectedDone,dataOverflow,protocolError} == 4'b0),
				temp = data[15:0]) |=> (result == temp); 	
		endproperty

	//checks to see if stackOverflow is set at the appropriate times
		property stackOK;
			@(posedge ck) disable iff (~rst_l)
				((inputQ_size>6'h8) and stackOverflow) or
				((inputQ_size<=6'h8) and (~stackOverflow));
		endproperty

	//checks to see if stackOverflow is set at the appropriate times
		property arithOK (bit [16:0] tempAdd,tempSub, bit [19:0] op);
			@(posedge ck)  disable iff (test_indicator != 6'b10)
			((dataOverflow) throughout 
				(op == {4'h4, 16'h1} and (tempAdd != result)) or //if add
				(op == {4'h4, 16'h2} and (tempSub != result))) //if sub
				or
				((~dataOverflow) throughout 
				(op == {4'h4, 16'h1} ##1 (tempAdd == result)) or //if add
				(op == {4'h4, 16'h2} ##1 (tempSub == result)) or 
				((op != {4'h4, 16'h1}) and  (op != {4'h4, 16'h2}))); //if sub
		endproperty	
		
	//checks to see if error signals are on for the correct duration
		property errorSignalLength(bit signal);
				@(posedge ck) (signal) |-> (signal)  [*0:$] ##1 (done and signal) ##1 (~signal); 
		endproperty

	//checks to see if correct is set at the appropriate times
		property correctOK();
			@(posedge ck) 
				({stackOverflow,unexpectedDone,dataOverflow,protocolError,finished}
						== 5'd1) and correct
						or
				({stackOverflow,unexpectedDone,dataOverflow,protocolError,finished}
						!= 5'd1) and ~correct;
		endproperty

	//checks to see if finished is set at the appropriate times
		property finishedOK();
			@(posedge ck) disable iff (~rst_l)
				((data[19:16] == 4'h8) and finished)
				or
				((data[19:16] != 4'h8) and ~finished);
		endproperty

	//checks to see if all inputed values are equal to the ouptuted ones
	//in the inAndOut task
		property inAndOutOK(num);
			@(posedge ck) disable iff (test_indicator != 6'b100)
				(data[19:16]== 4'h1) |=> (result == num) [*15] ##1 (data[19:16] == 4'h8);
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
		
		assert property (properValues)
			else
				$display("Value entered does not match result\n");
		
		assert property (stackOK)
			else
				$display("Bad stack maintenance!\n");

		assert property (arithOK((intA + intB), (intB - intA), data))
			else
				$display("Bad Arithmic Overflow signal!\n");
		
		assert property (errorSignalLength(stackOverflow))
			else 
					$display("stackOverflow does not stay on till done.\n");

		assert property (errorSignalLength(dataOverflow))
			else 
					$display("dataOverflow does not stay on till done.\n");

		assert property (errorSignalLength(protocolError))
			else 
					$display("protocolError does not stay on till done.\n");

		assert property (correctOK)
			else
					$display("Bad correct signal\n");
		
		assert property (finishedOK)
			else
					$display("Bad finished signal\n");
		
		assert property (inAndOutOK(num))
			else
					$display("inputed numbers != outputed numbers\n");
//END - ASSERTS/*}}}*/

//END- ASSERTIONS/*}}}*/
endmodule: top
