//Problem 4
//bflores

module top;

wire w;
logic A,B;
bit enable_A, enable_B;

notif0 bufA(w,A,enable_A),
	   bufB(w,B,enable_B);

tb_prob4 tb(.*);

endmodule:top

module tb_prob4 (input wire w, 
				 output logic A,B,
				 output bit enable_A,enable_B);

	int i,j;
initial begin
	$monitor($stime,,"A,A_enable= %b%b , B,B_enable= %b%b, out=%b",
		A,enable_A,B,enable_B,w);
	
	{A,enable_A,B,enable_B} = 4'd0;

	for(i=0;i<4;i++)begin
		for(j=0;j<4;j++)begin
				#5
				{A,enable_A} = i;
				{B,enable_B} = j;
			end
		end
	#5$finish;
end

endmodule:tb_prob4


