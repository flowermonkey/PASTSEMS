# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Wed Oct 10 03:17:28 2012
# Designs open: 1
#   Sim: /afs/ece.cmu.edu/usr/bflores/341/p2/work/simv
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: _vcs_unit__3130351013
#   Wave.1: 1 signals
#   Group count = 10
#   Group Group2 signal count = 14
#   Group B1[2].output_buf signal count = 13
#   Group B1[2].waitList signal count = 14
#   Group B1[0].waitList signal count = 14
#   Group B1[1].waitList signal count = 14
#   Group B1[1].input_buf signal count = 13
#   Group B1[3].output_buf signal count = 13
#   Group Group3 signal count = 3
#   Group Group4 signal count = 0
#   Group Group5 signal count = 1
# End_DVE_Session_Save_Info

# DVE version: F-2011.12-SP1
# DVE build date: May 27 2012 20:57:07


#<Session mode="Full" path="/afs/ece.cmu.edu/usr/bflores/341/p2/work/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
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
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
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
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{0 22} {1365 727}}

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
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
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
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line false -dock_extent 219]
set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier]
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 219
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value 437
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 218} {height 438} {dock_state left} {dock_on_new_line false} {child_hier_colhier 200} {child_hier_coltype 48} {child_hier_col1 0} {child_hier_col2 1}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 169]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1306
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 169
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 1365} {height 168} {dock_state bottom} {dock_on_new_line true}}
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
gui_update_layout -id ${DLPane.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_data_colvariable 449} {child_data_colvalue 334} {child_data_coltype 360} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.1}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 333} {child_wave_right 808} {child_wave_colname 208} {child_wave_colvalue 121} {child_wave_col1 0} {child_wave_col2 1}}

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
gui_set_env SIMSETUP::SIMARGS {{ -ucligui}}
gui_set_env SIMSETUP::SIMEXE {/afs/ece.cmu.edu/usr/bflores/341/p2/work/simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {/afs/ece.cmu.edu/usr/bflores/341/p2/work/simv}] } {
gui_sim_run Ucli -exe simv -args { -ucligui} -dir /afs/ece.cmu.edu/usr/bflores/341/p2/work -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 1s
gui_set_time_units 1s
#</Database>

# DVE Global setting session: 


# Global: Breakpoints

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups

set Group2 Group2
gui_sg_create ${Group2}
gui_sg_addsignal -group ${Group2} { {top.tb1.unnamed$$_9} {top.genblk2[1].node_inst.receiver.curr} {top.genblk2[1].node_inst.receiver.valueReceived} {top.genblk2[1].node_inst.receiver.free} {top.genblk2[1].node_inst.receiver.payload} {top.genblk2[1].node_inst.receiver.nxt} {top.genblk2[1].node_inst.receiver.en_count} {top.genblk2[1].node_inst.receiver.cl_count} {top.genblk2[1].node_inst.receiver.ck} {top.genblk2[1].node_inst.receiver.full} {top.genblk2[1].node_inst.receiver.done} {top.genblk2[1].node_inst.receiver.count} {top.genblk2[1].node_inst.receiver.r_l} {top.genblk2[1].node_inst.receiver.put} }
set {B1[2].output_buf} {B1[2].output_buf}
gui_sg_create ${B1[2].output_buf}
gui_sg_addsignal -group ${B1[2].output_buf} { {top.genblk1[0].router_inst.B1[2].output_buf.curr} {top.genblk1[0].router_inst.B1[2].output_buf.free} {top.genblk1[0].router_inst.B1[2].output_buf.payload} {top.genblk1[0].router_inst.B1[2].output_buf.enable} {top.genblk1[0].router_inst.B1[2].output_buf.nxt} {top.genblk1[0].router_inst.B1[2].output_buf.en_count} {top.genblk1[0].router_inst.B1[2].output_buf.cl_count} {top.genblk1[0].router_inst.B1[2].output_buf.ck} {top.genblk1[0].router_inst.B1[2].output_buf.valueToSend} {top.genblk1[0].router_inst.B1[2].output_buf.count} {top.genblk1[0].router_inst.B1[2].output_buf.r_l} {top.genblk1[0].router_inst.B1[2].output_buf.put} {top.genblk1[0].router_inst.B1[2].output_buf.inpt_val} }
set {B1[2].waitList} {B1[2].waitList}
gui_sg_create ${B1[2].waitList}
gui_sg_addsignal -group ${B1[2].waitList} { {top.genblk1[0].router_inst.B1[2].waitList.queue} {top.genblk1[0].router_inst.B1[2].waitList.we} {top.genblk1[0].router_inst.B1[2].waitList.re} {top.genblk1[0].router_inst.B1[2].waitList.SIZE} {top.genblk1[0].router_inst.B1[2].waitList.data_in} {top.genblk1[0].router_inst.B1[2].waitList.empty} {top.genblk1[0].router_inst.B1[2].waitList.data_out} {top.genblk1[0].router_inst.B1[2].waitList.rst_b} {top.genblk1[0].router_inst.B1[2].waitList.putPtr} {top.genblk1[0].router_inst.B1[2].waitList.full} {top.genblk1[0].router_inst.B1[2].waitList.clk} {top.genblk1[0].router_inst.B1[2].waitList.WIDTH} {top.genblk1[0].router_inst.B1[2].waitList.count} {top.genblk1[0].router_inst.B1[2].waitList.getPtr} }
gui_set_radix -radix {decimal} -signals {{Sim:top.genblk1[0].router_inst.B1[2].waitList.SIZE}}
gui_set_radix -radix {twosComplement} -signals {{Sim:top.genblk1[0].router_inst.B1[2].waitList.SIZE}}
gui_set_radix -radix {decimal} -signals {{Sim:top.genblk1[0].router_inst.B1[2].waitList.WIDTH}}
gui_set_radix -radix {twosComplement} -signals {{Sim:top.genblk1[0].router_inst.B1[2].waitList.WIDTH}}
set {B1[0].waitList} {B1[0].waitList}
gui_sg_create ${B1[0].waitList}
gui_sg_addsignal -group ${B1[0].waitList} { {top.genblk1[0].router_inst.B1[0].waitList.queue} {top.genblk1[0].router_inst.B1[0].waitList.we} {top.genblk1[0].router_inst.B1[0].waitList.re} {top.genblk1[0].router_inst.B1[0].waitList.SIZE} {top.genblk1[0].router_inst.B1[0].waitList.data_in} {top.genblk1[0].router_inst.B1[0].waitList.empty} {top.genblk1[0].router_inst.B1[0].waitList.data_out} {top.genblk1[0].router_inst.B1[0].waitList.rst_b} {top.genblk1[0].router_inst.B1[0].waitList.putPtr} {top.genblk1[0].router_inst.B1[0].waitList.full} {top.genblk1[0].router_inst.B1[0].waitList.clk} {top.genblk1[0].router_inst.B1[0].waitList.WIDTH} {top.genblk1[0].router_inst.B1[0].waitList.count} {top.genblk1[0].router_inst.B1[0].waitList.getPtr} }
gui_set_radix -radix {decimal} -signals {{Sim:top.genblk1[0].router_inst.B1[0].waitList.SIZE}}
gui_set_radix -radix {twosComplement} -signals {{Sim:top.genblk1[0].router_inst.B1[0].waitList.SIZE}}
gui_set_radix -radix {decimal} -signals {{Sim:top.genblk1[0].router_inst.B1[0].waitList.WIDTH}}
gui_set_radix -radix {twosComplement} -signals {{Sim:top.genblk1[0].router_inst.B1[0].waitList.WIDTH}}
set {B1[1].waitList} {B1[1].waitList}
gui_sg_create ${B1[1].waitList}
gui_sg_addsignal -group ${B1[1].waitList} { {top.genblk1[0].router_inst.B1[1].waitList.queue} {top.genblk1[0].router_inst.B1[1].waitList.we} {top.genblk1[0].router_inst.B1[1].waitList.re} {top.genblk1[0].router_inst.B1[1].waitList.SIZE} {top.genblk1[0].router_inst.B1[1].waitList.data_in} {top.genblk1[0].router_inst.B1[1].waitList.empty} {top.genblk1[0].router_inst.B1[1].waitList.data_out} {top.genblk1[0].router_inst.B1[1].waitList.rst_b} {top.genblk1[0].router_inst.B1[1].waitList.putPtr} {top.genblk1[0].router_inst.B1[1].waitList.full} {top.genblk1[0].router_inst.B1[1].waitList.clk} {top.genblk1[0].router_inst.B1[1].waitList.WIDTH} {top.genblk1[0].router_inst.B1[1].waitList.count} {top.genblk1[0].router_inst.B1[1].waitList.getPtr} }
gui_set_radix -radix {decimal} -signals {{Sim:top.genblk1[0].router_inst.B1[1].waitList.SIZE}}
gui_set_radix -radix {twosComplement} -signals {{Sim:top.genblk1[0].router_inst.B1[1].waitList.SIZE}}
gui_set_radix -radix {decimal} -signals {{Sim:top.genblk1[0].router_inst.B1[1].waitList.WIDTH}}
gui_set_radix -radix {twosComplement} -signals {{Sim:top.genblk1[0].router_inst.B1[1].waitList.WIDTH}}
set {B1[1].input_buf} {B1[1].input_buf}
gui_sg_create ${B1[1].input_buf}
gui_sg_addsignal -group ${B1[1].input_buf} { {top.genblk1[0].router_inst.B1[1].input_buf.curr} {top.genblk1[0].router_inst.B1[1].input_buf.valueReceived} {top.genblk1[0].router_inst.B1[1].input_buf.free} {top.genblk1[0].router_inst.B1[1].input_buf.payload} {top.genblk1[0].router_inst.B1[1].input_buf.nxt} {top.genblk1[0].router_inst.B1[1].input_buf.en_count} {top.genblk1[0].router_inst.B1[1].input_buf.cl_count} {top.genblk1[0].router_inst.B1[1].input_buf.ck} {top.genblk1[0].router_inst.B1[1].input_buf.full} {top.genblk1[0].router_inst.B1[1].input_buf.done} {top.genblk1[0].router_inst.B1[1].input_buf.count} {top.genblk1[0].router_inst.B1[1].input_buf.r_l} {top.genblk1[0].router_inst.B1[1].input_buf.put} }
set {B1[3].output_buf} {B1[3].output_buf}
gui_sg_create ${B1[3].output_buf}
gui_sg_addsignal -group ${B1[3].output_buf} { {top.genblk1[1].router_inst.B1[3].output_buf.curr} {top.genblk1[1].router_inst.B1[3].output_buf.free} {top.genblk1[1].router_inst.B1[3].output_buf.payload} {top.genblk1[1].router_inst.B1[3].output_buf.enable} {top.genblk1[1].router_inst.B1[3].output_buf.nxt} {top.genblk1[1].router_inst.B1[3].output_buf.en_count} {top.genblk1[1].router_inst.B1[3].output_buf.cl_count} {top.genblk1[1].router_inst.B1[3].output_buf.ck} {top.genblk1[1].router_inst.B1[3].output_buf.valueToSend} {top.genblk1[1].router_inst.B1[3].output_buf.count} {top.genblk1[1].router_inst.B1[3].output_buf.r_l} {top.genblk1[1].router_inst.B1[3].output_buf.put} {top.genblk1[1].router_inst.B1[3].output_buf.inpt_val} }
set Group3 Group3
gui_sg_create ${Group3}
gui_sg_addsignal -group ${Group3} { {top.tb1.unnamed$$_11} {top.tb1.pkt_out_avail[1]} top.tb1.pkt_out_avail }
set Group4 Group4
gui_sg_create ${Group4}
set Group5 Group5
gui_sg_create ${Group5}
gui_sg_addsignal -group ${Group5} { {top.tb1.unnamed$$_9} }

# Global: Highlighting

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 820



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
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {UnnamedProcess 1} {Function 1} {Block 1} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {PowSwitch 0} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {IsoCell 0} {ClassDef 1} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design Sim
catch {gui_list_expand -id ${Hier.1} top}
catch {gui_list_select -id ${Hier.1} {top.tb1}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {top.tb1}
gui_show_window -window ${Data.1}
catch { gui_list_select -id ${Data.1} {{top.tb1.unnamed$$_9} }}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active _vcs_unit__3130351013 /afs/ece.cmu.edu/usr/bflores/341/p2/work/../top.sv
gui_view_scroll -id ${Source.1} -vertical -set 0
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
gui_wv_zoom_timerange -id ${Wave.1} 917 952
gui_list_add_group -id ${Wave.1} -after {New Group} {Group5}
gui_list_expand -id ${Wave.1} {top.tb1.unnamed$$_9}
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group Group5  -position in

gui_marker_move -id ${Wave.1} {C1} 820
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

