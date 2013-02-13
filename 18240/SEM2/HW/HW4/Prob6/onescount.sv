module OnesCount
  #(parameter w = 30)
  (input  logic d_in_ready, clk, reset,
   input  logic [w-1:0] d_in,
   output logic [$clog2(w)-1:0] d_out,
   output logic d_out_ready);

logic lowBit;
logic Cclr, Cinc;
logic Oload, Oclr;
logic [$clog2(w)-1:0] BCount;
logic load;
logic [w-1:0] d_reg;

fsm #(w) control (.*);

counter #($clog2(w)) BitC (clk, Cclr, Cinc, BCount);

counter #($clog2(w)) OneC (clk, Oclr, Oinc, d_out);

mux #(w) m(d_reg, BCount, lowBit);

register #(w) DINreg (clk, load, d_in, d_reg);

endmodule: OnesCount

module testbench
#(parameter w = 30) 
  (output logic d_in_ready, clk, reset, 
   output logic [w-1:0] d_in,
   input logic [$clog2(w)-1:0] d_out,
   input logic d_out_ready);
   
    initial clk =0;
    always #10 clk=~clk;

    initial begin
       $monitor ($time, "d_in_ready =%b, d_in = %b, d_out=%d, d_out_ready=%b", d_in_ready, d_in, d_out, d_out_ready);
	d_in = 30'd19; d_in_ready =1;

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
	 @(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
        @(posedge clk);
         @(posedge clk);
        @(posedge clk);
        @(posedge clk);
	@(posedge clk);
	$finish;
	end
endmodule: testbench

module top;

logic d_in_ready, clk, reset;
logic [29:0] d_in;
logic [4:0] d_out;
logic d_out_ready;

OnesCount o(.*);
testbench t(.*);

endmodule: top




