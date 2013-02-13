module top;

logic clk,serial_in, is_new,serial_out;
logic [7:0] message_byte;
initial  clk=0;
always #10 clk=~clk;
assign serial_in =serial_out;
always_comb begin
if (is_new)
	$display("message_byte = %s", message_byte);
end

sender send(.*);
receiver receive(.*);
//test t(.*);
endmodule: top

module test (input logic clk,
output logic serial_out);

initial begin
@(posedge clk);
serial_out = 0;
@(posedge clk);
serial_out = 0;
@(posedge clk);
serial_out = 0;
@(posedge clk);
serial_out = 1;

@(posedge clk);
serial_out = 0; 
@(posedge clk);
serial_out = 1;
@(posedge clk);
serial_out = 0;
@(posedge clk);
serial_out = 1; 
@(posedge clk);
serial_out = 0; 
@(posedge clk);
serial_out = 1; 
@(posedge clk);
serial_out = 0; 
@(posedge clk);
serial_out = 0; 
@(posedge clk);
serial_out = 0; 
@(posedge clk);
serial_out = 0; 
@(posedge clk);
serial_out = 0; 
@(posedge clk);
serial_out = 0;
@(posedge clk);
serial_out = 0; 

@(posedge clk);
serial_out = 0;
@(posedge clk);
@(posedge clk);
@(posedge clk);
end

endmodule


