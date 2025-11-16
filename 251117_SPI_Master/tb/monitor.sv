// 5. Monitor
class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    uvm_analysis_port #(spi_seq_item) send;

    function new(string name = "mon", uvm_component parent);
        super.new(name, parent);
        send = new("send", this);
    endfunction

    virtual spi_if spi_vif;
    spi_seq_item item;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = spi_seq_item::type_id::create("item", this);
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", spi_vif)) begin
            `uvm_fatal("MON", "interface not found");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge spi_vif.done);
            #1;
            @(posedge spi_vif.clk)
            item = spi_seq_item::type_id::create("item");
            item.tx_data = spi_vif.tx_data;
            item.rx_data = spi_vif.rx_data;

            `uvm_info("MON", $sformatf("TX: %0x, RX: %0x", item.tx_data, item.rx_data),UVM_LOW)
            send.write(item);
        end
    endtask
endclass
