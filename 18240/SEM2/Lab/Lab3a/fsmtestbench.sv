module fsmtestbench(
  input logic [3:0] c_move, 
  output logic [3:0] h_move, 
  output logic clk, rst);
  
  initial clk = 0;
  always #10 clk = ~clk;
  
  initial begin
    $monitor($time,, "c_move=%d, h_move=%d", 
    c_move, h_move);  
    
    h_move = 'b0000; rst = 1;
    
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);   
    
    @(posedge clk);
    #1 rst = 0;
    h_move = 'b0000;
    @(posedge clk);
    #1 h_move = 'b0001;
    @(posedge clk);
    #1 h_move = 'b0010;
    @(posedge clk);
    #1 h_move = 'b0011;
    @(posedge clk);
    #1 h_move = 'b0100;
    @(posedge clk);
    #1 h_move = 'b0101;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 h_move = 'b1000;
    @(posedge clk);
    #1 h_move = 'b0111;
    
    @(posedge clk);
    #1 h_move = 'b0100;
    @(posedge clk);
    #1 h_move = 'b0010;
    @(posedge clk);
    #1 h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0000;
    
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;    
    @(posedge clk);
    #1 h_move = 'b0001;
    
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;    
    @(posedge clk);
    #1 h_move = 'b0011;
    
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;    
    @(posedge clk);
    #1 h_move = 'b0101;
    
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;    
    @(posedge clk);
    #1 h_move = 'b1000;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 h_move = 'b0010;
    @(posedge clk);
    #1 h_move = 'b0100;
    @(posedge clk);
    #1 h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 h_move = 'b1000;
    @(posedge clk);
    #1 h_move = 'b0001;
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 h_move = 'b0011;
    #1 rst =1; h_move = 'b0000;
    
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 h_move = 'b0101;
    @(posedge clk);
    #1 h_move = 'b0000;
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;

    @(posedge clk);
    #1 rst =0; h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 h_move = 'b0000;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0010;
    @(posedge clk);
    #1 rst=1; h_move = 'b0000;
    
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 h_move = 'b1000;
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0000;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    
    @(posedge clk);
    #1 rst =0; h_move = 'b0111;
    @(posedge clk);
    #1 h_move = 'b0110;
    @(posedge clk);
    #1 h_move = 'b0000;
    @(posedge clk);
    #1 h_move = 'b0101;
    @(posedge clk);
    #1 rst =1; h_move = 'b0000;
    
    @(posedge clk);
    #1 $stop;
    
end
endmodule