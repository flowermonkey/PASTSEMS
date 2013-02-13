source $env(SYNTH_COMMON)/common_vhdl.tcl 
set top Top
set partid xc3s200ft256-5
read_verilog -sv {
lab_1_SOP.sv
}
synthesize -module $top
source /afs/ece/class/ece240/lib/sp3.tcl
set_parameter inferMuxPart false
set_parameter recognizeDsps false
