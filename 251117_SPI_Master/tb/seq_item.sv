// Sequence Item
class spi_seq_item extends uvm_sequence_item;
    rand bit [7:0] tx_data;
         bit [7:0] rx_data;

    function new(string name = "spi_seq_item");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(spi_seq_item)
        `uvm_field_int(tx_data, UVM_ALL_ON)
        `uvm_field_int(rx_data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass
