`include "agent.sv"
`include "scoreboard.sv"

// 4. Environment class (layer 2)
class adder_environment extends uvm_env;
    `uvm_component_utils(adder_environment)

    // Constructor
    function new(string name = "env", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    adder_agent agt;
    adder_scoreboard scb;


    // Build phase: create agent, and scoreboard
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create instances of agent and scoreboard
        agt = adder_agent::type_id::create("agt", this);
        scb = adder_scoreboard::type_id::create("scb", this);
    endfunction //build_phase


    // Connect phase (Agent <> Scoreboard)
    // connect agent.monitor analysis export to scoreboard analysis port
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // connect usage: agt.mon.send -> scb.recv
        agt.mon.send.connect(scb.recv);     // Connect monitor to scoreboard, TLM Port-Export connection
    endfunction //connect_phase
endclass //adder_environment extends uvm_env
