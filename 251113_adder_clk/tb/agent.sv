`include "seq_item.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"

// 5. Agent class (layer 3)
class adder_agent extends uvm_agent;
    `uvm_component_utils(adder_agent)

    // Constructor
    function new(string name = "agt", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    uvm_sequencer #(seq_item) sqr;  // uvm_sequencer instance: sequencer for seq_item transactions
    adder_driver drv;
    adder_monitor mon;


    // Build phase: create sequencer, driver, and monitor
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = uvm_sequencer#(seq_item)::type_id::create("sqr", this);
        drv = adder_driver::type_id::create("drv", this);
        mon = adder_monitor::type_id::create("mon", this);
    endfunction //build_phase

    // Connect phase (driver <> sequencer)
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // seq_item_port: where driver gets transactions from sequencer
        drv.seq_item_port.connect(sqr.seq_item_export); // Connect sequencer to driver.seq_item_port, TLM Port-Export connection
    endfunction //connect_phase
endclass //adder_agent extends uvm_agent
