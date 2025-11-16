// 6. Scoreboard
class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)

    uvm_analysis_imp #(spi_seq_item, spi_scoreboard) recv;
    spi_seq_item item;

    function new(string name = "scb", uvm_component parent);
        super.new(name, parent);
        recv = new("recv", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = spi_seq_item::type_id::create("item", this);
    endfunction

    function void write(spi_seq_item spi_item);
        item = spi_item;
        `uvm_info("scb",$sformatf("[SCOREBOARD] TX: %0h -> RX: %0h", item.tx_data, item.rx_data), UVM_LOW)

        if (item.rx_data == item.tx_data) begin
            `uvm_info("scb", "*** TEST PASSED ***", UVM_NONE)
        end

        else begin
            `uvm_error("scb", "*** TEST FAIL ***")
        end
    endfunction
endclass
