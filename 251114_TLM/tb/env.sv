// Environment class (layer 2)
class environment extends uvm_env;
    `uvm_component_utils(environment)

    // Constructor
    function new(string name = "env", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    comp_a a;   // sender component
    comp_b b;   // receiver component


    // Build phase: create agent, and scoreboard
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create instances of agent and scoreboard
        a = comp_a::type_id::create("a", this);
        b = comp_b::type_id::create("b", this);
    endfunction //build_phase




    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // connect usage: agt.mon.send -> scb.recv
        a.send.connect(b.recv);
    endfunction //connect_phase
endclass //environment extends uvm_env
