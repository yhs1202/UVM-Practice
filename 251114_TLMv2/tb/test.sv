// Test class (layer 1)
class test extends uvm_test;
    `uvm_component_utils(test)


    // Constructor
    function new(string name = "test", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare environment and sequence (inside objects)
    environment env;  // Environment instance
    // sequence seq;     // Sequence instance


    // Build phase: override to create environment and sequence
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create instances of environment and sequence using UVM factory
        env = environment::type_id::create("env", this);
        // seq = sequence::type_id::create("seq", this);
    endfunction


    // Connect phase: override to connect components
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect components if needed
        // (No specific connections in test class in this example)
    endfunction


    // 2-5: Start of simulation phase: to start the simulation (Optional)
    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        // Print the UVM component hierarchy
        uvm_root::get().print_topology();
    endfunction


    // Run phase: "main" execution phase of the test
    task run_phase(uvm_phase phase);
        // // Raise objection to keep the simulation running
        // phase.raise_objection(this);

        // // Start the sequence (sequence -> sequencer -> driver)
        // // sequence (layer 1) -> env (layer 2) -> agent (layer 3) -> sequencer (layer 4)
        // seq.start(env.agt.sqr);

        // // Drop the objection
        // phase.drop_objection(this);

        // #20;

    endtask //run_phase
endclass //test extends uvm_test
