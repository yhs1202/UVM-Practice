import uvm_pkg::*;
`include "uvm_macros.svh"

// 1. Interface
interface adder_if();
    logic [7:0] a;
    logic [7:0] b;
    logic [8:0] y;
endinterface //adder_if

// 9. Sequence item class, like transaction class
class seq_item extends uvm_sequence_item;
    // Data members
    rand bit [7:0] a;
    rand bit [7:0] b;
    bit [8:0] y; // output

    // Constructor
    function new(string name = "seq_item");
        super.new(name);
    endfunction //new()

    // object utilities macro
    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(a, UVM_DEFAULT)
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end

endclass //seq_item extends uvm_sequence_item


// 10. Sequence class (layer 2)
class adder_sequence extends uvm_sequence #(seq_item);
    // object utilities macro
    `uvm_object_utils(adder_sequence)

    // Constructor
    function new(string name = "adder_sequence");
        super.new(name);
    endfunction //new()

    seq_item item;

    // Body task: main execution of the sequence
    virtual task body();
        // Generate random values for the sequence item
        item = seq_item::type_id::create("item"); // Create new item

        // Start the item
        for (int i = 0; i < 100; i++) begin
            start_item(item);
            // Randomize the item
            if (!item.randomize()) `uvm_fatal("SEQ", "Randomization failed");
            `uvm_info("SEQ", $sformatf("Generated item %0d: a=%0d, b=%0d", i, item.a, item.b), UVM_NONE);
            finish_item(item);
        end
    endtask //body
endclass //adder_sequence extends uvm_sequence #(seq_item)



////////////////////////////////////////////////////////////////////////////
//////////// LAYER 4: SEQUENCER (NOT SEQUENCE), DRIVER, MONITOR ////////////
////////////////////////////////////////////////////////////////////////////

// 7. Driver class (layer 4)
class adder_driver extends uvm_driver #(seq_item);
    `uvm_component_utils(adder_driver)

    // Constructor
    function new(string name = "drv", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Virtual interface handle
    virtual adder_if vif;
    // Transaction item
    seq_item item;


    // Build phase: get virtual interface from config DB
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = seq_item::type_id::create("item", this); // Create item
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "intf", vif)) begin
            `uvm_fatal("DRV", "Virtual interface not found in uvm_config_db")
        end
    endfunction //build_phase

    // Main run phase: get transactions from sequencer and drive DUT inputs
    virtual task run_phase(uvm_phase phase);
        forever begin
            // Get transaction from sequencer
            // seq_item_port: where driver gets transactions from sequencer
            // get_next_item: driver calls this to get the next transaction
            seq_item_port.get_next_item(item);

            // Drive DUT inputs
            // Use non-blocking assignments to drive inputs
            vif.a <= item.a;
            vif.b <= item.b;

            // Print driven values
            `uvm_info("DRIVER", $sformatf("Driving: a=%0d, b=%0d", item.a, item.b), UVM_LOW)

            // Wait for a clock cycle (assuming clock is handled elsewhere)
            // @(posedge vif.y); // Wait for output to be valid
            #10;

            // Indicate that the item is done
            seq_item_port.item_done();
        end
    endtask //run_phase
endclass //adder_driver extends uvm_driver #(seq_item)



// 8. Monitor class (layer 4)
class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)

    // Virtual interface handle
    virtual adder_if vif;

    // Constructor
    function new(string name = "mon", uvm_component parent);
        super.new(name, parent);
        send = new("WRITE", this); // Initialize analysis port
    endfunction //new()

    // Analysis export to send transactions to scoreboard
    uvm_analysis_port #(seq_item) send;   // send port

    // Transaction item
    seq_item item;

    // Build phase: get virtual interface from config DB
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = seq_item::type_id::create("item"); // Create item
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "intf", vif)) begin
            `uvm_fatal("MON", "Virtual interface not found in uvm_config_db")
        end
    endfunction //build_phase


    // Main run phase: monitor DUT outputs and send transactions to scoreboard
    virtual task run_phase(uvm_phase phase);
        forever begin
            // Wait for a clock cycle (assuming clock is handled elsewhere)
            // @(posedge vif.y); // Wait for output to be valid
            #10;
            // Capture DUT inputs and output
            item.a = vif.a;
            item.b = vif.b;
            item.y = vif.y;

            `uvm_info("MON", $sformatf("Monitoring: a=%0d, b=%0d, y=%0d", item.a, item.b, item.y), UVM_LOW)
            // item.print(uvm_default_line_printer); // Print captured transaction

            // Send captured item to scoreboard
            send.write(item);
        end
    endtask //run_phase
endclass //adder_monitor extends uvm_monitor



////////////////////////////////////////////////////////////////////////////
//////////////////// LAYER 3: AGENT, SCOREBOARD ////////////////////////////
////////////////////////////////////////////////////////////////////////////
// 5. Agent class (layer 3)
class adder_agent extends uvm_agent;
    `uvm_component_utils(adder_agent)

    // Constructor
    function new(string name = "agt", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    // Declare inside objects
    uvm_sequencer #(seq_item) sqr;  // uvm_sequencer instance: sequencer for seq_item transactions
    adder_driver drv;
    adder_monitor mon;


    // Build phase: create sequencer, driver, and monitor
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = uvm_sequencer#(seq_item)::type_id::create("sqr", this);
        drv = adder_driver::type_id::create("drv", this);
        mon = adder_monitor::type_id::create("mon", this);
    endfunction //build_phase

    // Connect phase (driver <> sequencer)
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // seq_item_port: where driver gets transactions from sequencer
        drv.seq_item_port.connect(sqr.seq_item_export); // Connect sequencer to driver.seq_item_port, TLM Port-Export connection
    endfunction //connect_phase
endclass //adder_agent extends uvm_agent



// 6. Scoreboard class (layer 3)
class adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(adder_scoreboard)

    // No internal objects needed

    // Analysis export to receive transactions from monitor
    // uvm_analysis_imp: analysis implementation class to implement analysis export
    // #(seq_item, adder_scoreboard): seq_item is the type of transaction, adder_scoreboard is the class implementing the export
    uvm_analysis_imp #(seq_item, adder_scoreboard) recv;    // receive port

    seq_item item_from_mon; // Received transactions from DUT->monitor


    // Constructor
    function new(string name = "scb", uvm_component parent);
        super.new(name, parent);
        recv = new("READ", this); // Initialize analysis export
    endfunction //new()

    // build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_from_mon = seq_item::type_id::create("item_from_mon", this); // Create item_from_mon
    endfunction //build_phase


    // write: called when a transaction is received from monitor
    virtual function void write(seq_item item);
        item_from_mon = item; // Store received transaction
        `uvm_info("SCOREBOARD", $sformatf("Scoreboard received: a=%0d, b=%0d, y=%0d", item.a, item.b, item.y), UVM_LOW)
        // item.print(uvm_default_printer); // Print received transaction
        // Check if the sum is correct
        if (item_from_mon.y !== (item_from_mon.a + item_from_mon.b)) begin
            `uvm_error("SCOREBOARD", $sformatf("Mismatch: a=%0d, b=%0d, y=%0d, expected=%0d", item_from_mon.a, item_from_mon.b, item_from_mon.y, item_from_mon.a + item_from_mon.b))
        end else begin
            `uvm_info("SCOREBOARD", "Match: Correct sum", UVM_NONE)
        end
    endfunction //write()
endclass //adder_scoreboard extends uvm_scoreboard



////////////////////////////////////////////////////////////////////////////
////////////// LAYER 2: ENVIRONMENT, SEQUENCE (line 11-59) /////////////////
////////////////////////////////////////////////////////////////////////////
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



////////////////////////////////////////////////////////////////////////////
////////////// LAYER 1, 0: TEST, TESTBENCH ///////////////////////////
////////////////////////////////////////////////////////////////////////////
// 2. Test class (layer 1)
class test extends uvm_test;
    // 2-1: Register the class with UVM factory
    `uvm_component_utils(test)

    // 2-2: Constructor
    function new(string name = "TEST", uvm_component parent);
        super.new(name, parent); // Call parent constructor
    endfunction //new()

    // 2-3: Declare environment and sequence (inside objects)
    adder_environment env;  // Environment instance
    adder_sequence seq;     // Sequence instance


    // 2-4: Build phase: override to create environment and sequence
    // Parameter: uvm_phase phase
    // Phases are predefined simulation stages in UVM, such as build, connect, run, etc.
    virtual function void build_phase(uvm_phase phase);
        // Call super class build_phase
        super.build_phase(phase);           // Always call the parent class's build_phase

        // Create instances of environment and sequence using UVM factory
        env = adder_environment::type_id::create("env", this);
        seq = adder_sequence::type_id::create("seq", this);
    endfunction


    // 2-5: Start of simulation phase: to start the simulation
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        // Print the UVM component hierarchy
        uvm_root::get().print_topology();
    endfunction


    // 2-6: Run phase: "main" execution phase of the test
    virtual task run_phase(uvm_phase phase);
        // Raise objection to keep the simulation running
        phase.raise_objection(this);

        // Start the sequence (sequence -> sequencer -> driver)
        // sequence (layer 1) -> env (layer 2) -> agent (layer 3) -> sequencer (layer 4)
        seq.start(env.agt.sqr);

        // Drop the objection
        phase.drop_objection(this);
    endtask //run_phase
endclass //test extends uvm_test



// 3. Testbench module (Layer 0 - top module)
module tb_adder ();
    test t;
    adder_if intf();

    adder dut(
        .a(intf.a),
        .b(intf.b),
        .y(intf.y)
    );

    initial begin
        $fsdbDumpvars(0);
        $fsdbDumpvars("wave.fsdb");
        uvm_config_db #(virtual adder_if)::set(null, "*", "intf", intf);

        run_test("test");
    end

endmodule