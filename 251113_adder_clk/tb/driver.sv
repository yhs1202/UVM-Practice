
// 7. Driver class (layer 4)
class adder_driver extends uvm_driver #(seq_item);
    `uvm_component_utils(adder_driver)

    // Constructor
    function new(string name = "drv", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Virtual interface handle
    virtual adder_if vif;
    // Transaction item
    seq_item item;


    // Build phase: get virtual interface from config DB
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = seq_item::type_id::create("item", this); // Create item
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "intf", vif)) begin
            `uvm_fatal("DRV", "Virtual interface not found in uvm_config_db")
        end
    endfunction //build_phase

    // Main run phase: get transactions from sequencer and drive DUT inputs
    task run_phase(uvm_phase phase);
        #10; // Wait for some time before starting
        forever begin
            // Get transaction from sequencer
            // seq_item_port: where driver gets transactions from sequencer
            // get_next_item: driver calls this to get the next transaction
            seq_item_port.get_next_item(item);

            // Wait for a clock cycle
            @(posedge vif.clk);

            // Drive DUT inputs
            // Use non-blocking assignments to drive inputs
            vif.a <= item.a;
            vif.b <= item.b;

            // Print driven values
            `uvm_info("DRIVER", $sformatf("Driving: a=%0d, b=%0d", item.a, item.b), UVM_LOW)

            // Wait for a clock cycle (assuming clock is handled elsewhere)
            @(posedge vif.clk); // Wait for output to be valid

            // Indicate that the item is done
            seq_item_port.item_done();
        end
    endtask //run_phase
endclass //adder_driver extends uvm_driver #(seq_item)
