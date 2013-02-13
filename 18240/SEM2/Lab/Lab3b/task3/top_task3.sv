module top_task3;

logic clk, reset, serial_in,serial_out, new_message; 
logic [63:0] message_bytes;
int i;
string mess = "\n";

initial clk =0;
always #10 clk=~clk;

assign serial_in= serial_out;

initial begin
for(i=4'd0; i <'d5000;i++) begin
	@(posedge clk);
	if (new_message)begin
		$display("message_bytes: %h",message_bytes);
		mess={mess,message_bytes};
	  end
  end
  $display("message is: %s \n", mess);
  $finish;
end
	
decryptionService d(.*);
sendEncrypted s(.*);

endmodule: top_task3
