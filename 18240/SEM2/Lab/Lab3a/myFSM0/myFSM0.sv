module myFSM0(
     input logic [3:0] h_move,
     output logic [3:0] c_move,
     output logic q0,q1,q2,
     input logic clk, rst);

    logic d2, d1, d0;
    dff ff2(.q(q2), .d(d2), .clk(clk), .rst(rst));
    dff ff1(.q(q1), .d(d1), .clk(clk), .rst(rst));
    dff ff0(.q(q0), .d(d0), .clk(clk), .rst(rst));
    always_comb begin
               if (({q2,q1,q0}==3'b000) && (h_move==7))begin
                      d2=0;
                      d1=0;
                      d0=1;
                end

              else if(({q2,q1,q0}==3'b001) && ((h_move==0)||(h_move==1)||(h_move==3)||(h_move==5)||(h_move==8)))begin
                    d2=0;
                    d1=1;
                    d0=0;
                  end
              else if(({q2,q1,q0}==3'b001) && (h_move==6))begin
                     d2=0;
                     d1=1;
                     d0=1;          
                  end

              else if(({q2,q1,q0}==3'b011) && ((h_move==1)||(h_move==3)||(h_move==5)))begin
                   d2=1;
                   d1=0;
                   d0=0;
                end 
                else if(({q2,q1,q0}==3'b011) && (h_move==0))begin
                   d2=1;
                   d1=0;
                   d0=1;
               end

        else begin
                  d2=q2;
                  d1=q1;
                  d0=q0;
        end  
    end

     always_comb begin
            if({q2,q1,q0}==3'b000)
               c_move=4'b0100;
          else if({q2,q1,q0}==3'b001)
             c_move=4'b0010;
          else if({q2,q1,q0}==3'b010)
              c_move=4'b0110;
          else if({q2,q1,q0}==3'b011)
               c_move=4'b1000;
          else if({q2,q1,q0}==3'b100)
               c_move=4'b0000;
          else if({q2,q1,q0}==3'b101)
             c_move=4'b0101;
     end
endmodule

module dff(
  output logic q,
  input logic d, clk, rst);
  always begin @(posedge clk)
    if (rst == 1)
      q<=0;
    else
      q<=d;
    end
endmodule

module top;
  logic clk, rst;
  logic [3:0] c_move; 
  logic q2, q1, q0;
  logic [3:0]h_move;
  
    
  myFSM0 fsm(.*);
endmodule  