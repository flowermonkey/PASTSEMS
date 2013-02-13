source $env(SYNTH_COMMON)/common_vhdl.tcl 
set top p18240_top
set partid xc3s200ft256-5
read_verilog -sv {
alu.sv
board.sv
constants.sv
controlpath.sv
datapath.sv
LEDController.sv
library.sv
p18240.sv
regfile.sv
}
set_parameter inferMuxPart false
set_parameter recognizeDsps false
synthesize -module $top
source /afs/ece/class/ece240/lib/sp3.tcl
