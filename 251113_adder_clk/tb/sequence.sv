
// 10. Sequence class (layer 2)
class adder_sequence extends uvm_sequence #(seq_item);
    // object utilities macro
    `uvm_object_utils(adder_sequence)

    // Constructor
    function new(string name = "adder_sequence");
        super.new(name);
    endfunction //new()

    seq_item item;

    // Body task: main execution of the sequence
    task body();
        #10;
        // Generate random values for the sequence item
        item = seq_item::type_id::create("item"); // Create new item

        // Start the item
        for (int i = 0; i < 100; i++) begin
            start_item(item);
            // Randomize the item
            if (!item.randomize()) `uvm_fatal("SEQ", "Randomization failed");
            `uvm_info("SEQ", $sformatf("Generated item %0d: a=%0d, b=%0d", i, item.a, item.b), UVM_NONE);
            finish_item(item);
        end
    endtask //body
endclass //adder_sequence extends uvm_sequence #(seq_item)
