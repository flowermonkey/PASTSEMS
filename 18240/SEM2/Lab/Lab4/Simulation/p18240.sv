/*
 * File: p18240.v
 * Created: 11/13/1997
 * Modules contained: p18240_top
 * 
 * Changelog:
 * 9 June 1999 : Added stack pointer
 * 4/16/2001: Reverted to base code. (verBurg)
 * 4/16/2001: Added the "addsp" instruction. (verBurg)
 * 11/26/06: Removed old Altera-specific code that Xilinx tool had trouble with (P. Milder)
 * 3 Oc 2009: Cleaned up coding style and changed module name (mcbender)
 * 13 Oct 2009: Removed tabs and fixed spacing, added negedge trigger (mcbender)
 * 18 Oct 2009: Changed some constant names (mcbender)
 * 23 Oct 2009: Added LEDController (mcbender)
 * 31 Oct 2009: Fixed wire and instance naming style (mcbender)
 * 4 Nov 2009: Modified spacing slightly (mcbender)
 * 17 Nov 2009: Minor modification to facilitate synthesis (mcbender)
 * 13 Oct 2010: Updated always to always_comb and always_ff.Renamed to.sv(abeera) 
 * 17 Oct 2010: Updated to use enums instead of define's (iclanton)
 * 24 Oct 2010: Updated to use stuct (abeera)
 * 9  Nov 2010: Slightly modified variable names.
 *               Updated display to use enum (abeera)
 *
 * This is the baseline code that should be used at the beginning of
 * every semester.  It is finally all unified and brought up to date
 * (minus coding style differences).
*/

`include "constants.sv"

// Comment this line when simulating, uncomment when synthesizing.
//`define synthesis

/*
 * module p18240_top
 *
 * This is the top-level module for our implementation of the p18240 ISA.
 *
 */
module p18240_top(
   input        clock_pb,                //pushbutton clock
   input        reset_pb,                //pushbutton reset
   input        clock_board,             //board clock - for LEDController
   input        reset_board,             //board reset - for LEDController
   input [7:0]  switch0,
   input [7:0]  switch1, 
   output [7:0] sevenSegDisplay,
   output       en_displayA,
   output       en_displayB,
   output       en_displayC,
   output       en_displayD,
   output [7:0] barled);
   
   controlPts cPts;               // control points
   logic [3:0]  condCodes;                // condition codes (Z,C,N,V)
   logic [2:0]  regSelA, regSelB;         // destination, source
   logic [15:0] aluSrc1, aluSrc2, aluOut, pc, ir, sp, memAddr, memData, regView;
   opcode_t currState, nextState;
   logic [7:0]  sevenseg0, sevenseg1, sevenseg2, sevenseg3;
   
`ifdef synthesis
   logic clock, reset_L;
`else
   logic clock, reset_L;
`endif

//on the board, we'll use pushbuttons for clock and reset
`ifdef synthesis
   assign clock = clock_pb;
   assign reset_L = reset_pb;
//in simulation, we'll generate them this way
`else
   initial begin
      reset_L = 1;
      #2;
      reset_L = 0;
      #2;
      reset_L = 1;
   end
   initial begin              //posedge of the clock occurs on multiples of #10
      clock = 1;
      forever #5 clock = ~clock;
   end
`endif
   
   controlpath cp(
                 .out(cPts),
                 .CCin(condCodes),
                 .IRIn(ir),
                 .clock(clock),
                 .reset_L(reset_L),
                 .currState(currState),
                 .nextState(nextState));
   
   datapath dp(
              .ir(ir),
              .sp(sp),
              .condCodes(condCodes),
              .aluSrcA(aluSrc1),
              .aluSrcB(aluSrc2),
              .viewReg(regView),
              .aluResult(aluOut),
              .pc(pc),
              .memAddr(memAddr),
              .memData(memData),
              .regSelA(regSelA),
              .regSelB(regSelB),
              .viewSel(switch1[3:1]),
              .cPts(cPts),
              .clock(clock),
              .reset_L(reset_L));

//output display on the board for synthesis
   barDisplay bar(
                  .leds(barled),
                  .switches(switch0[7:5]),
                  .controlPoints(cPts),
                  .condCodes(condCodes),
                  .regSelA(regSelA),
                  .regSelB(regSelB),
                  .currState(currState),
                  .nextState(nextState),
                  .clock(clock));
   sevenSegDisplay lhex(
                       .sevenseg1(sevenseg0),
                       .sevenseg2(sevenseg1),
                       .switches(switch0[4:0]),
                       .aluSrc1(aluSrc1),
                       .aluSrc2(aluSrc2),
                       .aluOut(aluOut),
                       .irVal(ir),
                       .pcVal(pc),
                       .marVal(memAddr),
                       .mdrVal(memData),
                       .viewReg(regView),
                       .spVal(sp));
   sevenSegDisplay rhex(
                       .sevenseg1(sevenseg2),
                       .sevenseg2(sevenseg3),
                       .switches(switch0[4:0]),
                       .aluSrc1(aluSrc1),
                       .aluSrc2(aluSrc2),
                       .aluOut(aluOut),
                       .irVal(ir),
                       .pcVal(pc),
                       .marVal(memAddr),
                       .mdrVal(memData),
                       .viewReg(regView),
                       .spVal(sp));
   LEDController ledcon(
                       .displayValuesA(sevenseg0),
                       .displayValuesB(sevenseg1),
                       .displayValuesC(sevenseg2),
                       .displayValuesD(sevenseg3),
                       .clock(clock_board),
                       .reset(reset_board),
                       .displayA(en_displayA),
                       .displayB(en_displayB),
                       .displayC(en_displayC),
                       .displayD(en_displayD),
                       .sevenSegmentDisplay(sevenSegDisplay));

//output display for simulation
`ifdef synthesis
`else
   integer cycle;

   initial cycle = 0;

   always_ff @ (negedge clock) begin
      $display("cycle %d", cycle);
      $display("R0: 0x%x  R1: 0x%x  R2: 0x%x  R3: 0x%x", 
           dp.rfile.r0, dp.rfile.r1, dp.rfile.r2, dp.rfile.r3);
      $display("R4: 0x%x  R5: 0x%x  R6: 0x%x  R7: 0x%x", 
           dp.rfile.r4, dp.rfile.r5, dp.rfile.r6, dp.rfile.r7);
      $display("CState: %s  NState: %s", currState, nextState);
      $display("Dest: %s LoadCC: %s REI: %s WEI: %s",
           cPts.dest, cPts.lcc_L, cPts.re_L, cPts.we_L);
      $display("ALUop: %s     SrcA: %s      SrcB: %s",
           cPts.alu_op, cPts.srcA, cPts.srcB);
      $display("AddrA: %h        AddrB: %h", regSelA, regSelB);
      $display("ALUInA: 0x%h  ALUInB: 0x%h  ALUOut: 0x%h",  
           aluSrc1, aluSrc2, aluOut);
      $display("PC:     0x%h  IR:     0x%h  SP:     0x%h", pc, ir, sp);
      $display("MAR:    0x%h  MDR     0x%h  ZCNV:   %b", memAddr, memData, condCodes);
      $display("==================================================");
      cycle = cycle + 1;
   end
`endif

endmodule

