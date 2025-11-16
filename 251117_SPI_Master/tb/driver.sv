// Driver
class spi_driver extends uvm_driver #(spi_seq_item);
    `uvm_component_utils(spi_driver)

    function new(string name = "drv", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual spi_if spi_vif;
    spi_seq_item item;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = spi_seq_item::type_id::create("item", this);
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", spi_vif)) begin
            `uvm_fatal("DRV", "Failed to get spi_if");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(item);
            wait (spi_vif.tx_ready == 1);

            @(posedge spi_vif.clk);
            spi_vif.tx_data <= item.tx_data;
            spi_vif.start   <= 1;

            @(posedge spi_vif.clk);
            spi_vif.start <= 0;

            wait (spi_vif.done == 1);
            @(posedge spi_vif.clk);
           // item.rx_data = spi_vif.rx_data;

            `uvm_info("DRV", $sformatf("TX: %0h", item.tx_data), UVM_LOW)
            seq_item_port.item_done();
        end
    endtask

endclass