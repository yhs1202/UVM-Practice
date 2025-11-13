
// 6. Scoreboard class (layer 3)
class adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(adder_scoreboard)

    // No internal objects needed

    // Analysis export to receive transactions from monitor
    // uvm_analysis_imp: analysis implementation class to implement analysis export
    // #(seq_item, adder_scoreboard): seq_item is the type of transaction, adder_scoreboard is the class implementing the export
    uvm_analysis_imp #(seq_item, adder_scoreboard) recv;    // receive port

    seq_item item_from_mon; // Received transactions from DUT->monitor


    // Constructor
    function new(string name = "scb", uvm_component parent);
        super.new(name, parent);
        recv = new("READ", this); // Initialize analysis export
    endfunction //new()

    // build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_from_mon = seq_item::type_id::create("item_from_mon", this); // Create item_from_mon
    endfunction //build_phase


    // write: called when a transaction is received from monitor
    virtual function void write(seq_item item);
        item_from_mon = item; // Store received transaction
        `uvm_info("SCOREBOARD", $sformatf("Scoreboard received: a=%0d, b=%0d, y=%0d", item.a, item.b, item.y), UVM_LOW)
        // item.print(uvm_default_printer); // Print received transaction
        // Check if the sum is correct
        if (item_from_mon.y !== (item_from_mon.a + item_from_mon.b)) begin
            `uvm_error("SCOREBOARD", $sformatf("Mismatch: a=%0d, b=%0d, y=%0d, expected=%0d", item_from_mon.a, item_from_mon.b, item_from_mon.y, item_from_mon.a + item_from_mon.b))
        end else begin
            `uvm_info("SCOREBOARD", "Match: Correct sum", UVM_NONE)
        end
    endfunction //write()
endclass //adder_scoreboard extends uvm_scoreboard
