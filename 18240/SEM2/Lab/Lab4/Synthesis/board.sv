/*
 * File: board.v
 * Created: 03 October 2009
 * Modules contained: barDisplay, sevenSegDisplay, HEXtoSevenSeg
 * 
 * Changelog:
 * 08 October 2009: Changed some names (mcbender)
 * 07 October 2009: Formatting and style changes (mcbender)
 * 03 October 2009: Moved all modules pertaining to board display from
 * modules.v to board.v (mcbender).
 * 12 October 2009: Fixed spacing and removed tabs (mcbender)
 * 31 October 2009: Fixed port & variable naming style (mcbender)
 * 13 Oct 2010: Updated always to always_comb and always_ff.Renamed to.sv(abeera) 
 * 17 Oct 2010: Updated to use enums instead of define's (iclanton)
 * 24 Oct 2010: Updated to use struct (abeera)
 * 9  Nov 2010: Slightly modified variable names (abeera)

*/

`include "constants.sv"

/* 
 * module: barDisplay
 * 
 * This module assigns the bar LED display based on the selection DIP
 * switches.  See lab handout for details on how to control the output. 
 */
module barDisplay(
   output [7:0] leds,
   input [2:0]  switches,
   input controlPts controlPoints,
   input [3:0]  condCodes,
   input [2:0]  regSelA,
   input [2:0]  regSelB,
   input [9:0]  currState,
   input [9:0]  nextState,
   input        clock);
   
   logic [15:0] out;    
   logic [6:0] disp1;
   logic [6:0] disp2;
   
   
   assign leds = (switches[0]) ? ~out[15:8] : ~out[7:0];
   assign disp1={controlPoints.srcA,controlPoints.srcB,controlPoints.srcA,controlPoints.dest};//controlPoints[9:3]
   assign disp2=~{controlPoints.lcc_L,controlPoints.re_L,controlPoints.we_L};//~controlPoints[2:0]
   
   // this function now displays the ALUop code (the highest bits of
   // CPoints) when switches[2:1] = 10
   
   always_comb
     case(switches[2:1])
       2'b00: out = {4'b0,clock,1'b0,disp1,disp2};
       2'b01: out = {1'b0,regSelA,1'b0,regSelB,4'b0,condCodes};
       2'b10: out = {2'b0,controlPoints.alu_op,currState};
       2'b11: out = {6'b0,nextState};
       default: out = 16'b0;
     endcase
endmodule

/* 
 * module: sevenSegDisplay 
 * 
 * This module assigns the seven-segment LED display based on the selection DIP
 * switches.  See lab handout for details on how to control the output.
 * 
 * Changelog:
 * 9 June 1999 : Added SP viewing 
 */
module sevenSegDisplay(
   output [7:0] sevenseg1,
   output [7:0] sevenseg2,
   input [4:0]  switches,
   input [15:0] aluSrc1,
   input [15:0] aluSrc2,
   input [15:0] aluOut,
   input [15:0] irVal,
   input [15:0] pcVal,
   input [15:0] marVal,
   input [15:0] mdrVal,
   input [15:0] viewReg,
   input [15:0] spVal);
   
   logic [15:0] out;
   logic [7:0] disp_val;
   assign disp_val = (switches[0]) ? out[15:8] : out[7:0];
   
   HEXtoSevenSeg digit1(.led(sevenseg1), .digit(disp_val[7:4]));
   HEXtoSevenSeg digit2(.led(sevenseg2), .digit(disp_val[3:0]));
   
   always_comb
      if (switches[4]) 
         out = viewReg;
      else
         case(switches[3:1])
            3'b000: out=aluSrc1;
            3'b001: out=aluSrc2;
            3'b010: out=aluOut;
            3'b011: out=irVal;
            3'b100: out=pcVal;
            3'b101: out=marVal;
            3'b110: out=mdrVal;
            3'b111: out=spVal;
            default: out = 16'b0;
       endcase
endmodule

/* 
 * module: HEXtoSevenSeg
 * 
 * This module takes a hex (not decimal) value, 
 * and converts it into the control bits for the 7-seg LED
 * to light that hex digit.
 */
module HEXtoSevenSeg (
   output logic [7:0] led,
   input [3:0]      digit);
   
   always_comb
     case (digit)
       0:  led='h81;
       1:  led='hcf;
       2:  led='h92;
       3:  led='h86;
       4:  led='hcc;
       5:  led='ha4;
       6:  led='ha0;
       7:  led='h8f;
       8:  led='h80;
       9:  led='h8c;
       10: led='h88;
       11: led='he0;
       12: led='hb1;
       13: led='hc2;
       14: led='hb0;
       15: led='hb8;
       default: led='hfd; // light only the middle dash
     endcase
endmodule
