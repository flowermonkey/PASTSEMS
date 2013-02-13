/*
 * File: library.v
 * Created: 11/13/1997
 * Modules contained: Memory_16bit, mux4to1, demux, tridrive, register
 * 
 * Changelog:
 * 17 November 2009: Minor modification to memory to facilitate synthesis (mcbender)
 * 4 November 2009: Modified spacing, parameterized remaining modules (mcbender)
 * 23 October 2009: Moved register file to regfile.v, renamed modules.v to library.v
 * 12 October 2009: Fixed a few minor typos, a few naming changes (mcbender)
 * 08 October 2009: Fixed minor errors, removed a few unneeded modules (mcbender)
 * 07 October 2009: Parameterized a few modules, added demux, modified reg file (mcbender)
 * 03 October 2009: Cleaned up module style, removed many old unused modules (mcbender)
 * 11/26/06: Removed old Altera-specific code that Xilinx tool had trouble with (P. Milder)
 * 4/16/2001: Reverted to base code. (verBurg)
 * 13 Oct 2010: Updated always to always_comb and always_ff.Renamed to.sv(abeera) 
 * 17 Oct 2010: Updated to use enums instead of define's (iclanton)
 * 9  Nov 2010: Slightly modified variable names. Changed array declaration per SV
                Modified mux to use enum(abeera)
 */
 
// Comment this line when simulating, uncomment when synthesizing.
//`define synthesis
  
/* 
 * module: memory_16bit 
 *
 * This is our data memory, with combinational read and synchronous write.
 * Each memory word is 16 bits, and there is a 16 bit address space.
 * Note: This is a simulation model only. Memories are not synthesizable.
 */
 
 `include "constants.sv"
 
module memory_16bit (
   output logic [15:0] dataout,
   input [15:0]      datain,
   input [15:0]      addr,
   input wr_cond_code_t we_L,
   input             clock); 

`ifdef synthesis
   logic [15:0] mem [16'h00ff];     //less memory in synthesis
`else
   logic [15:0] mem [16'hffff];  // memory array
`endif

`ifndef synthesis
   initial begin
      // initialize the memory for simulation:
      $display("initializing simulation...");
      $readmemh("memory.hex", mem);  // read file into array
   end
`endif

   //Combinational read
   always_comb 
     dataout = mem[addr];
   
   //Synchronous write
   always_ff @(posedge clock)
     if (~we_L)
       mem[addr] = datain;

endmodule

/* 
 * module: tridrive
 *
 * A parameterized, non-inverting tristate driver with active low enable.
 */
module tridrive #(parameter WIDTH = 16) (
   input  [WIDTH-1:0] data,
   output [WIDTH-1:0] bus,
   input  en_L);

   assign bus = (~en_L)? data: 'bz;
endmodule

/* 
 * module: mux4to1 
 *
 * A pretty standard 4-to-1, parameterized MUX.  Based upon the select 
 * line, the proper input word becomes valid on the output.
 */
module mux4to1 #(parameter WIDTH = 16) (
   input [WIDTH-1:0]      inA,
   input [WIDTH-1:0]      inB,
   input [WIDTH-1:0]      inC,
   input [WIDTH-1:0]      inD,
   output logic [WIDTH-1:0] out,
   input alu_mux_t sel);
   
   always_comb
     case(sel)
       MUX_REG: out = inA;
       MUX_SP: out = inB;
       MUX_PC: out = inC;
       MUX_MDR: out = inD;
     endcase
endmodule

/*
 * module: demux
 *  
 * A basic parameterized demultiplexer.
 * IN_WIDTH is the number of inputs and OUT_WIDTH is the number of outputs;
 * OUT_WIDTH should always be chosen to be a power of two and IN_WIDTH should
 * be equal to log_2(OUT_WIDTH).
 * DEFAULT is the value which will be sent to all of the non-selected outputs,
 * and should be either 1 or 0 only.
*/
module demux #(parameter OUT_WIDTH = 8, IN_WIDTH = 3, DEFAULT = 0)(
   input                      in,
   input [IN_WIDTH-1:0]       sel,
   output logic [OUT_WIDTH-1:0] out);

   always_comb begin
      out = (DEFAULT==0)?'b0:(~('b0));
      out[sel] = in;
   end

endmodule

/* 
 * module: register
 *
 * A positive-edge clocked parameterized register with (active low) load enable
 * and asynchronous reset. The parameter is the bit-width of the register.
 */
module register #(parameter WIDTH = 16) (
   output logic [WIDTH-1:0] out,
   input [WIDTH-1:0]      in,
   input                  load_L,
   input                  clock,
   input                  reset_L);

   always_ff @ (posedge clock, negedge reset_L) begin
      if(~reset_L)
         out <= 'h0000;
      else if (~load_L)
         out <= in;
   end

endmodule
