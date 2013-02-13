module PatrolBoat
(output logic hit, nearmiss, miss,
  input logic [3:0]x, 
       logic [3:0]y);
 // hit=1'b0;
  //nearmiss=1'b0;
  //miss=1'b0;
  always_comb
  case({x,y})
  8'b0010_1001: hit=1'b1;
  8'b0011_1001: hit=1'b1;
  8'b0110_0001: hit=1'b1;
  8'b0111_0001: hit=1'b1;
    default:  miss=1'b1;
  endcase
endmodule

module test
  (input hit, nearmiss, miss,
    output logic [3:0]x,
           logic [3:0]y);

initial begin
  $monitor($time,, "x=%b, y=%b, hit=%b, nearmiss=%b, miss=%b", x,y,hit,nearmiss,miss);
  x=3'd0; y=3'd0;
  
  #10 x=3'd9; y=3'd2;
  #10 x=3'd0; y=3'd0;
  #10 x=3'd9; y=3'd3;
  #10 x=3'd0; y=3'd0;
  #10 x=3'd1; y=3'd6;
  #10 x=3'd0; y=3'd0;
  #10 x=3'd1; y=3'd7;
end
endmodule

module top; 
  logic[3:0]x;
  logic[3:0]y;
  logic hit, nearmiss, miss;
PatrolBoat p(.*);
test       t(.*);
endmodule