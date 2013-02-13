/*
 * Lab 3b: Transmitter for task 3, encrypted transmission
 *
 */

module sendEncrypted(
  input clk,
  output serial_out);
  
  parameter WORDS = 153, WORD_SIZE = 23;
  reg [WORD_SIZE-1:0] message_rom [WORDS-1:0];
  reg [12:0] word_counter;
  reg [5:0] bit_counter;
  reg sout;

  assign serial_out = sout;

  initial begin
    $readmemb("lab3b_task3.vm", message_rom);
    sout = 0;
    word_counter = 0;
    bit_counter = WORD_SIZE-1;
  end
    
  always @(posedge clk) begin
     if (word_counter < WORDS) 
       sout <= message_rom[word_counter][bit_counter];
     else
       sout <= 0;

     if (bit_counter == 0) begin
       bit_counter = WORD_SIZE -1;
       word_counter = word_counter + 1;
       end
     else
       bit_counter = bit_counter - 1;
  end
endmodule