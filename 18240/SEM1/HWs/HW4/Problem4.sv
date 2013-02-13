module cksum
  #(parameter w=1)
  (input clock, reset_L,start,done,
   input [7:0] dIn,
    output cksumOK);
  
  fsm   f(.*);
  data d(.*);
endmodule

module fsm #(8)
  (input logic clock, reset_L,
    output logic ld, cl);
  
  enum logic [1:0] {A = 2'd1, B=2'd2, 2'd3} curr, next;
  
  always_comb begin
    case(curr)
      A: begin
        next = start ? B:A;
        ld = start ? 1:0;
        end
      B: begin
        next = done ? C:B;
        end
      C: begin
        next = ~reset_L ? A:curr;
        cl = ~reset_L ? 1:0;
        end
  end
  always_ff@(posedge clock, negedge reset_l)begin
    if(~reset_l) curr <=A;
    else curr <= next;
  end
endmodule

module data
  #(parameter w = 8)
  (input logic [w-1:0] dIn,
   input logic clock, reset_L, start, done
   output logic cksumOK);
   
   logic ld, cl;