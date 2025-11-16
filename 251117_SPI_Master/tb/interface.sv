// Interface
interface spi_if();
    logic clk;
    logic rst;
    logic start; // input
    logic [7:0] tx_data; // input
    logic [7:0] rx_data;
    logic done;
    logic tx_ready;
    logic SCLK;
    logic MOSI; // loopback
    logic MISO;
endinterface
