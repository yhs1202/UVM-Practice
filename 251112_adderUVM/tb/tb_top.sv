import uvm_pkg::*;
`include "uvm_macros.svh"
`include "interface.sv"
`include "test.sv"

// 3. Testbench module (Layer 0 - top module)
module tb_adder ();
    test t;
    adder_if intf();

    adder dut(
        .a(intf.a),
        .b(intf.b),
        .y(intf.y)
    );

    initial begin
        $fsdbDumpvars(0);
        $fsdbDumpvars("wave.fsdb");
        uvm_config_db #(virtual adder_if)::set(null, "*", "intf", intf);

        run_test("test");
    end

endmodule
