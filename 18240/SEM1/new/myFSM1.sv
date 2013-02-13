module myFSM1 (
  input logic [3:0] h_move,
  input logic       clk, rst,
  output logic [7:0] numHits);
  logic [3:0] c_move;
  enum logic [2:0] {A=3'd0, B=3'd1, C=3'd2, D=3'd3, E=3'd4, F=3'd5} current, next;
  
  always_comb begin
    next=current;
    case(current)
      A: begin
        if(h_move==1)
          begin
            next = B;
          end
        end
      B: begin 
        if(((h_move==0)||(h_move==3)||(h_move==5)||(h_move==7)||(h_move==8)))
        begin
          next = C;
        end
        else if (h_move==2)begin
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
        if(((h_move==3)||(h_move==5)||(h_move==7)))
        begin
          next = E;
        end
        else if (h_move==8)begin
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
      default: next = current;
    endcase
end
  always_comb begin
    c_move=0;
    unique case(current)
      A: c_move=4;
      B: c_move=6;
      C: c_move=2;
      D: c_move=0; 
      E: c_move=8;
      F: c_move=3;
    endcase
end


always_ff @ (posedge clk) begin
  if(rst) begin
    current <=A;
  end else begin
    current<=next;
  end
end


always_comb begin
        case(c_move)
                4'b0000: numHits = 8'b00000011;
                4'b0001: numHits = 8'b10011111;
                4'b0010: numHits = 8'b00100101;
                4'b0011: numHits = 8'b00001101;
                4'b0100: numHits = 8'b10011001;
                4'b0101: numHits = 8'b01001001;
                4'b0110: numHits = 8'b11000001;
                4'b0111: numHits = 8'b00011111;
                4'b1000: numHits = 8'b00000001;
                4'b1001: numHits = 8'b00011001;
                default numHits = 8'b11111111;
       endcase
      end
endmodule
module top1
 (input logic clk, rst,
  input logic [3:0]h_move,
  output logic [7:0] sevenSegmentDisplay,  
  output logic displayA, displayB, displayC, displayD,
  input logic [7:0]numHits);
  
  LEDController le(.displayValuesA(8'b11111111), .displayValuesB(numHits), 
                .displayValuesC(8'b11111111), .displayValuesD(8'b11111111),
                .clock(clk), .reset(rst), .displayA(displayA), 
                .displayB(displayB), .displayC(displayC), .displayD(displayD),
                .sevenSegmentDisplay(sevenSegmentDisplay));
  myFSM1 fsm(.*);
  //fsmtestbench tfsm(.*);
endmodule  