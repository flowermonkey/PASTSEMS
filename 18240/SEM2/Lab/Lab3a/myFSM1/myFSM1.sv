module myFSM1 (
  input logic [3:0] h_move,
  input logic       clk, rst,
  output logic [3:0] c_move);
  
  enum logic [2:0] {A=3'd0, B=3'd1, C=3'd2, D=3'd3, E=3'd4, F=3'd5} current, next;
  
  always_comb begin
    next=current;
    unique case(current)
      A: begin
        if(h_move==7)
          begin
            next = B;
          end
        else
          next=current;
        end
      B: begin 
        if(((h_move==0)||(h_move==1)||(h_move==3)||(h_move==5)||(h_move==8)))
        begin
          next = C;
        end
        else if (h_move==6)begin
          next = D;
        end
        else begin
          next = current;
        end
      end
      
      C: begin
          next=current;  
        end    
      D: begin
        if(((h_move==1)||(h_move==3)||(h_move==5)))
        begin
          next = E;
        end
        else if (h_move==0)begin
          next = F;
          end
        else begin
          next = current;
        end
      end
      
      E: begin
        next =current;
      end
      
      F: begin
        next=current;
      end
    endcase
end
  always_comb begin
    c_move=0;
    unique case(current)
      A: c_move=4;
      B: c_move=2;
      C: c_move=6;
      D: c_move=8; 
      E: c_move=0;
      F: c_move=5;
      default: c_move=0;
    endcase
end


always_ff @ (posedge clk) begin
  if(rst) begin
    current <=A;
  end else begin
    current<=next;
  end
end
endmodule

module top1(
  output logic displayA,
  output logic [7:0] sevenSegmentDisplay,
  input logic [3:0]h_move,
  input logic clk, rst,
  output logic [3:0] c_move);
  
  wire [7:0]displayValuesA;
  
  BCDtoSevenSeg  bcd(displayValuesA, c_move);
  myFSM1 fsm(.*);
  LEDController LED(.displayValuesA(displayValuesA),.displayValuesB(),.displayValuesC(),.displayValuesD(), .clock(clk), .reset(rst), .displayA(displayA), .displayB(), .displayC(), .displayD(), .sevenSegmentDisplay(sevenSegmentDisplay));
  
  
endmodule  

module test;
  logic clk, rst;
  logic [3:0] c_move; 
  logic q2, q1, q0;
  logic [3:0]h_move;
  
    
  myFSM1 fsm(.*);
  fsmtestbench t(.*);
endmodule  
