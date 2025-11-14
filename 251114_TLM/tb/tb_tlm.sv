// TLM Main Testbench
// Description: NO DUT, NO Interface just a simple TLM communication between components
//              TLM Port-Export connection between comp_a and comp_b
//              uses uvm_blocking_put_imp and uvm_blocking_put_port

import uvm_pkg::*;
`include "uvm_macros.svh"

module tb_tlm ();
    initial begin
        run_test("test");
    end

    initial begin
        $fsdbDumpfile("wave.fsdb");
        $fsdbDumpvars(0);
    end
endmodule
