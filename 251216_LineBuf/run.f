// ./sim_define.v

// RTL include path
+incdir+./rtl/

// TB include path
+incdir+./tb/

// Package files
./tb/uvm_global.sv
./tb/lb_ro_pkg.sv

// UVM files
// ./tb/lb_ro_if.sv
./tb/lb_ro_define.sv
./tb/lb_ro_transfer.sv
./tb/lb_ro_seq_item.sv
./tb/lb_ro_sequencer.sv
./tb/lb_ro_seq_lib.sv
./tb/lb_ro_driver.sv
./tb/lb_ro_monitor.sv
./tb/lb_ro_agent.sv
./tb/lb_ro_sb.sv
./tb/lb_ro_env.sv

// Test files
./tb/vseqr.sv
./tb/base_vseq_lib.sv
./tb/lb_ro_vseq_lib.sv
./tb/tb.sv
./tb/base_test.sv
./tb/video_test.sv

// RTL file
./rtl/design.sv

// Top file
./tb/top.sv