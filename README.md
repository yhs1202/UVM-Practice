# UVM-Practice

This repository contains a UVM-1.2 based verification environment for practicing and learning UVM concepts using Synopsys VCS and Verdi tools.

It also includes a comprehensive UVM Study Log, detailing the methodology's architecture and advanced concepts.

<details>

**<summary>Project Setup & Makefile</summary>**

## Prerequisites
- Synopsys VCS simulator
- Synopsys Verdi for waveform viewing and debugging
- Basic knowledge of SystemVerilog and UVM concepts

## Directory Structure
- `rtl/`: Contains the DUT (Device Under Test) source files.

- `tb/`: Contains UVM environment files including agents, drivers, monitors, and sequences, as well as the top-level testbench.sv

- `clean.sh`: Script to clean up generated files from simulation and compilation.

- `run_verdi.sh`: Script to launch Verdi with the simulation results.

- `run.f`: File list for VCS compilation.

- `run.sh`: Script to compile and run the simulation using VCS.

- `Makefile`: Makefile for compiling and simulating the design and UVM environment.

<!-- - `uvm_env/`: Contains UVM environment files including agents, drivers, monitors, and sequences. -->
<!-- - `scripts/`: Simulation and compilation scripts. -->
<!-- - `docs/`: Documentation related to the verification environment. -->


## Getting Started
1. Clone this repository:
   ```bash
   git clone https://github.com/yhs1202/UVM-Practice.git
    cd UVM-Practice
    ```

2. Run Overall simulation and View waveforms in Verdi:
    ```bash
    make
    ```

3. or Run VCS build + simulation:
    ```bash
    make run
    ```

4. View waveforms in Verdi:
    ```bash
    make verdi
    ```

5. Clean up generated files:
    ```bash
    make clean
    ```

---

</details>


# UVM Study Log

This section contains a detailed study log of UVM concepts, architecture, and advanced topics. It serves as a reference for understanding UVM methodology and its application in verification environments.

# 0. Table of Contents
[**Part 1. UVM Introduction & Principle**](#part-1-uvm-introduction--principle)

- What is UVM?
- Why UVM is needed?
- Limitations of previous methodologies

[**Part 2. UVM Architecture & Hierarchy**](#part-2-uvm-architecture--hierarchy)

- UVM Class Hierarchy
- UVM Testbench Hierarchy

[**Part 3. Basic Mechanism**](#part-3-basic-mechanism)

- Factory
- Phasing
- Configuration Database (uvm_config_db)

[**Part 4. Sequence-based stimulus**](#part-4-sequence-based-stimulus)

- Sequence Item (Transaction)
- Lifetime of Sequence (Body, Pre/Post Start)
- Handshake between Sequencer and Driver (get_next_item, item_done)
- Virtual Sequence & Virtual Sequencer

[**Part 5. TLM (Transaction-Level Modeling)**](#part-5-tlm-transaction-level-modeling)

- Port, Export, Imp, Socket
- Blocking vs Non-blocking Communication
- Analysis Port and Observer Pattern

[**Part 6. RAL (Register Abstraction Layer)**](#part-6-ral-register-abstraction-layer)

- Necessity and Structure of RAL Model (Reg Block, Reg Map, Field)
- Frontdoor vs Backdoor Access
- Implicit Prediction vs Explicit Prediction


[**Part 7. Advanced Topics**](#part-8-advanced-topics)


# Part 1. UVM Introduction & Principle

# Part 2. UVM Architecture & Hierarchy

# Part 3. Basic Mechanism

# Part 4. Sequence-based stimulus

# Part 5. TLM (Transaction-Level Modeling)

# Part 6. RAL (Register Abstraction Layer)

# Part 7. Advanced Topics

# Reference


VLSI Verify UVM: https://vlsiverify.com/uvm/

Chipverify UVM: https://www.chipverify.com/uvm/

Verification Guide UVM: https://verificationguide.com/uvm/uvm-tutorial/

Siemens Verification Academy UVM Cookbook: https://verificationacademy.com/topics/uvm-universal-verification-methodology/

UVM IEEE 1800.2 Reference Implementation: https://github.com/accellera-official/uvm-core

UVM 1.2 Reference Implementation: https://github.com/gchinna/uvm-1.2
