import uvm_pkg::*;
`include "uvm_macros.svh"
`include "interface.sv"
`include "test.sv"

// 3. Testbench module (Layer 0 - top module)
module tb_adder_clk ();
    logic clk;
    logic rst;
    adder_if intf(
        .clk(clk),
        .rst(rst)
    );

    adder_clk dut(
        .clk(intf.clk),
        .rst(intf.rst),
        .a(intf.a),
        .b(intf.b),
        .y(intf.y)
    );

    always #5 clk = ~clk;

    initial begin
        uvm_config_db #(virtual adder_if)::set(null, "*", "intf", intf);
        run_test("test");
        #10;
    end


    // `ifdef FSDB
    initial begin
        $fsdbDumpvars(0);
        $fsdbDumpfile("wave.fsdb");
        clk = 0; rst = 1;
        #10; rst = 0;
    end
    // `endif

endmodule
