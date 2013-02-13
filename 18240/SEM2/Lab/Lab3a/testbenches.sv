module test_comparator
 #(parameter w = 4)
	(output logic [w-1:0] A, B,
		input logic AltB, AeqB, AgtB);
		
		initial 
		begin
			$monitor($time, "    A = %d, B= %d, AltB = %b, AeqB = %b , AgtB = %b",A,B,AltB,AeqB,AgtB);
			A=0; B=0;
			#1 A='b0010; B='b0010;
			#1 A='b1111; B='b0000;
			#1 A='b0011; B='b1100;
			#1 $finish;
		end
endmodule: test_comparator

module testbench_comparator;
	logic [3:0] A, B;
	logic AltB, AeqB, AgtB;

	comparator #(4) comp(.*);
	test_comparator #(4) tcomp(.*);

endmodule: testbench_comparator

module test_adder
  #(parameter w =4)
	(output logic [w-1:0] A, B,
		output logic Cin,
		input logic [w-1:0] sum,
		input logic Cout);
		
		initial 
		begin
			$monitor($time, "    %d + %d + %b = %d , Cout = %b",A,B,Cin,sum,Cout);
			A=0; B=0; Cin=0;
			#1 A='b0010; B='b0010; Cin = 'b0;
			#1 A='b1111; B='b0000; Cin = 'b1;
			#1 A='b1100; B='b0010; Cin = 'b1;
			#1 $finish;
		end
endmodule: test_adder

module testbench_adder;
	logic Cin, Cout;
	logic [3:0] A, B, sum;

	adder #(4) add(.*);
	test_adder #(4) tadd(.*);

endmodule: testbench_adder

module test_mux
  #(parameter w =4)
	(output logic [w-1:0] in0, in1,
		output logic sel,
		input logic [w-1:0] out);
		
		initial 
		begin
			$monitor($time, "    in0 = %b, in1 = %b, sel = %b, out = %b",in0,in1,sel,out);
			in0=0; in1=0; sel=0;
			#1 in0='b0110; in1='b0010; sel ='b0;
			#1 in0='b1111; in1='b0000; sel ='b1;
			#1 in0='b0011; in1='b1100; sel ='b0;
			#1 $finish;
		end
endmodule: test_mux

module testbench_mux;
	logic sel;
	logic [3:0] in0, in1, out;

	mux #(4) mux(.*);
	test_mux #(4) tmux(.*);

endmodule: testbench_mux

module test_register
  #(parameter w =4)
	(output logic clk, load, clr,
		output logic[w-1:0] data_in,
		input logic [w-1:0] data_out);
		
		initial clk =0;
		always #10 clk=~clk;
		
		initial begin
			$monitor($time, "    load = %b, clr = %b, data_in = %b, data_out = %b",load,clr,data_in,data_out);
			
			load=0; clr=0; data_in=0;
			@(posedge clk);
			
			#1 load='b1; clr='b0; data_in='b1010;
			@(posedge clk);
			
			#1 load='b0; clr='b0; data_in='b1111;
			@(posedge clk);

			#1 load='b0; clr='b0; data_in='b1010;
			@(posedge clk);

			#1 load='b1; clr='b1; data_in='b1010;
			@(posedge clk);

			#1 load='b1; clr='b1; data_in='b1110;
			@(posedge clk);

			#1 load='b1; clr='b0; data_in='b1110;
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			#1 $finish;
		end
endmodule: test_register

module testbench_register;
	logic clk, load, clr;
	logic [3:0] data_in, data_out;

	register #(4) regist(.*);
	test_register #(4) tr(.*);

endmodule: testbench_register


module test_SIPO
 #(parameter w = 4)
 (output logic s_in, clk, clr, en,
  input logic [w-1:0] q);

	initial clk=0;
	always #10 clk=~clk;
	logic[w:0] i;
	initial begin
		$monitor($time,, "i=%b, s_in = %b, clr = %b, en = %b, q = %b" ,i,s_in,clr,en,q);
	#1 en = 0; clr =0; s_in = 0;
	@(posedge clk);
	for(i=0; i<16; i++) begin	
		
		#1 en=1;s_in = i[3];
		@(posedge clk);
		#1 en=0;
		@(posedge clk);
		
		#1 en=1;s_in = i[2];
		@(posedge clk);
		#1 en=0;
		@(posedge clk);
		
		#1 en=1;s_in = i[1];
		@(posedge clk);
		#1 en=0;
		@(posedge clk);
		
		#1 en=1;s_in = i[0];
		@(posedge clk);
		#1 en=0;
		@(posedge clk);
	
		#1 $display("Message recieved");
		#1 clr=1;
		@(posedge clk);
		#1 clr=0;
		@(posedge clk);
	  end
	#10 $finish;
end
endmodule: test_SIPO
		
module testbench_SIPO;
	logic s_in,clk,clr,en;
	logic [3:0] q;

	shift_register_SIPO #(4) SIPO(.*);
	test_SIPO #(4) test(.*);		
endmodule: testbench_SIPO

module test_PISO
 #(parameter w = 4)
 (output logic [w-1:0] d,
	output logic clk, load, en,
	input logic s_out);

	initial clk=0;
	always #10 clk=~clk;
	logic[w:0] i;
	initial begin
		$monitor($time,, "d=%b, load = %b, en = %b, s_out = %b" ,d,load,en,s_out);
	#1 en = 0; load =0;
	@(posedge clk);
	for(d=0; d<15; d++) begin	
//#1 d='d15;
		#1 load =1; $display("New Message");
		@(posedge clk);
		
		#1 load=0; en=1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#1 en=0; $display("Message sent");
		@(posedge clk);
	  
	  end
	#10 $finish;
end
endmodule: test_PISO
		
module testbench_PISO;
	logic s_out,clk,load,en;
	logic [3:0] d;

	shift_register_PISO #(4) SIPO(.*);
	test_PISO #(4) test(.*);		
endmodule: testbench_PISO

module test_counter
  #(parameter w=4)
  (output  logic clk, up,
	 output logic en, clr, load,
	 output logic [w-1:0] d,
	 input logic [w-1:0] q);
	 
	 initial clk=0;
	 always #10 clk=~clk;
	 
	 initial begin
	   $monitor($time,, "clr = %b, load = %b, en = %b, up = %b, d = %d, q = %d" ,clr,load,en,up,d,q);
	   
	   #1 clr=0; load=0; up=0; en=0; d=0; ///clr,load,enable : 000
	   @(posedge clk);
	   #1 load=1; ///010
	   @(posedge clk);
	   
	   #1 en=1; up=1; //011
	   @(posedge clk);
	   #1 load =0;///001
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   #1 up=0;  //Still 001
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   #1 clr=1; load=1; d='b1; //111
	   @(posedge clk);
	   @(posedge clk);
     #1 load=0; clr=1;//101
 	   @(posedge clk);
	   @(posedge clk);
	   #1 load=1; en=0; d= 'd2;//110
	   @(posedge clk);
	   @(posedge clk);
	   #1 load=0;clr=1; //100
	   @(posedge clk);
	   @(posedge clk);
     #1 $finish;
  end
	   	 
endmodule: test_counter

module testbench_counter;
	logic en,clk,clr,load,up;
	logic [1:0] d, q;

	counter #(2) count(.*);
	test_counter #(2) testcount(.*);		
endmodule: testbench_counter


module test_BCD
  #(parameter w=4)
  (output  logic clk, up,
	 output logic en, clr, load,
	 output logic [7:0] d,
	 input logic [7:0] q);
	 
	 initial clk=0;
	 always #10 clk=~clk;
	 
	 initial begin
	   $monitor($time,, "clr = %b, load = %b, en = %b, up = %b, d = %h, q = %h" ,clr,load,en,up,d,q);
	   
	   #1 clr=0; load=0; up=0; en=0; d=0; ///clr,load,enable : 000
	   @(posedge clk);
	   #1 load=1; ///010
	   @(posedge clk);
	   
	   #1 en=1; up=1; //011
	   @(posedge clk);
	   #1 load =0;///001
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   #1 up=0;  //Still 001
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);
	   #1 clr=1; load=1; d='h1; //111
	   @(posedge clk);
	   @(posedge clk);
       #1 load=0; clr=1;//101
 	   @(posedge clk);
	   @(posedge clk);
	   #1 load=1; en=0; d= 'd2;//110
	   @(posedge clk);
	   @(posedge clk);
	   #1 load=0;clr=1; //100
	   @(posedge clk);
	   @(posedge clk);
 
	   #1 clr=0;load=1;d='h99;
	   @(posedge clk);
	   #1 en=1; up=1; load=0;
	   @(posedge clk);
	   @(posedge clk);
	   #1 up=0; 
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);

	   #1 load=1;d='h19;
	   @(posedge clk);
	   #1 en=1; up=1; load=0;
	   @(posedge clk);
	   @(posedge clk);
	   #1 up=0; 
	   @(posedge clk);
	   @(posedge clk);
	   @(posedge clk);


     #1 $finish;
  end
	   	 
endmodule: test_BCD

module testbench_BCD;
	logic en,clk,clr,load,up;
	logic [7:0] d, q;

	counter_BCD BCD(.*);
	test_BCD testBCD(.*);		
endmodule: testbench_BCD
