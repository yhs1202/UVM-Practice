class lb_ro_driver_c extends uvm_driver #(lb_ro_drv_pkt_c);

    `uvm_component_utils(lb_ro_driver_c)

    // Virtual interface
    virtual interface lb_ro_if lb_ro_vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), $sformatf("build_phase() starts.."), UVM_LOW)

        // Get the virtual interface from the uvm_config_db
        if (!uvm_config_db#(virtual lb_ro_if)::get(this, "", "lb_ro_vif", lb_ro_vif)) begin
        `uvm_fatal(get_type_name(), {"Cannot get vif from uvm_config_db, Virtual interface must be set before the build_phase", get_full_name(), ".lb_ro_vif"})
        end

        `uvm_info(get_type_name(), $sformatf("build_phase() ends.."), UVM_LOW)
    endfunction : build_phase

    // Main run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        @(negedge lb_ro_vif.i_rstn); // Wait for reset de-assertion
        reset_signals();
        forever begin
            @(posedge lb_ro_vif.i_rstn);
            while (lb_ro_vif.i_rstn) begin
                drive_signals();
            end
            reset_signals();
        end
  endtask : run_phase

    // Tasks to drive/reset signals
    virtual task reset_signals();
        `uvm_info(get_type_name(), $sformatf("reset_signals() starts.."), UVM_MEDIUM)
        // Reset interface signals as needed
        lb_ro_vif.i_bypass      <= 0     ;
        lb_ro_vif.i_offset_val  <= 0     ;
        lb_ro_vif.i_vsw         <= 0     ;
        lb_ro_vif.i_vbp         <= 0     ;
        lb_ro_vif.i_vact        <= 0     ;
        lb_ro_vif.i_vfp         <= 0     ;
        lb_ro_vif.i_hsw         <= 0     ;
        lb_ro_vif.i_hbp         <= 0     ;
        lb_ro_vif.i_hact        <= 0     ;
        lb_ro_vif.i_hfp         <= 0     ;
        lb_ro_vif.i_vsync       <= 0     ;
        lb_ro_vif.i_hsync       <= 0     ;
        lb_ro_vif.i_de          <= 0     ;
        lb_ro_vif.i_r_data      <= 0     ;
        lb_ro_vif.i_g_data      <= 0     ;
        lb_ro_vif.i_b_data      <= 0     ;
        `uvm_info(get_type_name(), $sformatf("reset_signals() ends.."), UVM_MEDIUM)
    endtask : reset_signals


    virtual task drive_signals();
        `uvm_info(get_type_name(), $sformatf("drive_signals() starts.."), UVM_MEDIUM)
        seq_item_port.get_next_item(req);   // Get the next transaction item (req)

        @(posedge lb_ro_vif.i_clk);
        // Drive interface signals based on the sequence item
        lb_ro_vif.i_bypass      <= req.i_bypass     ;
        lb_ro_vif.i_offset_val  <= req.i_offset_val ;
        lb_ro_vif.i_vsw         <= req.i_vsw        ;
        lb_ro_vif.i_vbp         <= req.i_vbp        ;
        lb_ro_vif.i_vact        <= req.i_vact       ;
        lb_ro_vif.i_vfp         <= req.i_vfp        ;
        lb_ro_vif.i_hsw         <= req.i_hsw        ;
        lb_ro_vif.i_hbp         <= req.i_hbp        ;
        lb_ro_vif.i_hact        <= req.i_hact       ;
        lb_ro_vif.i_hfp         <= req.i_hfp        ;

        // VSYNC
        lb_ro_vif.i_vsync <= 1;
        repeat (req.i_vsw) @(posedge lb_ro_vif.i_clk);
        lb_ro_vif.i_vsync <= 0;

        // VBP
        repeat (req.i_vbp) @(posedge lb_ro_vif.i_clk);

        // HSYNC and Active Video
        for (int v_line = 0; v_line < req.i_vact; v_line++) begin
            // HSYNC
            lb_ro_vif.i_hsync <= 1;
            repeat (req.i_hsw) @(posedge lb_ro_vif.i_clk);
            lb_ro_vif.i_hsync <= 0;
            // HBP
            repeat (req.i_hbp) @(posedge lb_ro_vif.i_clk);
            // HACT (DE)
            lb_ro_vif.i_de <= 1;
            for (int h_pix = 0; h_pix < req.i_hact; h_pix++) begin
                lb_ro_vif.i_r_data <= req.i_r_data;
                lb_ro_vif.i_g_data <= req.i_g_data;
                lb_ro_vif.i_b_data <= req.i_b_data;
                @(posedge lb_ro_vif.i_clk);
            end
            lb_ro_vif.i_de <= 0;
            // HFP
            repeat (req.i_hfp) @(posedge lb_ro_vif.i_clk);
        end
        // VFP
        repeat (req.i_vfp) @(posedge lb_ro_vif.i_clk);

        seq_item_port.item_done();  // Indicate that the item has been processed
        `uvm_info(get_type_name(), $sformatf("drive_signals() ends.."), UVM_MEDIUM)
    endtask : drive_signals
endclass : lb_ro_driver_c