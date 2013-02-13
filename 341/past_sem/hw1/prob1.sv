//Problem 1
//bflores

initial begin
	always_comb begin
	a=z;
	#4 a<=1;
	#4 a<=0;
	#4 a<=x;
	#8 $finish;
	end
end
