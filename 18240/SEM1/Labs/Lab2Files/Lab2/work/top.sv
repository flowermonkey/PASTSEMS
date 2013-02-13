module top(switches,
	   barled,
	   sevenSegmentDisplay, displayA, displayB, displayC, displayD,
	   clock, reset);

   input[3:0]switches;
   output [3:0] barled;
   output [7:0] sevenSegmentDisplay;
   output 	displayA, displayB, displayC, displayD;
   input 	clock, reset;

   wire [7:0] 	disp;

   BCDtoSevenSeg MyDisplay ( .led(disp), .bar(barled), .bcd(switches));


   LEDController lc(.displayValuesA(disp), .displayValuesB(8'h61),
		    .displayValuesC(8'h63), .displayValuesD(8'h61),
		    .clock(clock), .reset(reset),
		    .displayA(displayA), .displayB(displayB),
		    .displayC(displayC), .displayD(displayD),
		    .sevenSegmentDisplay(sevenSegmentDisplay) );

endmodule // top
