module register
#(parameter w = 30)
(input logic clk, load,
 input logic [w-1:0] data_in,
 output logic [w-1:0] data_out);

always_ff @(posedge clk)
  begin
    if (load)
      data_out <= data_in;
    else
      data_out <= data_out;
  end

endmodule: register
