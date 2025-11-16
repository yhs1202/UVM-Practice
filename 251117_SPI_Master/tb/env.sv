// 8. Environment
class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    function new(string name = "env", uvm_component parent);
        super.new(name, parent);
    endfunction

    spi_agent agt;
    spi_scoreboard scb;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = spi_agent::type_id::create("agt", this);
        scb = spi_scoreboard::type_id::create("scb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.send.connect(scb.recv);
    endfunction
endclass
