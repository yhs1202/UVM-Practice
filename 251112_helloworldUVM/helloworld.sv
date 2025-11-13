program automatic test;
    // Import UVM package
    import uvm_pkg::*;

    // Define hello_world test class
    class hello_world extends uvm_test; // extends: inherits from uvm_test
        // Register the class with UVM factory
        // This allows UVM to create instances of the class
        `uvm_component_utils(hello_world)   // macro -> no semicolon

        // Constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        // run_phase: main execution phase of the test 
        // virtual: can be overridden in derived classes
        // uvm_phase: UVM phase object
        virtual task run_phase(uvm_phase phase);

            // objection mechanism: used to control the end of simulation
            // raise_objection: indicates that the component is still active (keep simulation running)
            phase.raise_objection(this);


            // Print "hello world uvm" message
            // UVM_INFO: macro to print info messages
            // Arguments: (id, message, verbosity)
            // message can be a string literal or a variable
            // verbosity levels: UVM_LOW, UVM_MEDIUM, UVM_HIGH, UVM_DEBUG
            // UVM_LOW: least verbose, UVM_DEBUG: most verbose
            `uvm_info("TEST", "hello world uvm", UVM_MEDIUM);

            // drop objection to allow simulation to end
            phase.drop_objection(this);
        endtask
    endclass //helloworld extends uvm_test

    // Initial block to start the test
    initial begin
        // Start the UVM test with the name "hello_world"
        // run_test: UVM function to start the test
        // Argument: name of the test class to run
        // This will create an instance of hello_world and execute it
        run_test("hello_world");
    end
endprogram
