module mux
	(output logic f,
	input a,b,sel);

	assign f = (sel)?b:a;
endmodule

module testbench(output logic a,b,sel,
	input f);

	initial begin
	$monitor($time, "> a=%d, b=%d, sel=%d => f=%d ", a,b,sel,f);
	a=0;b=0;sel=0;

	#1 a=1; 
	#1 b=1;
	#1 a=0; 
	#1 sel=1; 
	#1 a=1; 
	#1 b=0;
	#1 a=0; 
	#1 $finish;
	end
endmodule

module top;
	bit a,b,sel,f;
	mux m(.*);
	testbench t(.*);

endmodule
