// TLMv2 Main Testbench
// Description: NO DUT, NO Interface just a simple TLM communication between components
//              TLM Port-Export connection between comp_a and comp_b, comp_c, comp_d
//              uses uvm_analysis_imp and uvm_analysis_port

import uvm_pkg::*;
`include "uvm_macros.svh"

module tb_tlm_v2 ();
    initial begin
        run_test("test");
    end

    initial begin
        $fsdbDumpfile("wave.fsdb");
        $fsdbDumpvars(0);
    end
endmodule
