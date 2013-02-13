module dff(
  output logic q,
  input logic d, clk, rst);
  
  always @(posedge clk) begin
    if (rst == 1)
      q<=0;
    else
      q<=d;
    end
endmodule

  