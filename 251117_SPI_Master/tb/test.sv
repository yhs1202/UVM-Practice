// 9. Test
class spi_test extends uvm_test;
    `uvm_component_utils(spi_test)

    function new(string name = "test", uvm_component parent);
        super.new(name, parent);
    endfunction

    spi_sequence seq;
    spi_env env;

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        uvm_root::get().print_topology();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq = spi_sequence::type_id::create("seq", this);
        env = spi_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask
endclass
