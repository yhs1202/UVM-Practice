
// Transaction class, like sequence item class
class transaction extends uvm_sequence_item;

    // Data members
    rand logic write;
    rand logic [31:0] addr;
    rand logic [31:0] wdata;


    function new(string name = "transaction");
        super.new(name);
    endfunction //new()


    constraint addr_c { addr inside {[0:255]}; }

    `uvm_object_utils_begin(transaction)
        `uvm_field_int(write, UVM_DEFAULT)
        `uvm_field_int(addr, UVM_DEFAULT)
        `uvm_field_int(wdata, UVM_DEFAULT)
    `uvm_object_utils_end

endclass
