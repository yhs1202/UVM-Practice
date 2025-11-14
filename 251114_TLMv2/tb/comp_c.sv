
class comp_c extends uvm_component;
    `uvm_component_utils(comp_c)

    // Constructor
    function new(string name = "comp_c", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    uvm_analysis_imp #(transaction, comp_c) recv; // TLM port to receive transactions

    // rand int data; // data to send
    transaction t;


    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        recv = new("recv", this);
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
    // task put(int data);
        // `uvm_info("comp_c", $sformatf("Received transaction: data=%0d", data), UVM_NONE)
    // endtask //put

    function void write(transaction t);
        `uvm_info("comp_c", $sformatf("Received transaction via write(): write=%0h, addr= %0h, wdata=%0h", t.write, t.addr, t.wdata), UVM_NONE)
        t.print(uvm_default_line_printer);
    endfunction //write
endclass //comp_c extends uvm_component
