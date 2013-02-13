module mux (input bit a, b, sel,
			output bit x);
	assign x = (sel)?a:b;
endmodule : mux

module test_mux; 
	bit x,a,b,sel;
	logic [3:0] i;

	mux M(.*);
	
	initial begin
		for(i=0; i!=8; ++i)
			#2 $display("i=%b, x=%b, sel=%b, a=%b, b=%b",i,x,sel,a,b);
	end
	assign a = i[2], b = i[1], sel = i[0];

endmodule : test_mux
