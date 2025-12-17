class lb_ro_base_seq_c extends uvm_sequence #(lb_ro_drv_pkt_c);
    `uvm_object_utils(lb_ro_base_seq_c)

    lb_ro_seq_item_c rnd_item;

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
    bit                     user_bypass      = 0        ;
    bit [`RGB_WIDTH-1:0]    user_offset_val  = 0        ;
    bit [`VER_WIDTH-1:0]    user_vsw         = 2        ;
    bit [`VER_WIDTH-1:0]    user_vbp         = 4        ;
    bit [`VER_WIDTH-1:0]    user_vact        = 5        ;
    bit [`VER_WIDTH-1:0]    user_vfp         = 4        ;
    bit [`HOR_WIDTH-1:0]    user_hsw         = 2        ;
    bit [`HOR_WIDTH-1:0]    user_hbp         = 4        ;
    bit [`HOR_WIDTH-1:0]    user_hact        = 10       ;
    bit [`HOR_WIDTH-1:0]    user_hfp         = 4        ;
    // bit                     user_vsync       = 0        ;
    // bit                     user_hsync       = 0        ;
    // bit                     user_de          = 0        ;
    bit [`RGB_WIDTH-1:0]    user_r_data      = 5        ;
    bit [`RGB_WIDTH-1:0]    user_g_data      = 5        ;
    bit [`RGB_WIDTH-1:0]    user_b_data      = 5        ;

    function new (string name = "lb_ro_user_seq_c");
        super.new(name);
    endfunction : new


    virtual task body();
        `uvm_info(get_type_name(), $sformatf("lb_ro_user_seq_c starts.."), UVM_LOW)

        // Send user signals
        send_init(5);
        // send_randomize_data(3);
        send_user(3);
        send_init(2);
        // send_randomize_all(6);
        send_init(6);
        send_init(2);

        `uvm_info(get_type_name(), $sformatf("lb_ro_user_seq_c ends.."), UVM_LOW)
    endtask : body


    task send_user(input int size = 1);
        for (int i = 1; i <= size; i++) begin
            rnd_item.i_bypass      = 1     ;
            rnd_item.i_offset_val  = user_offset_val ;
            rnd_item.i_vsw         = user_vsw        ;
            rnd_item.i_vbp         = user_vbp        ;
            rnd_item.i_vact        = user_vact       ;
            rnd_item.i_vfp         = user_vfp        ;
            rnd_item.i_hsw         = user_hsw        ;
            rnd_item.i_hbp         = user_hbp        ;
            rnd_item.i_hact        = user_hact       ;

            rnd_item.i_hfp         = user_hfp        ;
            rnd_item.i_vsync       = 1               ;
            rnd_item.i_hsync       = 1               ;
            rnd_item.i_de          = 1               ;
            rnd_item.i_r_data      = user_r_data     ;
            rnd_item.i_g_data      = user_g_data     ;
            rnd_item.i_b_data      = user_b_data     ;
            send_signal();
        end
    endtask : send_user
endclass : lb_ro_user_seq_c