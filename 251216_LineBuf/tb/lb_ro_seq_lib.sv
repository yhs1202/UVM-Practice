class lb_ro_base_seq_c extends uvm_sequence #(lb_ro_drv_pkt_c);
    `uvm_object_utils(lb_ro_base_seq_c)

    lb_ro_seq_item_c rnd_item;
    virtual lb_ro_if lb_ro_vif;

    rand data_mode_e                        data_mode;
    rand bit          [`RGB_WIDTH-1:0]      fix_r_data;
    rand bit          [`RGB_WIDTH-1:0]      fix_g_data;
    rand bit          [`RGB_WIDTH-1:0]      fix_b_data;
    rand bit                                user_bypass;
    rand bit          [`RGB_WIDTH-1:0]      user_offset_val;
    rand bit          [`VER_WIDTH-1:0]      user_vsw;
    rand bit          [`VER_WIDTH-1:0]      user_vbp;
    rand bit          [`VER_WIDTH-1:0]      user_vact;
    rand bit          [`VER_WIDTH-1:0]      user_vfp;
    rand bit          [`HOR_WIDTH-1:0]      user_hsw;
    rand bit          [`HOR_WIDTH-1:0]      user_hbp;
    rand bit          [`HOR_WIDTH-1:0]      user_hact;
    rand bit          [`HOR_WIDTH-1:0]      user_hfp;


    function new (string name = "lb_ro_base_seq_c");
        super.new(name);
        rnd_item = new();
    endfunction : new

    task send_signal();
        `uvm_info(get_type_name(), $sformatf("send_signal starts.."), UVM_MEDIUM)
        `uvm_create(req);
        req.i_bypass     = rnd_item.i_bypass       ;
        req.i_offset_val = rnd_item.i_offset_val   ;
        req.i_vsw        = rnd_item.i_vsw          ;
        req.i_vbp        = rnd_item.i_vbp          ;
        req.i_vact       = rnd_item.i_vact         ;
        req.i_vfp        = rnd_item.i_vfp          ;
        req.i_hsw        = rnd_item.i_hsw          ;
        req.i_hbp        = rnd_item.i_hbp          ;
        req.i_hact       = rnd_item.i_hact         ;
        req.i_hfp        = rnd_item.i_hfp          ;
        req.i_vsync      = rnd_item.i_vsync        ;
        req.i_hsync      = rnd_item.i_hsync        ;
        req.i_de         = rnd_item.i_de           ;
        req.i_r_data     = rnd_item.i_r_data       ;
        req.i_g_data     = rnd_item.i_g_data       ;
        req.i_b_data     = rnd_item.i_b_data       ;
        `uvm_send(req);
        `uvm_info(get_type_name(), $sformatf("send_signal ends.."), UVM_MEDIUM)
    endtask : send_signal

    task send_init(input int size = 1);
        for (int i = 1; i <= size; i++) begin
            rnd_item.i_bypass       = 0;
            rnd_item.i_offset_val   = 0;
            rnd_item.i_vsw          = 0;
            rnd_item.i_vbp          = 0;
            rnd_item.i_vact         = 0;
            rnd_item.i_vfp          = 0;
            rnd_item.i_hsw          = 0;
            rnd_item.i_hbp          = 0;
            rnd_item.i_hact         = 0;
            rnd_item.i_hfp          = 0;
            rnd_item.i_vsync        = 0;
            rnd_item.i_hsync        = 0;
            rnd_item.i_de           = 0;
            rnd_item.i_r_data       = 0;
            rnd_item.i_g_data       = 0;
            rnd_item.i_b_data       = 0;
            send_signal();
        end
    endtask : send_init
endclass : lb_ro_base_seq_c


// Random sequence Class based on base_seq_c
// which sends random signals to the DUT via the driver
class lb_ro_rand_seq_c extends lb_ro_base_seq_c;
    `uvm_object_utils(lb_ro_rand_seq_c)

    function new(string name = "lb_ro_rand_seq_c");
        super.new(name);
    endfunction : new

    virtual task body();
        `uvm_info(get_type_name(), $sformatf("lb_ro_rand_seq_c starts.."), UVM_LOW)

        // Send random signals
        send_init(5);
        send_randomize_data(3);
        send_init(2);
        send_randomize_all(6);
        send_init(2);

        `uvm_info(get_type_name(), $sformatf("lb_ro_rand_seq_c ends.."), UVM_LOW)
    endtask : body

    task send_randomize_all(input int size = 1);
        for (int i = 1; i <= size; i++) begin
            void'(rnd_item.randomize());
            // assert(rnd_item.randomize());
            send_signal();
        end
    endtask : send_randomize_all

    task send_randomize_data(input int size = 1);
        for (int i = 1; i <= size; i++) begin
            void'(rnd_item.randomize());
            rnd_item.i_bypass       = 1;
            rnd_item.i_offset_val   = 0;
            rnd_item.i_vsw          = 0;
            rnd_item.i_vbp          = 0;
            rnd_item.i_vact         = 0;
            rnd_item.i_vfp          = 0;
            rnd_item.i_hsw          = 0;
            rnd_item.i_hbp          = 0;
            rnd_item.i_hact         = 0;
            rnd_item.i_hfp          = 0;
            rnd_item.i_vsync        = 1;
            rnd_item.i_hsync        = 1;
            rnd_item.i_de           = 1;
            rnd_item.i_r_data       = 5;
            rnd_item.i_g_data       = 5;
            rnd_item.i_b_data       = 5;
            send_signal();
        end
    endtask : send_randomize_data
endclass : lb_ro_rand_seq_c



// User sequence Class based on base_seq_c
// which sends user defined signals to the DUT via the driver
class lb_ro_user_seq_c extends lb_ro_base_seq_c;
    `uvm_object_utils(lb_ro_user_seq_c)
    `uvm_declare_p_sequencer(lb_ro_sequencer_c)
    data_mode_e             data_mode;
    bit                     user_bypass             ;
    bit [`RGB_WIDTH-1:0]    user_offset_val         ;
    bit [`VER_WIDTH-1:0]    user_vsw                ;
    bit [`VER_WIDTH-1:0]    user_vbp                ;
    bit [`VER_WIDTH-1:0]    user_vact               ;
    bit [`VER_WIDTH-1:0]    user_vfp                ;
    bit [`HOR_WIDTH-1:0]    user_hsw                ;
    bit [`HOR_WIDTH-1:0]    user_hbp                ;
    bit [`HOR_WIDTH-1:0]    user_hact               ;
    bit [`HOR_WIDTH-1:0]    user_hfp                ;
    bit [`RGB_WIDTH-1:0]    fix_r_data              ;
    bit [`RGB_WIDTH-1:0]    fix_g_data              ;
    bit [`RGB_WIDTH-1:0]    fix_b_data              ;
    // bit                     user_vsync              ;
    // bit                     user_hsync              ;
    // bit                     user_de                 ;

    function new (string name = "lb_ro_user_seq_c");
        super.new(name);
    endfunction : new


    virtual task body();
        `uvm_info(get_type_name(), $sformatf("lb_ro_user_seq_c starts.."), UVM_LOW)
        if (rnd_item == null) rnd_item = new();

        // Send user signals
        repeat (3) vtiming();
        vtiming_end();
        // repeat (100) begin
            // @(posedge p_sequencer.lb_ro_vif.i_clk);
        // end
        `uvm_info(get_type_name(), $sformatf("lb_ro_user_seq_c ends.."), UVM_LOW)
      send_signal();
    endtask

    virtual task vtiming();
        `uvm_info(get_type_name(), "vtiming starts..", UVM_MEDIUM)
        // init
        rnd_item.i_vsync = 1;
        rnd_item.i_hsync = 1;

        // HSYNC
        repeat (rnd_item.i_hsw / 2) begin
            @(posedge p_sequencer.lb_ro_vif.i_clk);
            send_signal();
        end
        rnd_item.i_hsync = 0;

        // VSYNC
        repeat (rnd_item.i_vsw) begin
            for (
                int v = 0;
                v < (rnd_item.i_hact + rnd_item.i_hfp + rnd_item.i_hbp) / 2;
                v++
            ) begin
                @(posedge p_sequencer.lb_ro_vif.i_clk); // Delays time
                send_signal();
            end
        end

        // VBP
        repeat (rnd_item.i_vbp) begin
            rnd_item.i_hsync = 1;
            rnd_item.i_de    = 0;
            rnd_item.i_vsync = 0;
            repeat (rnd_item.i_hsw / 2) begin
                @(posedge p_sequencer.lb_ro_vif.i_clk);
                send_signal();
            end
            rnd_item.i_hsync = 0;
            repeat ((rnd_item.i_hact + rnd_item.i_hfp + rnd_item.i_hbp) / 2) begin
                @(posedge p_sequencer.lb_ro_vif.i_clk);
                send_signal();
            end
        end

        // Active Video
        rnd_item.i_vsync = 0;
        for (int v = 0; v < rnd_item.i_vact; v++) begin
            rnd_item.i_hsync = 1;
            repeat (rnd_item.i_hsw / 2) begin
                @(posedge p_sequencer.lb_ro_vif.i_clk);
                send_signal();
            end

            rnd_item.i_hsync = 0;
            repeat (rnd_item.i_hbp / 2) begin
                @(posedge p_sequencer.lb_ro_vif.i_clk);
                send_signal();
            end

            rnd_item.i_de = 1;
            for (int h = 0; h < rnd_item.i_hact; h++) begin
                if (data_mode == FIX) begin
                    rnd_item.i_r_data = fix_r_data;
                    rnd_item.i_g_data = fix_g_data;
                    rnd_item.i_b_data = fix_b_data;
                    send_signal();
                end else if(data_mode == RANDOM) begin
                    {rnd_item.i_r_data, rnd_item.i_g_data, rnd_item.i_b_data} = $urandom();
                    send_signal();
                end else if (data_mode == INCREASE && h!=0 )begin
                    rnd_item.i_r_data = rnd_item.i_r_data +16;
                    rnd_item.i_g_data = rnd_item.i_g_data +16;
                    rnd_item.i_b_data = rnd_item.i_b_data +16;
                    send_signal();
                end
            end
            rnd_item.i_de = 0;

            repeat (rnd_item.i_hfp / 2) begin
                send_signal();
            end
        end
        if (data_mode == INCREASE)begin
                    rnd_item.i_r_data = 0;
                    rnd_item.i_g_data = 0;
                    rnd_item.i_b_data = 0;
            end
        rnd_item.i_hsync = 1;
        repeat (rnd_item.i_hsw / 2) begin
            @(posedge p_sequencer.lb_ro_vif.i_clk);
            send_signal();
        end
        rnd_item.i_hsync = 0;
        repeat ((rnd_item.i_hact + rnd_item.i_hfp + rnd_item.i_hbp) / 2) begin
            @(posedge p_sequencer.lb_ro_vif.i_clk);
            send_signal();
        end
        repeat (rnd_item.i_vfp / 2) begin
            rnd_item.i_hsync = 1;
            repeat (rnd_item.i_hsw / 2) begin
                @(posedge p_sequencer.lb_ro_vif.i_clk);
                send_signal();
            end
            rnd_item.i_hsync = 0;
            repeat (rnd_item.i_vsw) begin
              for (int v = 0;v < (rnd_item.i_hact + rnd_item.i_hfp + rnd_item.i_hbp) / 2; v++)begin
                    @(posedge p_sequencer.lb_ro_vif.i_clk); // Delays time
                    send_signal();
                end
            end
        end
        `uvm_info(get_type_name(), "vtiming ends..", UVM_MEDIUM)
    endtask : vtiming

    // End of frame timing
    virtual task vtiming_end();
        `uvm_info(get_type_name(), "vtiming starts..", UVM_MEDIUM)
        rnd_item.i_hsync = 1;
        repeat (rnd_item.i_hsw / 2) begin
            @(posedge p_sequencer.lb_ro_vif.i_clk);
            send_signal();
        end
        rnd_item.i_hsync = 0;
        rnd_item.i_vsync = 1;
        repeat (rnd_item.i_vsw) begin
            for (int v = 0; v < (rnd_item.i_hact + rnd_item.i_hfp + rnd_item.i_hbp) / 2; v++) begin
                @(posedge p_sequencer.lb_ro_vif.i_clk); // Delays time
                send_signal();
            end
        end
        rnd_item.i_hsync = 1;
        repeat (rnd_item.i_hsw / 2) begin
            @(posedge p_sequencer.lb_ro_vif.i_clk);
            send_signal();
        end
        rnd_item.i_hsync = 0;
        rnd_item.i_vsync = 0;
        repeat (rnd_item.i_hsw / 2) begin
            @(posedge p_sequencer.lb_ro_vif.i_clk);
            send_signal();
        end
        rnd_item.i_vsync = 0;
        repeat (rnd_item.i_hsw / 2) begin
            @(posedge p_sequencer.lb_ro_vif.i_clk);
            send_signal();
        end
        rnd_item.i_vsync = 0;
        `uvm_info(get_type_name(), "vtiming ends..", UVM_MEDIUM)
    endtask : vtiming_end

endclass : lb_ro_user_seq_c
