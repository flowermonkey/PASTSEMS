module counter
  #(parameter  w = 4)
   (input  logic clk, clear,
    input  logic enable,
    output logic [w-1:0] q);
  always_ff @(posedge clk) 
    begin
      if (clear)
        q <= 0;
      else if (enable) 
        q <= q+1;
    end
endmodule: counter
