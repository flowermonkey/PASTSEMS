source $env(SYNTH_COMMON)/common_vhdl.tcl 
set top top1
set partid xc3s200ft256-5
read_verilog -sv {
myFSM1.sv
LEDController.sv
display.sv
}
set_parameter inferMuxPart false
set_parameter recognizeDsps false
synthesize -module $top
source /afs/ece/class/ece240/lib/sp3.tcl
