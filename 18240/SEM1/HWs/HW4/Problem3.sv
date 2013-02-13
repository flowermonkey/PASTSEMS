module compare
  #(parameter W=1)
    (input logic [W-1:0]a,b,
     input logic c,
    output logic eq, aGT, bGT);
    
  always_ff@(posedge c) begin
    if (a-b==0)
      eq <= 1;
    else if (a-b>0)
      aGT <= 1;
    else
      bGT <= 1;
  end
endmodule

module add
  #(parameter W=1)
  (input logic [W-1:0] a,b,
   input logic c,
    output logic [W-1:0]sum);
  always_ff@(posedge c)
  sum <= a+b;
endmodule 

module decRegister
  #(parameter W=1)
  (input logic c, ld, dec, 
   input logic [W-1:0]newVal,
    output logic [W-1:0]Val);
  always_ff@(posedge c) begin
    if (ld==1)
        newVal <= Val;
    else
      Val <= newVal - 1;
  end
endmodule 

module register
  #(parameter W=1)
  (input logic c, ld, reset_l,cl,
   input logic [W-1:0] newVal,
    output logic [W-1:0]Val);
    
  always_ff@(posedge c) begin
    if (ld==1)
      newVal <= Val;
    else if ((cl | ~reset_l) == 1)
      Val<=0; 
  end
endmodule