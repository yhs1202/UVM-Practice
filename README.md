# UVM-Practice

This repository contains a UVM-1.2 based verification environment for practicing and learning UVM concepts using Synopsys VCS and Verdi tools.

# Project Setup & Makefile

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