import "DPI-C" context function int unsigned addFunc(int unsigned a, int unsigned b, int unsigned c);

`uvm_analysis_imp_decl(_in_lb_ro)
`uvm_analysis_imp_decl(_out_lb_ro)

class lb_ro_sb_c extends uvm_scoreboard;
    `uvm_component_utils(lb_ro_sb_c)

    typedef struct packed {
        bit [`RGB_WIDTH-1:0] r, g, b;
    } rgb_set;


    // Analysis exports to connect to monitor
    uvm_analysis_imp_in_lb_ro #(lb_ro_mon_pkt_c, lb_ro_sb_c) in_lb_ro_imp_port;
    uvm_analysis_imp_out_lb_ro#(lb_ro_mon_pkt_c, lb_ro_sb_c) out_lb_ro_imp_port;

    // Queues to store expected and DUT results
    rgb_set c_result_q[$];
    rgb_set rtl_result_q[$];

    // Counters
    int match_cnt = 0;
    int mismatch_cnt = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        in_lb_ro_imp_port = new("in_lb_ro_imp_port", this);
        out_lb_ro_imp_port = new("out_lb_ro_imp_port", this);
    endfunction : new


    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    // Report phase
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), "Report Phase started", UVM_LOW)
        if ()
    endfunction : report_phase

    // Write methods for input analysis ports
    virtual function void write_in_lb_ro(lb_ro_mon_pkt_c pkt);
        if(pkt.i_de) begin
        `uvm_info("SB", "Input packet received", UVM_LOW)
    end
    endfunction : write_in_lb_ro

    virtual function void write_out_lb_ro(lb_ro_mon_pkt_c pkt);
        rgb_set actual_result;
        actual_result.r = pkt.o_r_data;
        actual_result.g = pkt.o_g_data;
        actual_result.b = pkt.o_b_data;
        rtl_result_q.push_back(actual_result);
    endfunction : write_out_lb_ro


endclass : lb_ro_sb_c
