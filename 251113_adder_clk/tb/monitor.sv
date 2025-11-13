
// 8. Monitor class (layer 4)
class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)

    // Virtual interface handle
    virtual adder_if vif;

    // Constructor
    function new(string name = "mon", uvm_component parent);
        super.new(name, parent);
        send = new("WRITE", this); // Initialize analysis port
    endfunction //new()

    // Analysis export to send transactions to scoreboard
    // <> uvm_analysis_imp
    uvm_analysis_port #(seq_item) send;   // send port

    // Transaction item
    seq_item item;

    // Build phase: get virtual interface from config DB
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = seq_item::type_id::create("item"); // Create item
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "intf", vif)) begin
            `uvm_fatal("MON", "Virtual interface not found in uvm_config_db")
        end
    endfunction //build_phase


    // Main run phase: monitor DUT outputs and send transactions to scoreboard
    task run_phase(uvm_phase phase);
        #10;
        forever begin
            // Wait for a clock cycle
            @(posedge vif.clk);
            // Capture DUT inputs and output
            item.a = vif.a;
            item.b = vif.b;
            @(posedge vif.clk);
            item.y = vif.y;

            `uvm_info("MON", $sformatf("Monitoring: a=%0d, b=%0d, y=%0d", item.a, item.b, item.y), UVM_LOW)
            // item.print(uvm_default_line_printer); // Print captured transaction

            // Send captured item to scoreboard
            send.write(item);
        end
    endtask //run_phase
endclass //adder_monitor extends uvm_monitor
