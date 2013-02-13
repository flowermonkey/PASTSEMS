module top;
	
	// When you compile your files do so in the following order:
	// yourcalc.sv top.sv testbench.sv
	// so that the keyStroke class can be used in each file.	

	bit rst_b, clk;
	keyStroke_t keyIn;
 	bit [7:0]  display;
  	bit error;
	
	tiCalcTB tb(.*);
	tiCalc calc(.*);

endmodule
