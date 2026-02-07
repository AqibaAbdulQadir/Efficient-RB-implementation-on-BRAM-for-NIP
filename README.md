# Efficient Row Buffer Implementation on BRAM for Neighbourhood Image Processing

A BRAM18-optimized FPGA row buffer architecture for real-time K×K neighbourhood image processing, based on Kazmi et al.

## Background

Neighbourhood image processing (NIP) operations such as convolution, filtering, and edge detection require fast access to pixel windows.

This repository implements the efficient and compact row buffer architecture proposed in:

M. Kazmi et al.,  
*"An Efficient and Compact Row Buffer Architecture on FPGA for Real-Time Neighbourhood Image Processing"*.

The design minimizes BRAM usage and supports real-time streaming window generation.

## Features

- Optimized row-buffer architecture mapped to **Xilinx BRAM18**
- Supports parameterized kernel sizes (**K×K window**)
- Real-time pixel streaming with neighbourhood extraction
- Modular Verilog design (address generation, control FSM, memory steering)
- Simulation-ready testbenches included
- An IP(component.xml file) to easily integrate the NIP pipeline to your design

## Key Features

- Parameterized image width and pixel depth
- Efficient BRAM utilization
- Supports sliding window (NxN) neighborhood operations
- Fully synchronous design
- Suitable for real-time image streaming
- Scalable for different FPGA devices

## Architecture Overview

The system buffers incoming pixel streams into BRAM-based row memories.
A steering + mux network extracts a sliding K×K neighbourhood window.

Main modules:

- **memory_module.v** — BRAM row storage
- **address_generator_module.v** — generates pixel read/write addresses
- **control_module.v** — FSM controlling buffering and shifting
- **steer_module.v** — aligns rows for correct neighbourhood output
- **mux_rb_to_1.v** — selects output window pixels
- **top.v** — complete integration

### Block Diagram (from paper)

<img width="700" height="572" alt="Screenshot 2026-02-07 at 1 25 25 PM" src="https://github.com/user-attachments/assets/9a592949-53c8-4b12-a816-9d6208de55db" />

## Directory Structure
    .
    ├── src/                              # Core Verilog modules
    │   ├── top.v                         # Top-level integration module
    │   ├── memory_module.v               # BRAM-based row buffer storage
    │   ├── address_generator_module.v    # Address generation for row access
    │   ├── control_module.v              # Control FSM for buffer operation
    │   ├── steer_module.v                # Data steering for sliding window output
    │   ├── mux_rb_to_1.v                 # Multiplexer for row buffer selection
    │   ├── BRAM18.v                      # BRAM18 primitive wrapper
    │   └── par.vh                        # Global parameters and constants
    │
    ├── sim/                              # Testbenches and simulation files
    │   ├── tb_top.v                      # End-to-end top-level simulation
    │   ├── tb_memory_module.v            # Memory module verification
    │   ├── tb_control_module.v           # Control logic verification
    │   ├── tb_address_generator_module.v # Address generator testbench
    │   └── data/                         # Input test data for simulation
    │
    ├── scripts/                          # Automation scripts
    │   └── create_project.tcl            # Vivado project generation script
    │
    ├── ip/                               # Generated Vivado IP metadata
    │   └── component.xml
    │
    └── FSM Practice/                     # Additional FSM learning experiments
        ├── fsm.v
        ├── tb_fsm.v
        └── fsm.vcd

## Module Overview

- **top.v**  
  Integrates all submodules to form the complete compact row buffer system.

- **memory_module.v**  
  Implements the BRAM-based row buffer storage architecture.

- **address_generator_module.v**  
  Generates read/write addresses for streaming pixel rows for both external memory and BRAM18.

- **control_module.v**  
  FSM-based controller coordinating buffer filling and sliding window access.

- **steer_module.v**  
  Routes buffered pixel data into the neighborhood window output.

- **mux_rb_to_1.v**  
  Selects the appropriate row buffer output for processing.

- **BRAM18.v**  
  Wrapper around FPGA BRAM18 primitives for synthesis compatibility.

- **par.vh**  
  Contains design parameters.

## Parameterization

The design supports configurable kernel sizes through parameter **K**:

- K = 3 → 3×3 neighbourhood
- K = 5 → 5×5 neighbourhood
- K = 7 → 7×7 neighbourhood

The K parameter is defined in `par.vh`

Example:

```verilog
parameter K = 3;
```
## 📊 Synthesized Resource Utilization

The design was synthesized for Xilinx FPGA targets using **BRAM18-based row buffering**.
Resource usage was evaluated for different neighbourhood kernel sizes (K×K) while keeping the image resolution fixed at **512×512**.

The table below summarizes the overall FPGA cost as well as module-level breakdown:

- **AGM** → Address Generator Module  
- **CM** → Control Module (FSM-based controller)  
- **MM** → Memory Module (BRAM row storage)

### Synthsised Resource Usage Summary 

| K  | Image Size | Total  LUTs | Total Registers | BRAM Tile | AGM LUTs | AGM Registers | CM LUTs | CM Registers | MM LUTs | MM Registers | Link to Implemented Design |
|----|------------|-------------|-----------------|-----------|----------|---------------|---------|--------------|---------|--------------|----------------------------|
| 3  | 512x512    | 66          | 108             | 0.5       | 18       | 64            | 40      | 44           | 8       | 0            | [K3.png](https://drive.google.com/file/d/1Kj9d8otaZMKMnm3RmMU3RqQlY5Il_ohi/view?usp=sharing)|
| 5  | 512x512    | 112         | 112             | 0.5       | 17       | 65            | 95      | 47           | 0       | 0            | [K5.png](https://drive.google.com/file/d/1iX-77vIOifpTDS9aLwrtBs7B4tHQqfWZ/view?usp=sharing)|                     
| 7  | 512x512    | 122         | 117             | 1         | 22       | 68            | 28      | 49           | 72      | 0            | [K7.png](https://drive.google.com/file/d/1Br3uSLzbkSy5tHs9HVPFvMuttKHiHF5S/view?usp=sharing)|                     
| 9  | 512x512    | 149         | 117             | 1         | 22       | 68            | 31      | 49           | 96      | 0            | [K9.png](https://drive.google.com/file/d/1IqofxiruxiDyAFwkYuPIzHUVgxhVNgVH/view?usp=sharing)|                     
| 11 | 512x512    | 290         | 121             | 1.5       | 24       | 70            | 186     | 51           | 80      | 0            | [K11.png](https://drive.google.com/file/d/1m76lzf3VZGnNs1l3TAkxABJXJUXj3E2Q/view?usp=sharing)|                    
| 13 | 512x512    | 281         | 121             | 1.5       | 32       | 70            | 153     | 51           | 96      | 0            | [K13.png](https://drive.google.com/file/d/1gC75xswcHoYzuk8cH44AwGwe0eZcZ27D/view?usp=sharing)|                   
| 15 | 512x512    | 462         | 121             | 2         | 32       | 70            | 38      | 51           | 392     | 0            | [K15.png](https://drive.google.com/file/d/1Jute2F6q1cOak5_uGT1iZR6QXurslVCb/view?usp=sharing)|                    
| 17 | 512x512    | 409         | 121             | 2         | 31       | 70            | 250     | 51           | 128     | 0            | [K17.png](https://drive.google.com/file/d/1Kif4K8ycKqXJf-QGogoEiQ-2VsPW_D_r/view?usp=sharing)|                    


### Observations

- BRAM usage increases gradually with larger kernel sizes due to additional row storage requirements.
- The control module (CM) dominates LUT usage for mid-range kernels (e.g., K=11, K=17).
- The architecture remains compact even for larger neighbourhood windows, demonstrating the efficiency of the proposed design.

## Current Limitation
The design currently supports only **512×512 images**. Future work includes generalizing address generation for arbitrary image sizes.

## Citation

If you use this implementation in research, please cite:

Kazmi, M., et al.,  
"An Efficient and Compact Row Buffer Architecture on FPGA for Real-Time Neighbourhood Image Processing"
