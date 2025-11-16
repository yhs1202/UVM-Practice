// Main testbench module for SPI Master

`include "uvm_macros.svh"
import uvm_pkg::*;


module tb_spi_master;
    spi_if spi_vif();

    spi_master dut (
        .clk(spi_vif.clk),
        .rst(spi_vif.rst),
        .start(spi_vif.start),
        .tx_data(spi_vif.tx_data),
        .rx_data(spi_vif.rx_data),
        .done(spi_vif.done),
        .tx_ready(spi_vif.tx_ready),
        .SCLK(spi_vif.SCLK),
        .MOSI(spi_vif.MOSI),
        .MISO(spi_vif.MISO),
        .CPOL(1'b0),
        .CPHA(1'b0)
    );

    // Loopback for MISO
    assign spi_vif.MISO = spi_vif.MOSI;

    always #5 spi_vif.clk = ~spi_vif.clk;

    initial begin
        spi_vif.clk = 0;
        uvm_config_db#(virtual spi_if)::set(null, "*", "spi_vif", spi_vif);
        run_test("spi_test");
    end

    initial begin
        spi_vif.rst = 1;
        #10; spi_vif.rst = 0;
    end

    initial begin
        $fsdbDumpvars(0);
        $fsdbDumpfile("wave.fsdb");
    end

endmodule
