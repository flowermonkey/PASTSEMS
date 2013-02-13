/*
 * File: regfile.v
 * Created: 23 October 2009
 * Modules contained: reg_file
 *
 * Update History:
 * 17 November 2009: Minor modification to facilitate synthesis (mcbender)
 * 4 Novermber 2009: Minor spacing modifications (mcbender)
 * 23 October 2009: Moved to its own file (mcbender)
 * 12 October 2009: Fixed typo.
 * 7 October 2009: Added demux and updated architecture accordingly
 * 3 October 2009: Removed output port C, cleaned up style a little
 * 9 June 1999 : Added 4 remaining registers 
 * 13 Oct 2010: Updated always to always_comb and always_ff.Renamed to.sv(abeera) 
 * 17 Oct 2010: Updated to use enums instead of define's (iclanton)
*/

/* 
 * module: reg_file
 *
 * The p18240's register file, which currently consists of eight (8)
 * 16-bit registers.  (It has at some points had fewer due to lack of
 * space on various FPGAs.)
 *
 * This register file has three outputs, the two registers A and B used
 * by the processor itself, and a third port for viewing purposes during
 * debugging.
*/
module reg_file(
   output logic [15:0] outA,
   output logic [15:0] outB,
   output logic [15:0] outView,
   input [15:0]      in,
   input [2:0]       selA,
   input [2:0]       selB,
   input [2:0]       selView,
   input             load_L, 
   input             reset_L,
   input             clock);
   
   logic [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
   logic [7:0]  reg_enable_lines_L;
   
   register #(.WIDTH(16)) reg0(.out(r0), .in(in), .load_L(reg_enable_lines_L[0]),
                               .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) reg1(.out(r1), .in(in), .load_L(reg_enable_lines_L[1]),
                               .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) reg2(.out(r2), .in(in), .load_L(reg_enable_lines_L[2]),
                               .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) reg3(.out(r3), .in(in), .load_L(reg_enable_lines_L[3]),
                               .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) reg4(.out(r4), .in(in), .load_L(reg_enable_lines_L[4]),
                               .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) reg5(.out(r5), .in(in), .load_L(reg_enable_lines_L[5]),
                               .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) reg6(.out(r6), .in(in), .load_L(reg_enable_lines_L[6]),
                               .clock(clock), .reset_L(reset_L));
   register #(.WIDTH(16)) reg7(.out(r7), .in(in), .load_L(reg_enable_lines_L[7]),
                               .clock(clock), .reset_L(reset_L));

   demux #(.OUT_WIDTH(8), .IN_WIDTH(3), .DEFAULT(1))
         reg_en_decoder (.in(load_L), .sel(selA), .out(reg_enable_lines_L));

   always_comb begin
      case (selA)
         3'b000: outA = r0;
         3'b001: outA = r1;
         3'b010: outA = r2;
         3'b011: outA = r3;
         3'b100: outA = r4;
         3'b101: outA = r5;
         3'b110: outA = r6;
         3'b111: outA = r7;
         default: outA = 16'h0000;
      endcase
      case (selB)
         3'b000: outB = r0;
         3'b001: outB = r1;
         3'b010: outB = r2;
         3'b011: outB = r3;
         3'b100: outB = r4;
         3'b101: outB = r5;
         3'b110: outB = r6;
         3'b111: outB = r7;
         default: outB = 16'h0000;
      endcase
      case (selView)
         3'b000: outView = r0;
         3'b001: outView = r1;
         3'b010: outView = r2;
         3'b011: outView = r3;
         3'b100: outView = r4;
         3'b101: outView = r5;
         3'b110: outView = r6;
         3'b111: outView = r7;
         default: outView = 16'h0000;
      endcase
   end 
endmodule
