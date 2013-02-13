module testfig4_12
	(output logic X, Y, Z,
	 input logic F);

	initial begin
	$monitor ($time,, "X=%b, Y=%b, Z=%b, F=%b", X, Y, Z, F);
	X = 1; Y = 1; Z = 1;
	#20 X = 0; Y = 0; Z = 0;
	#20 $finish;
	endmodule
