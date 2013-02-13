# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Wed Mar 7 11:59:02 2012
# Designs open: 1
#   Sim: /afs/ece.cmu.edu/usr/bflores/341/p2/work/simv
# Toplevel windows open: 1
# 	TopLevel.1
#   Wave.6: 26 signals
#   Wave.7: 26 signals
#   Wave.8: 26 signals
#   Wave.9: 26 signals
#   Wave.4: 26 signals
#   Wave.5: 27 signals
#   Wave.1: 25 signals
#   Wave.2: 19 signals
#   Source.1: top.genblk2[2].node_inst.payload_splitter
#   Wave.3: 19 signals
#   Group count = 9
#   Group Top signal count = 25
#   Group Router 0 signal count = 19
#   Group Router 1 signal count = 19
#   Group Node 0 signal count = 26
#   Group Node 1 signal count = 27
#   Group Node 2 signal count = 26
#   Group Node 3 signal count = 26
#   Group Node 4 signal count = 26
#   Group Node 5 signal count = 26
# End_DVE_Session_Save_Info

# DVE version: D-2009.12
# DVE build date: Nov 13 2009 22:21:45


#<Session mode="Full" path="/afs/ece.cmu.edu/usr/bflores/341/p2/work/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
    gui_sim_wait terminated
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDensity
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Watch
gui_close_window -type Grading
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE Topleve session: 


# Create and position top-level windows :TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{0 22} {1919 1199}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_hide_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line false -dock_extent 248]
set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier]
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 248
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value 433
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 247} {height 906} {show_state normal} {dock_state left} {dock_on_new_line false} {child_hier_colhier 200} {child_hier_coltype 48} {child_hier_col1 0} {child_hier_col2 1}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 173]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1365
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 173
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 1919} {height 172} {show_state normal} {dock_state bottom} {dock_on_new_line true}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set DLPane.1 [gui_create_window -type {DLPane}  -parent ${TopLevel.1}]
if {[gui_get_shared_view -id ${DLPane.1} -type Data] == {}} {
        set Data.1 [gui_share_window -id ${DLPane.1} -type Data]
} else {
        set Data.1  [gui_get_shared_view -id ${DLPane.1} -type Data]
}

gui_show_window -window ${DLPane.1} -show_state maximized
gui_update_layout -id ${DLPane.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_data_colvariable 621} {child_data_colvalue 508} {child_data_coltype 537} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2} {dataShowMode detail} {max_item_length 50}}
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}
set Wave.2 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.2} -show_state maximized
gui_update_layout -id ${Wave.2} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}
set Wave.3 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.3} -show_state maximized
gui_update_layout -id ${Wave.3} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}
set Wave.4 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.4} -show_state maximized
gui_update_layout -id ${Wave.4} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}
set Wave.5 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.5} -show_state maximized
gui_update_layout -id ${Wave.5} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}
set Wave.6 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.6} -show_state maximized
gui_update_layout -id ${Wave.6} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}
set Wave.7 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.7} -show_state maximized
gui_update_layout -id ${Wave.7} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}
set Wave.8 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.8} -show_state maximized
gui_update_layout -id ${Wave.8} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}
set Wave.9 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.9} -show_state maximized
gui_update_layout -id ${Wave.9} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 489} {child_wave_right 1177} {child_wave_colname 269} {child_wave_colvalue 215} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(List) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { [llength [lindex [gui_get_db -design Sim] 0]] == 0 } {
gui_set_env SIMSETUP::SIMARGS {{-ucligui }}
gui_set_env SIMSETUP::SIMEXE {/afs/ece.cmu.edu/usr/bflores/341/p2/work/simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {/afs/ece.cmu.edu/usr/bflores/341/p2/work/simv}] } {
gui_sim_run Ucli -exe simv -args {-ucligui } -dir /afs/ece.cmu.edu/usr/bflores/341/p2/work -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 1s
gui_set_time_units 1s
#</Database>

# DVE Global setting session: 


# Global: Breakpoints
gui_sim_watch { -file {/afs/ece/usr/bflores/341/p2/work/../router.sv}  -line {74}    }
gui_sim_watch { -file {/afs/ece.cmu.edu/usr/bflores/341/p2/work/../node.sv}  -line {251}    }

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups

set {Top} {Top}
gui_sg_create ${Top}
gui_sg_addsignal -group ${Top} { {top.clk} {top.rst_b} {top.pkt_in} {top.pkt_out} {top.free_node_router} {top.put_node_router} {top.free_router_node} {top.put_router_node} {top.payload_router_node} {top.payload_node_router} {top.free_r0_r1} {top.put_r0_r1} {top.free_r1_r0} {top.put_r1_r0} {top.payload_r1_r0} {top.payload_r0_r1} {top.free_router_out} {top.put_router_in} {top.free_router_in} {top.put_router_out} {top.payload_router_out} {top.payload_router_in} {top.pkt_in_avail} {top.cQ_full} {top.pkt_out_avail} }
set {Router 0} {Router 0}
gui_sg_create ${Router 0}
gui_sg_addsignal -group ${Router 0} { {top.genblk1[0].router_inst.ROUTERID} {top.genblk1[0].router_inst.clk} {top.genblk1[0].router_inst.data} {top.genblk1[0].router_inst.found} {top.genblk1[0].router_inst.free_inbound} {top.genblk1[0].router_inst.free_outbound} {top.genblk1[0].router_inst.loc} {top.genblk1[0].router_inst.ns} {top.genblk1[0].router_inst.payload_inbound} {top.genblk1[0].router_inst.payload_outbound} {top.genblk1[0].router_inst.port} {top.genblk1[0].router_inst.put_inbound} {top.genblk1[0].router_inst.put_outbound} {top.genblk1[0].router_inst.rm} {top.genblk1[0].router_inst.rr_ld} {top.genblk1[0].router_inst.rst_b} {top.genblk1[0].router_inst.sent} {top.genblk1[0].router_inst.sr_en} {top.genblk1[0].router_inst.st} }
gui_set_radix -radix {decimal} -signals {{top.genblk1[0].router_inst.ROUTERID}}
gui_set_radix -radix {twosComplement} -signals {{top.genblk1[0].router_inst.ROUTERID}}
set {Router 1} {Router 1}
gui_sg_create ${Router 1}
gui_sg_addsignal -group ${Router 1} { {top.genblk1[1].router_inst.clk} {top.genblk1[1].router_inst.rst_b} {top.genblk1[1].router_inst.free_outbound} {top.genblk1[1].router_inst.put_outbound} {top.genblk1[1].router_inst.payload_outbound} {top.genblk1[1].router_inst.free_inbound} {top.genblk1[1].router_inst.put_inbound} {top.genblk1[1].router_inst.payload_inbound} {top.genblk1[1].router_inst.rr_ld} {top.genblk1[1].router_inst.rm} {top.genblk1[1].router_inst.sr_en} {top.genblk1[1].router_inst.sent} {top.genblk1[1].router_inst.loc} {top.genblk1[1].router_inst.data} {top.genblk1[1].router_inst.found} {top.genblk1[1].router_inst.port} {top.genblk1[1].router_inst.st} {top.genblk1[1].router_inst.ns} {top.genblk1[1].router_inst.ROUTERID} }
gui_set_radix -radix {decimal} -signals {{top.genblk1[1].router_inst.ROUTERID}}
gui_set_radix -radix {twosComplement} -signals {{top.genblk1[1].router_inst.ROUTERID}}
set {Node 0} {Node 0}
gui_sg_create ${Node 0}
gui_sg_addsignal -group ${Node 0} { {top.genblk2[0].node_inst.clk} {top.genblk2[0].node_inst.rst_b} {top.genblk2[0].node_inst.pkt_in} {top.genblk2[0].node_inst.pkt_in_avail} {top.genblk2[0].node_inst.cQ_full} {top.genblk2[0].node_inst.pkt_out} {top.genblk2[0].node_inst.pkt_out_avail} {top.genblk2[0].node_inst.free_outbound} {top.genblk2[0].node_inst.put_outbound} {top.genblk2[0].node_inst.payload_outbound} {top.genblk2[0].node_inst.free_inbound} {top.genblk2[0].node_inst.put_inbound} {top.genblk2[0].node_inst.payload_inbound} {top.genblk2[0].node_inst.we} {top.genblk2[0].node_inst.re} {top.genblk2[0].node_inst.fifo_full} {top.genblk2[0].node_inst.fifo_empty} {top.genblk2[0].node_inst.sel} {top.genblk2[0].node_inst.en_SIPO} {top.genblk2[0].node_inst.en_PISO} {top.genblk2[0].node_inst.done_PISO} {top.genblk2[0].node_inst.message} {top.genblk2[0].node_inst.fifo_input} {top.genblk2[0].node_inst.st} {top.genblk2[0].node_inst.ns} {top.genblk2[0].node_inst.NODEID} }
gui_set_radix -radix {decimal} -signals {{top.genblk2[0].node_inst.NODEID}}
gui_set_radix -radix {twosComplement} -signals {{top.genblk2[0].node_inst.NODEID}}
set {Node 1} {Node 1}
gui_sg_create ${Node 1}
gui_sg_addsignal -group ${Node 1} { {top.genblk2[1].node_inst.clk} {top.genblk2[1].node_inst.rst_b} {top.genblk2[1].node_inst.pkt_in} {top.genblk2[1].node_inst.pkt_in_avail} {top.genblk2[1].node_inst.cQ_full} {top.genblk2[1].node_inst.pkt_out} {top.genblk2[1].node_inst.pkt_out_avail} {top.genblk2[1].node_inst.free_outbound} {top.genblk2[1].node_inst.put_outbound} {top.genblk2[1].node_inst.payload_outbound} {top.genblk2[1].node_inst.free_inbound} {top.genblk2[1].node_inst.put_inbound} {top.genblk2[1].node_inst.payload_inbound} {top.genblk2[1].node_inst.we} {top.genblk2[1].node_inst.re} {top.genblk2[1].node_inst.fifo_full} {top.genblk2[1].node_inst.fifo_empty} {top.genblk2[1].node_inst.sel} {top.genblk2[1].node_inst.en_SIPO} {top.genblk2[1].node_inst.en_PISO} {top.genblk2[1].node_inst.done_PISO} {top.genblk2[1].node_inst.done_PISO} {top.genblk2[1].node_inst.message} {top.genblk2[1].node_inst.fifo_input} {top.genblk2[1].node_inst.st} {top.genblk2[1].node_inst.ns} {top.genblk2[1].node_inst.NODEID} }
gui_set_radix -radix {decimal} -signals {{top.genblk2[1].node_inst.NODEID}}
gui_set_radix -radix {twosComplement} -signals {{top.genblk2[1].node_inst.NODEID}}
set {Node 2} {Node 2}
gui_sg_create ${Node 2}
gui_sg_addsignal -group ${Node 2} { {top.genblk2[2].node_inst.clk} {top.genblk2[2].node_inst.rst_b} {top.genblk2[2].node_inst.pkt_in} {top.genblk2[2].node_inst.pkt_in_avail} {top.genblk2[2].node_inst.cQ_full} {top.genblk2[2].node_inst.pkt_out} {top.genblk2[2].node_inst.pkt_out_avail} {top.genblk2[2].node_inst.free_outbound} {top.genblk2[2].node_inst.put_outbound} {top.genblk2[2].node_inst.payload_outbound} {top.genblk2[2].node_inst.free_inbound} {top.genblk2[2].node_inst.put_inbound} {top.genblk2[2].node_inst.payload_inbound} {top.genblk2[2].node_inst.we} {top.genblk2[2].node_inst.re} {top.genblk2[2].node_inst.fifo_full} {top.genblk2[2].node_inst.fifo_empty} {top.genblk2[2].node_inst.sel} {top.genblk2[2].node_inst.en_SIPO} {top.genblk2[2].node_inst.en_PISO} {top.genblk2[2].node_inst.done_PISO} {top.genblk2[2].node_inst.message} {top.genblk2[2].node_inst.fifo_input} {top.genblk2[2].node_inst.st} {top.genblk2[2].node_inst.ns} {top.genblk2[2].node_inst.NODEID} }
gui_set_radix -radix {decimal} -signals {{top.genblk2[2].node_inst.NODEID}}
gui_set_radix -radix {twosComplement} -signals {{top.genblk2[2].node_inst.NODEID}}
set {Node 3} {Node 3}
gui_sg_create ${Node 3}
gui_sg_addsignal -group ${Node 3} { {top.genblk2[3].node_inst.clk} {top.genblk2[3].node_inst.rst_b} {top.genblk2[3].node_inst.pkt_in} {top.genblk2[3].node_inst.pkt_in_avail} {top.genblk2[3].node_inst.cQ_full} {top.genblk2[3].node_inst.pkt_out} {top.genblk2[3].node_inst.pkt_out_avail} {top.genblk2[3].node_inst.free_outbound} {top.genblk2[3].node_inst.put_outbound} {top.genblk2[3].node_inst.payload_outbound} {top.genblk2[3].node_inst.free_inbound} {top.genblk2[3].node_inst.put_inbound} {top.genblk2[3].node_inst.payload_inbound} {top.genblk2[3].node_inst.we} {top.genblk2[3].node_inst.re} {top.genblk2[3].node_inst.fifo_full} {top.genblk2[3].node_inst.fifo_empty} {top.genblk2[3].node_inst.sel} {top.genblk2[3].node_inst.en_SIPO} {top.genblk2[3].node_inst.en_PISO} {top.genblk2[3].node_inst.done_PISO} {top.genblk2[3].node_inst.message} {top.genblk2[3].node_inst.fifo_input} {top.genblk2[3].node_inst.st} {top.genblk2[3].node_inst.ns} {top.genblk2[3].node_inst.NODEID} }
gui_set_radix -radix {decimal} -signals {{top.genblk2[3].node_inst.NODEID}}
gui_set_radix -radix {twosComplement} -signals {{top.genblk2[3].node_inst.NODEID}}
set {Node 4} {Node 4}
gui_sg_create ${Node 4}
gui_sg_addsignal -group ${Node 4} { {top.genblk2[4].node_inst.clk} {top.genblk2[4].node_inst.rst_b} {top.genblk2[4].node_inst.pkt_in} {top.genblk2[4].node_inst.pkt_in_avail} {top.genblk2[4].node_inst.cQ_full} {top.genblk2[4].node_inst.pkt_out} {top.genblk2[4].node_inst.pkt_out_avail} {top.genblk2[4].node_inst.free_outbound} {top.genblk2[4].node_inst.put_outbound} {top.genblk2[4].node_inst.payload_outbound} {top.genblk2[4].node_inst.free_inbound} {top.genblk2[4].node_inst.put_inbound} {top.genblk2[4].node_inst.payload_inbound} {top.genblk2[4].node_inst.we} {top.genblk2[4].node_inst.re} {top.genblk2[4].node_inst.fifo_full} {top.genblk2[4].node_inst.fifo_empty} {top.genblk2[4].node_inst.sel} {top.genblk2[4].node_inst.en_SIPO} {top.genblk2[4].node_inst.en_PISO} {top.genblk2[4].node_inst.done_PISO} {top.genblk2[4].node_inst.message} {top.genblk2[4].node_inst.fifo_input} {top.genblk2[4].node_inst.st} {top.genblk2[4].node_inst.ns} {top.genblk2[4].node_inst.NODEID} }
gui_set_radix -radix {decimal} -signals {{top.genblk2[4].node_inst.NODEID}}
gui_set_radix -radix {twosComplement} -signals {{top.genblk2[4].node_inst.NODEID}}
set {Node 5} {Node 5}
gui_sg_create ${Node 5}
gui_sg_addsignal -group ${Node 5} { {top.genblk2[5].node_inst.clk} {top.genblk2[5].node_inst.rst_b} {top.genblk2[5].node_inst.pkt_in} {top.genblk2[5].node_inst.pkt_in_avail} {top.genblk2[5].node_inst.cQ_full} {top.genblk2[5].node_inst.pkt_out} {top.genblk2[5].node_inst.pkt_out_avail} {top.genblk2[5].node_inst.free_outbound} {top.genblk2[5].node_inst.put_outbound} {top.genblk2[5].node_inst.payload_outbound} {top.genblk2[5].node_inst.free_inbound} {top.genblk2[5].node_inst.put_inbound} {top.genblk2[5].node_inst.payload_inbound} {top.genblk2[5].node_inst.we} {top.genblk2[5].node_inst.re} {top.genblk2[5].node_inst.fifo_full} {top.genblk2[5].node_inst.fifo_empty} {top.genblk2[5].node_inst.sel} {top.genblk2[5].node_inst.en_SIPO} {top.genblk2[5].node_inst.en_PISO} {top.genblk2[5].node_inst.done_PISO} {top.genblk2[5].node_inst.message} {top.genblk2[5].node_inst.fifo_input} {top.genblk2[5].node_inst.st} {top.genblk2[5].node_inst.ns} {top.genblk2[5].node_inst.NODEID} }
gui_set_radix -radix {decimal} -signals {{top.genblk2[5].node_inst.NODEID}}
gui_set_radix -radix {twosComplement} -signals {{top.genblk2[5].node_inst.NODEID}}

# Global: Highlighting

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 130



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 1} {Process 1} {UnnamedProcess 1} {Function 1} {Block 1} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {NamedBlock 1} {Task 1} {DollarUnit 1} {VlgPackage 1} {ClassDef 1} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design Sim
catch {gui_list_expand -id ${Hier.1} top}
catch {gui_list_expand -id ${Hier.1} {top.genblk2[2].node_inst}}
catch {gui_list_select -id ${Hier.1} {{top.genblk2[2].node_inst.payload_splitter}}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {top.genblk2[2].node_inst.payload_splitter}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active {top.genblk2[2].node_inst.payload_splitter} /afs/ece.cmu.edu/usr/bflores/341/p2/work/../node.sv
gui_view_scroll -id ${Source.1} -vertical -set 225
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 386
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_add_group -id ${Wave.1} -after {New Group} {{Top}}
gui_list_set_insertion_bar  -id ${Wave.1} -group {Top}  -position in
gui_seek_criteria -id ${Wave.1} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.1} {C1} 130
gui_view_scroll -id ${Wave.1} -vertical -set 0

# View 'Wave.2'
gui_wv_sync -id ${Wave.2} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.2}  C1
gui_wv_zoom_timerange -id ${Wave.2} 0 386
gui_list_set_filter -id ${Wave.2} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.2} -text {*}
gui_list_add_group -id ${Wave.2} -after {New Group} {{Router 0}}
gui_list_expand -id ${Wave.2} {top.genblk1[0].router_inst.data}
gui_list_set_insertion_bar  -id ${Wave.2} -group {Router 0}  -position in
gui_seek_criteria -id ${Wave.2} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.2} {C1} 130
gui_view_scroll -id ${Wave.2} -vertical -set 0

# View 'Wave.3'
gui_wv_sync -id ${Wave.3} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.3}  C1
gui_wv_zoom_timerange -id ${Wave.3} 0 386
gui_list_set_filter -id ${Wave.3} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.3} -text {*}
gui_list_add_group -id ${Wave.3} -after {New Group} {{Router 1}}
gui_list_set_insertion_bar  -id ${Wave.3} -group {Router 1}  -position in
gui_seek_criteria -id ${Wave.3} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.3} {C1} 130
gui_view_scroll -id ${Wave.3} -vertical -set 0

# View 'Wave.4'
gui_wv_sync -id ${Wave.4} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.4}  C1
gui_wv_zoom_timerange -id ${Wave.4} 0 386
gui_list_set_filter -id ${Wave.4} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.4} -text {*}
gui_list_add_group -id ${Wave.4} -after {New Group} {{Node 0}}
gui_list_set_insertion_bar  -id ${Wave.4} -group {Node 0}  -position in
gui_seek_criteria -id ${Wave.4} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.4} {C1} 130
gui_view_scroll -id ${Wave.4} -vertical -set 0

# View 'Wave.5'
gui_wv_sync -id ${Wave.5} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.5}  C1
gui_wv_zoom_timerange -id ${Wave.5} 0 297
gui_list_set_filter -id ${Wave.5} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.5} -text {*}
gui_list_add_group -id ${Wave.5} -after {New Group} {{Node 1}}
gui_list_select -id ${Wave.5} {{top.genblk2[1].node_inst.we} }
gui_list_set_insertion_bar  -id ${Wave.5} -group {Node 1} -item {top.genblk2[1].node_inst.done_PISO} -position below
gui_seek_criteria -id ${Wave.5} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.5} {C1} 130
gui_view_scroll -id ${Wave.5} -vertical -set 0

# View 'Wave.6'
gui_wv_sync -id ${Wave.6} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.6}  C1
gui_wv_zoom_timerange -id ${Wave.6} 0 386
gui_list_set_filter -id ${Wave.6} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.6} -text {*}
gui_list_add_group -id ${Wave.6} -after {New Group} {{Node 2}}
gui_list_set_insertion_bar  -id ${Wave.6} -group {Node 2}  -position in
gui_seek_criteria -id ${Wave.6} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.6} {C1} 130
gui_view_scroll -id ${Wave.6} -vertical -set 0

# View 'Wave.7'
gui_wv_sync -id ${Wave.7} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.7}  C1
gui_wv_zoom_timerange -id ${Wave.7} 0 386
gui_list_set_filter -id ${Wave.7} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.7} -text {*}
gui_list_add_group -id ${Wave.7} -after {New Group} {{Node 3}}
gui_list_set_insertion_bar  -id ${Wave.7} -group {Node 3}  -position in
gui_seek_criteria -id ${Wave.7} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.7} {C1} 130
gui_view_scroll -id ${Wave.7} -vertical -set 0

# View 'Wave.8'
gui_wv_sync -id ${Wave.8} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.8}  C1
gui_wv_zoom_timerange -id ${Wave.8} 0 386
gui_list_set_filter -id ${Wave.8} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.8} -text {*}
gui_list_add_group -id ${Wave.8} -after {New Group} {{Node 4}}
gui_list_set_insertion_bar  -id ${Wave.8} -group {Node 4}  -position in
gui_seek_criteria -id ${Wave.8} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.8} {C1} 130
gui_view_scroll -id ${Wave.8} -vertical -set 0

# View 'Wave.9'
gui_wv_sync -id ${Wave.9} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.9}  C1
gui_wv_zoom_timerange -id ${Wave.9} 0 386
gui_list_set_filter -id ${Wave.9} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.9} -text {*}
gui_list_add_group -id ${Wave.9} -after {New Group} {{Node 5}}
gui_list_set_insertion_bar  -id ${Wave.9} -group {Node 5}  -position in
gui_seek_criteria -id ${Wave.9} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.9}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_marker_move -id ${Wave.9} {C1} 130
gui_view_scroll -id ${Wave.9} -vertical -set 0

# DVE Active view and window setting: 

gui_set_active_window -window ${Wave.3}
gui_set_active_window -window ${Wave.3}
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1} }
#</Session>

