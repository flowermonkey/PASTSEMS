/* 
 *
 * Lab 2a: Testing
 *
 * This verilog file contains a set of "buggy" black-box modules
 * that you will test for bugs. Your task is to systematically
 * test the modules and tell us which modules contain the bugs
 * and what they are.
 *
 * Note: you may NOT modify any of the modules named "Adder",
 * "Subtractor", or "Comparator". You should test your design
 * using the test_design module skeleton that has been
 * created for you.
 * 
 * The correct functionality of the top-level circuit is:
 * 
 *    out = (a + b) < (c - d)
 * 
 * Assume that all numbers are in two's complement.
 * 
 * The TAs will provide you with files "add.vm", "sub.vm", and
 * "comp.vm", which should be kept in the same directory as
 * this file when you simulate the Verilog.
 *
 *
 */



module top(output [3:0]out, input [3:0] a, b, c, d);
  wire [3:0] sub_result, add_result;

  //Adder 	add(out, a, b);
  Adder 	add(add_result, a, b);
  
  //Subtractor 	sub(out, c, d);
  Subtractor 	sub(sub_result, c, d);
  Comparator 	comp(out, add_result, sub_result);
endmodule




module system();
  wire [3:0] a, b, c, d;
  //original
  //wire       out;
  wire [3:0] out;

  top 		t(out, a, b, c, d);
  test_design 	td(out, a, b, c, d);
endmodule




module test_design(input [3:0] out, output [3:0] a, b, c, d);
 
// begin
 logic [3:0] i;
 logic [3:0] j;
 logic [3:0] k;
 logic [3:0] l;
 
 assign a=i,
        b=j, 
        c=k,
        d=l;
 
 initial
 begin
  $monitor($time,, "out = %b,a=%b, b = %b, c = %b, d = %b", out,a, b, c, d);
 
 for(i = 0; i<15;i++)
  for(j = 0; j<15;j++)
    for(k = 0; k<15;k++)
      for(l = 0; l<15;l++)
        #1;   
  //a = 0;
  //b = 0;
  //c = 0;
  //d = 0;
 end
endmodule

module Adder(output [3:0] out, input [3:0] a, b);
  /* DO NOT CHANGE THIS MODULE */
  reg [3:0] mad[255:0];
  assign out = mad[{a, b}];

  initial begin
    $readmemh("add.vm", mad);
  end
endmodule /* Adder */




module Subtractor(output [3:0] out, input [3:0] a, b);
  /* DO NOT CHANGE THIS MODULE */
  reg [3:0] msb[255:0];
  assign out = msb[{a, b}];

  initial begin
    $readmemh("sub.vm", msb);
  end
endmodule /* Subtractor */




module Comparator(output out, input [3:0] addin, subin);
  /* DO NOT CHANGE THIS MODULE */
  reg mcmp[255:0];
  assign out = mcmp[{addin, subin}];

  initial begin
    $readmemh("comp.vm", mcmp);
  end
endmodule /* Comparator */
