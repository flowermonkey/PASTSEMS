module tb;
   logic clk, g;
   
   initial begin
    g<=0;
    repeat(20) @(posedge clk);
    $finish;
    end
endmodule: tb

module Problem10
        (input logic curr, clk,
         output logic last);
enum logic [14:0] {}
    