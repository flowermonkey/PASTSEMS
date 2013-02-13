module Problem9
  (input logic [1:0]g,
   input logic clk, reset,
   output logic y, valid);
   
enum logic [2:0] {A1=3'd0, A2=3'd1, A3=3'd2, A4=3'd3, 
            B1=3'd4, B2=3'd5, B3=3'd6, B4=3'd7} state, nextState;
always_ff@(posedge clk, negedge reset)
  if (~reset)
    state <= A1;
  else state <=nextState;
    
always_comb    
  case(state)
    A1: begin
        if (g == 2'd3)nextState= B1;
        if (g == 2'd1)nextState = A2;
        else nextState = A1;
        end
    A2: begin
        if (g == 2'd0)nextState= A3;
        else nextState = A1;
        end
    A3: begin
        if (g == 2'd0)nextState= A4;
        else nextState = A1;
        end
    A4: begin
        if (g == 2'd0)nextState= B1;
        else nextState = A1;
        end
    B1: begin
        if (g == 2'd3)nextState= B2;
        else nextState = B1;
        end
    B2: begin
        if (g == 2'd0)nextState= B3;
        else nextState = B1;
        end
    B3: begin
        if (g == 2'd0)nextState= B4;
        else nextState = B1;
        end
    B4: begin
        if (g == 2'd3)nextState= A1;
        else nextState = B1;
        end 
  endcase
  
always_comb begin
  if (state == B1 ||state == B2||state == B3||state == B4) 
    valid = 1;
    else
    valid = 0;
  if (state == B1 ||state == B2||state == B3||state == B4) 
    y = g[0];
  else
    y = 0;
end
endmodule

module testbench;
  logic [1:0]g;
  logic clk, reset;
  logic  y, valid;
  logic [26:0] testcode1, testcode2;
  logic i;
  
  initial begin
    $monitor ($time,, "g=%b, fully: feState= %s, y=%b, valid = %b", g, fe.state.name, y, valid);
    clk = 0;
    reset = 0;
    forever #5 clk=~clk;
  end
  
  initial begin
    testcode1 = 27'b000000100010100110101000000;
    for (i =0 ; i<28 ; i++)
      g[0] <= testcode1[i];
      g[1] <= 0;
      @(posedge clk);
      $finish;
    end
    
  initial begin
    testcode2 = 27'b010001010101010101010101010;
    for (i=0; i<28; i++)
      g[0] <= testcode2[i];
      g[1] <= 0;
      @(posedge clk);
    $finish;
  end
 Problem9  fe(.*);
  
  
endmodule: testbench