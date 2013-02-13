module tiCalcTB(input bit [7:0] display,
input bit error,
output keyStroke_t keyIn,
output bit rst_b,clk);


initial begin
	clk =0;
	forever #5 clk = ~clk;
	end

initial begin
	rst_b = 0; keyIn.op = NONE; keyIn.num= 0;
//tests:
// 1.) 8NN - 4 + 2 + 2 =  C
// 2.) 8 - ( 4 + 1 ) - 1 =  
	#10 
	keyIn.op= NUMBER; keyIn.num=8;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NEGATE; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NEGATE; keyIn.num=8;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= MINUS; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NUMBER; keyIn.num=4;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= PLUS; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NUMBER; keyIn.num=2;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= PLUS; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NUMBER; keyIn.num=2;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= EQUALS; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NONE; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= CLEAR; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);

//////////////////////////////////////////////////////	
//2.)
	
	#10 
	keyIn.op= NONE; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NUMBER; keyIn.num=8;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= MINUS; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10
	keyIn.op= LP; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10
	keyIn.op= NUMBER; keyIn.num=4;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= PLUS; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NUMBER; keyIn.num=1;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= RP; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= MINUS; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NUMBER; keyIn.num=1;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= EQUALS; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10 
	keyIn.op= NONE; keyIn.num=0;
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	#10
	$display($stime,, " op= %d, num= %d, error= %d, display=%d ",keyIn.op,keyIn.num,error,display);
	
	$finish;	
	end
endmodule: tiCalcTB
