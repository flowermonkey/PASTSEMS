module mux
  #(parameter w = 30)
  (input logic [w-1:0] in,
  input logic [$clog2(w)-1:0] sel,
  output logic out);
  
  assign out = in[sel];
  
endmodule: mux
