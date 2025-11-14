
class comp_a extends uvm_component;
    `uvm_component_utils(comp_a)

    // Constructor
    function new(string name = "comp_a", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    uvm_analysis_port #(transaction) send; // TLM port to send transactions

    // rand int data; // data to send
    transaction t;



    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        send = new("send", this);
        t = new();
    endfunction //build_phase

    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction //connect_phase


    // run phase: generate and send transactions
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        // Create and send 10 transactions
        repeat (10) begin
            assert(t.randomize());
            // Send the transaction via TLM port
            send.write(t); // analysis: write method
            `uvm_info("comp_a", $sformatf("Sent transaction: write=%0h, addr= %0h, wdata=%0h", t.write, t.addr, t.wdata), UVM_NONE)
            t.print(uvm_default_line_printer);
        end

        phase.drop_objection(this);
    endtask //run_phase
endclass //comp_a extends uvm_component
