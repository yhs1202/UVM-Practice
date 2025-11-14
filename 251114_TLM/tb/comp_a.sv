
class comp_a extends uvm_component;
    `uvm_component_utils(comp_a)

    // Constructor
    function new(string name = "comp_a", uvm_component parent);
        super.new(name, parent);
        send = new("send", this);
    endfunction //new()

    // Declare inside objects
    uvm_blocking_put_port #(int) send; // TLM port to send transactions

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
        phase.raise_objection(this);

        // Create and send 10 transactions
        repeat (10) begin
            assert(this.randomize());
            // Send the transaction via TLM port
            send.put(data);
            `uvm_info("comp_a", $sformatf("Sent transaction: data=%0d", data), UVM_NONE)
        end

        phase.drop_objection(this);
    endtask //run_phase
endclass //comp_a extends uvm_component
