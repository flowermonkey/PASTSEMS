////////////////////////////////////////////////////////////////////////////////
// Company: Carnegie Mellon University
// Engineer: kfleming
//
// Create Date:    20:54:52 06/22/05 (updated 9/8/07 for decoded inputs)
// Module Name:    top
// Project Name:   BoardTester
// Target Device:  Spartan-3 Starter Board  
// Description:    This module is a driver for the Spartan-3 Starter Board it will take
//                 8-bit pre-decoded inputs and display them to the Seven Segement display banks
//                 This module uses a 50Mhz clock to   
//
// Dependencies:   None
// 
// Revision:
// Revision 0.01 - File Created
// 13 Oct 2010: Updated always to always_comb and always_ff.Renamed to.sv(abeera) 
// Additional Comments:
//              module LEDController(displayValuesA, displayValuesB, displayValuesC, displayValuesD, 
//                       clock, reset, displayA, displayB, displayC, displayD, sevenSegmentDisplay);
////////////////////////////////////////////////////////////////////////////////

//Module:      LEDController
//
//Inputs:      displayValuesA [7:0] - The value to display on seven segment display A
//             displayValuesB [7:0] - The value to display on seven segment display B
//             displayValuesC [7:0] - The value to display on seven segment display C
//             displayValuesD [7:0] - The value to display on seven segment display D
//             clock - 50Mhz system clock
//             reset - reset line
//
//Outputs:     displayA - display enable for display A
//             displayB - display enable for display B
//             displayC - display enable for display C
//             displayD - display enable for display D
//             sevenSegmentDisplay [7:0] - the encoded display line to be routed to the seven segment display
//
//Description: This module serves as a driver for the Spartan-3's seven segment display banks.  
//             It accepts four, 8-bit pre-decoded inputs which will be displayed on the seven segment displays.
//             This module uses the 50Mhz clock to time refreshes on the seven 
//             segment display bank.  Currently there are approxiamately 76 refreshes per second, per display  
//


module LEDController(
   input [7:0]       displayValuesA,
   input [7:0]       displayValuesB,
   input [7:0]       displayValuesC,
   input [7:0]       displayValuesD,
   input             clock,
   input             reset,
   output logic        displayA,
   output logic        displayB,
   output logic        displayC,
   output logic        displayD,
   output logic [7:0]  sevenSegmentDisplay);

   logic [17:0]        tickCount;
   logic [1:0]         state;

   always_ff @ (posedge clock)
     begin
     if(reset)
       begin
         state <= 2'b00;
         tickCount <= 0;
         displayA <= 0;
         displayB <= 0;
         displayC <= 0;
         displayD <= 0;
         sevenSegmentDisplay <= 0;
       end
     else
       case(state)
         2'b00: 
          begin
           if(tickCount == 18'h28000)
             begin
                state <= 2'b01;
                tickCount <= 0;
             end
           else
             begin 
                state <= 2'b00;
                tickCount <= tickCount + 1;
             end
           displayA <= 0;
           displayB <= 1;
           displayC <= 1;
           displayD <= 1;
           sevenSegmentDisplay <= displayValuesA;
           end
         2'b01:
           begin
           if(tickCount == 18'h28000)
             begin
                state <= 2'b10;
                tickCount <= 0;
             end
           else
             begin 
                state <= 2'b01;
                tickCount <= tickCount + 1;
             end           
           displayA <= 1;
           displayB <= 0;
           displayC <= 1;
           displayD <= 1;
           sevenSegmentDisplay <= displayValuesB;
           end
         2'b10:
           begin
           if(tickCount == 18'h28000)
             begin
                state <= 2'b11;
                tickCount <= 0;
             end
           else
             begin 
                state <= 2'b10;
                tickCount <= tickCount + 1;
             end           
           displayA <= 1;
           displayB <= 1;
           displayC <= 0;
           displayD <= 1;
           sevenSegmentDisplay <= displayValuesC;
           end
         2'b11:
           begin
           if(tickCount == 18'h28000)
             begin
                state <= 2'b00;
                tickCount <= 0;
             end
           else
             begin 
                state <= 2'b11;
                tickCount <= tickCount + 1;
             end           
           displayA <= 1;
           displayB <= 1;
           displayC <= 1;
           displayD <= 0;
           sevenSegmentDisplay <= displayValuesD;
           end
       endcase
     end
endmodule
