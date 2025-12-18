class lb_ro_monitor_c extends uvm_monitor;
    `uvm_component_utils(lb_ro_monitor_c)

    // TLM ports
    uvm_analysis_port#(lb_ro_mon_pkt_c) in_data_port; // broadcast mode
    uvm_analysis_port#(lb_ro_mon_pkt_c) out_data_port; // broadcast mode

    // Virtual interface
    virtual interface lb_ro_if lb_ro_vif;
    lb_ro_mon_pkt_c in_pkt;
    lb_ro_mon_pkt_c out_pkt;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        in_data_port = new("in_data_port", this);
        out_data_port = new("out_data_port", this);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), $sformatf("build_phase() starts.."), UVM_LOW)

        if (!uvm_config_db#(virtual lb_ro_if)::get(this, "", "lb_ro_vif", lb_ro_vif)) begin
            `uvm_fatal(get_type_name(), {"virtual interface must be set for: ", get_full_name(), ".lb_ro_vif"})
        end

        `uvm_info(get_type_name(), $sformatf("build_phase() ends.."), UVM_LOW)
    endfunction

    // Run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            forever begin
                // Wait for clock edge when not in reset, iff: if and only if
                @(posedge lb_ro_vif.i_clk iff lb_ro_vif.i_rstn);
                in_data();
            end
            forever begin
                @(posedge lb_ro_vif.i_clk iff lb_ro_vif.i_rstn);
                out_valid_data();
            end
        join_none
    endtask : run_phase

    // Task to monitor input data signals
    task in_data();
        `uvm_info(get_type_name(), $sformatf("in_data() starts.."), UVM_MEDIUM)
        in_pkt = lb_ro_mon_pkt_c::type_id::create("in_pkt", this);
        in_pkt.i_bypass        = lb_ro_vif.i_bypass    ;
        in_pkt.i_offset_val    = lb_ro_vif.i_offset_val;
        in_pkt.i_vsw           = lb_ro_vif.i_vsw       ;
        in_pkt.i_vbp           = lb_ro_vif.i_vbp       ;
        in_pkt.i_vact          = lb_ro_vif.i_vact      ;
        in_pkt.i_vfp           = lb_ro_vif.i_vfp       ;
        in_pkt.i_hsw           = lb_ro_vif.i_hsw       ;
        in_pkt.i_hbp           = lb_ro_vif.i_hbp       ;
        in_pkt.i_hact          = lb_ro_vif.i_hact      ;
        in_pkt.i_hfp           = lb_ro_vif.i_hfp       ;
        in_pkt.i_vsync         = lb_ro_vif.i_vsync     ;
        in_pkt.i_hsync         = lb_ro_vif.i_hsync     ;
        in_pkt.i_de            = lb_ro_vif.i_de        ;
        in_pkt.i_r_data        = lb_ro_vif.i_r_data    ;
        in_pkt.i_g_data        = lb_ro_vif.i_g_data    ;
        in_pkt.i_b_data        = lb_ro_vif.i_b_data    ;
        in_data_port.write(in_pkt);
        `uvm_info(get_type_name(), $sformatf("in_data() ends.."), UVM_MEDIUM)
    endtask :in_data

    task out_valid_data();
        if (lb_ro_vif.o_hsync) begin
          `uvm_info(get_type_name(), $sformatf("out_valid_data() starts.."), UVM_MEDIUM)
          out_pkt = lb_ro_mon_pkt_c::type_id::create("out_pkt", this);
          out_pkt.o_vsync   = lb_ro_vif.o_vsync     ;
          out_pkt.o_hsync   = lb_ro_vif.o_hsync     ;
          out_pkt.o_r_data  = lb_ro_vif.o_r_data    ;
          out_pkt.o_g_data  = lb_ro_vif.o_g_data    ;
          out_pkt.o_b_data  = lb_ro_vif.o_b_data    ;
          out_data_port.write(out_pkt);
          `uvm_info(get_type_name(), $sformatf("out_valid_data() ends.."), UVM_MEDIUM)
        end
    endtask : out_valid_data

endclass : lb_ro_monitor_c
