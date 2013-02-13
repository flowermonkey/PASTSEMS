module fig4_12
	(output logic F,
	 input logic X, Y, Z);

	and #6	g1 (f1, X, Z),
		g2 (f2, nY, Z),
		g3 (f3, nX, Y, nZ);
	or #6	(F, f1, f2, f3);
	not #4	g4 (nY, Y),
		g5 (nX, X),
		g6 (nZ, Z);
endmodule
