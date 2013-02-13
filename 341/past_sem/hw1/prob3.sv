//Problem 3
//bflores

module top; 
	
	bit in, not1, not2, not3;

	my_not_1  n1(.*);
	my_not_2  n2(.*);
	not   	  n3(not3,in);
	tb_prob3  tb(.*);

endmodule: top

module tb_prob3 (output bit in,
				 input bit not1,not2,not3);
 initial begin
	$monitor($stime,," not1=%b,not2=%b, not3=%b",not1,not2,not3);
	
	in=1;    //0-6
	#6 in=0; //6-11
	#5 in=1; //11-12
	#1 in=0; //12-16
	#4 in=1; //16-17
	#1 in=0; //17-18
	#1 in=1; //18-25
	#7 $finish;
 end
endmodule:tb_prob3

module my_not_1 (input bit in, output bit not1);
 	always @(*) 
		not1 = #3 (~in); 
endmodule:my_not_1

module my_not_2 (input bit in, output bit not2);
 	always @(*) 
		#3 not2 = #3 (~in); 
endmodule:my_not_2
/*
            SIMULATION RESULTS

         0  not1=0,not2=0, not3=0
         6  not1=0,not2=0, not3=1
         9  not1=1,not2=0, not3=1
        11  not1=1,not2=0, not3=0
        12  not1=1,not2=0, not3=1
        14  not1=0,not2=0, not3=1
        16  not1=0,not2=0, not3=0
        17  not1=0,not2=1, not3=1
        18  not1=0,not2=1, not3=0
        23  not1=0,not2=0, not3=0
$finish called from file "../prob3.sv", line 27.
$finish at simulation time                   25
   V C S   S i m u l a t i o n   R e p o r t 
Time: 25
*/
