// Sequence
class spi_sequence extends uvm_sequence #(spi_seq_item);
    `uvm_object_utils(spi_sequence)

    function new(string name = "SEQ");
        super.new(name);
    endfunction

    spi_seq_item item;

    virtual task body();
        item = spi_seq_item::type_id::create("item");

        for (int i = 0; i < 100; i++) begin
            start_item(item);
            item.randomize();
            $display("");
            `uvm_info("seq",$sformatf("seq item to driver tx_data: %0x", item.tx_data),UVM_NONE);
            finish_item(item);
        end
    endtask
endclass