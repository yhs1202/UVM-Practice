
class comp_b extends uvm_component;
    `uvm_component_utils(comp_b)

    // Constructor
    function new(string name = "comp_b", uvm_component parent);
        super.new(name, parent);
        recv = new("recv", this);
    endfunction //new()

    // Declare inside objects
    uvm_blocking_put_imp #(int, comp_b) recv; // TLM port to receive transactions

    rand int data; // data to send


    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction //build_phase

    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction //connect_phase


    // run phase: generate and send transactions
    task run_phase(uvm_phase phase);
        super.run_phase(phase);

    endtask //run_phase

    // Put task implementation for recv port
    task put(int data);
        `uvm_info("comp_b", $sformatf("Received transaction: data=%0d", data), UVM_NONE)
    endtask //put
endclass //comp_b extends uvm_component
