
// 9. Sequence item class, like transaction class
class seq_item extends uvm_sequence_item;
    // Data members
    rand bit [7:0] a;
    rand bit [7:0] b;
    bit [8:0] y; // output

    // Constructor
    function new(string name = "seq_item");
        super.new(name);
    endfunction //new()

    // object utilities macro
    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(a, UVM_DEFAULT)
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end

endclass //seq_item extends uvm_sequence_item
