module func
  (input logic a,b,c,d,e,f,
  output logic valid  );

	nand #1		g1(f1,na,nb,nc,nd,ne,f),
			     g2(f2,na,nb,c,e,f),
		      	g3(f3,na,b,nc,e,f),
			     g4(f4,na,b,d,nf),
		      	g5(f5,na,b,c,nd),
			     g6(f6,a,nb,c,f),
	       		g7(f7,b,ne,nf),
			     g8(f8,c,nd,ne),
		      	g9(f9,a,nf),
			     finalG(valid, f1,f2,f3,f4,f5,f6,f7,f8,f9);
    
  
	not	     ga(na,a),
			     gb(nb,b),
			     gc(nc,c),
		      	gd(nd,d),
			     ge(ne,e),
	       		gf(nf,f);      

endmodule


/*module Tester (output logic a, b, c, d, e, f, input valid);

initial begin $monitor ($time,, "a=%b,b=%b,c=%b,d=%b,e=%b,f=%b, valid=%b", a, b, c, d, e, f, valid);
a = 0; b = 0; c = 0; d = 0; e = 0; f = 0;
#2 e=1;
#2 f=1;
#2 d=1;
#2 f=0;
#2 e=0;
#2 f=1;
#2 d=0; f=0; e=1; c=1; 
#2 e=0; d=1;
#2 f=1;
#2 f=0; e=1;
#2 f=1; b=1;
#2 e=0;
#2 c=0;
#2 d=0;
#2 f=0; e=1;
#2 f=1; a=1;
#2 e=0;
#2 d=1;
#2 e=1;
#2 c=1;
#2 e=0;
#2 e=1;d=0;
#2 b=0; c=0;
#2 e=0;
#2 d=1;
#2 e=1;
#2 $finish;
end
endmodule*/


module Top(a, b, c, d, e, f, valid);
	input a,b,c,d,e,f;
	output valid;
    
	func q(.*);
	/*Tester t(.*);*/

endmodule