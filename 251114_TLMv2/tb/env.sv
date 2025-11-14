// Environment class
class environment extends uvm_env;
    `uvm_component_utils(environment)

    // Constructor
    function new(string name = "env", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    comp_a a;   // sender component
    comp_b b;   // receiver component
    comp_c c;   // added component
    comp_d d;   // added component


    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create instances
        a = comp_a::type_id::create("a", this);
        b = comp_b::type_id::create("b", this);
        c = comp_c::type_id::create("c", this);
        d = comp_d::type_id::create("d", this);
    endfunction //build_phase




    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // connect usage: agt.mon.send -> scb.recv
        a.send.connect(b.recv);
        a.send.connect(c.recv);
        a.send.connect(d.recv);
    endfunction //connect_phase
endclass //environment extends uvm_env
