module BCDtoSevenSeg
  (output		reg	[7:0]	led,
    output		reg	[3:0]	bar,
    input [3:0] 			bcd);

  //decimal place p said not to matter
  //so p bit is always 1(off)
  always_comb
  case(bcd)
    0: led = 8'b00000011;
    1: led = 8'b10011111;
    2: led = 8'b00100101;
    3: led = 8'b00001101;
    4: led = 8'b10011001;
    5: led = 8'b01001001; 
    6: led = 8'b01000001; 
    7: led = 8'b00011111; 
    8: led = 8'b00000001; 
    9: led = 8'b00011001; 
    default:led= 8'b00000011;
  endcase
  
  assign bar = bcd;
endmodule // BCDtoSevenSeg
