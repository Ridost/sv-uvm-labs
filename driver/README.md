# Clock Divider UVM Verification Project

This project is part of the SystemVerilog + UVM practice series.  
It verifies a parameterized clock divider (clk_div) module that divides an input clock by a configurable factor (DIV).  
The goal of this lab is to practice verifying sequential logic, timing relationships, and reset behavior using the UVM methodology.

---

## Overview

The DUT (Device Under Test) is a simple clock divider that generates an output clock with a frequency equal to the input clock divided by DIV.  
The output clock maintains approximately a 50 percent duty cycle.  

The verification environment is built using the UVM framework.  
It focuses on testing reset behavior, output clock frequency, and duty cycle correctness for different division factors.

---

## Design Description

### Module: clk_div

**Parameters**
- DIV : Integer division ratio (default 4)

**Ports**
- clk_in  : Input clock
- rst_n   : Asynchronous active low reset
- clk_out : Output divided clock

**Functionality**
- The internal counter counts from 0 to DIV-1.
- The output clock toggles based on the counter value.
- After reset, the counter and output return to 0.

---

## Verification Objectives

1. Verify reset behavior.
   - After reset, clk_out should be low and counter should reset to zero.

2. Verify frequency division.
   - The output clock period should be DIV times longer than the input clock period.

3. Verify duty cycle.
   - The high and low phases of clk_out should each occupy roughly half of the total period.

4. Parameter coverage.
   - Test multiple DIV values (2, 4, 8, 10).

5. Functional coverage.
   - Ensure all major operating conditions and transitions are exercised.

---

## UVM Environment Structure

```

clk_div_env
├── clk_div_agent
│    ├── clk_div_driver
│    ├── clk_div_monitor
│    └── clk_div_sequencer
├── clk_div_scoreboard
└── clk_div_sequence

```

### 1. clk_div_if
A simple interface that connects the DUT to the UVM environment.
It includes the input clock, reset, and divided output.

### 2. clk_div_seq_item
Defines one transaction, which contains a random division factor.

### 3. clk_div_sequence
Generates a sequence of random transactions for testing multiple DIV values.

### 4. clk_div_driver
Drives the DUT reset signal and coordinates test sequence execution.

### 5. clk_div_monitor
Passively observes the output clock, measures the period, and reports timing information.

### 6. clk_div_scoreboard
Receives data from the monitor, performs basic frequency and division checks, and reports pass or fail.

### 7. clk_div_env
Top-level environment that connects agent and scoreboard.

### 8. clk_div_test
Defines the main UVM test configuration and launches the environment.

### 9. top.sv
Top-level testbench module that instantiates the DUT, interface, and starts the UVM simulation.

---

## Simulation Flow

1. The clock is generated in the top-level testbench.
2. The interface is connected to the DUT and passed to the UVM environment.
3. The driver asserts and releases reset.
4. The sequence generates random DIV values.
5. The monitor captures output clock transitions and measures periods.
6. The scoreboard compares observed and expected timing relationships.
7. The test completes after all sequences have finished.

---

## Key Verification Features

- Uses UVM configuration database to pass virtual interfaces.
- Uses randomized transactions for coverage.
- Checks clock period correctness using monitor timing measurements.
- Reports results using UVM reporting macros.
- Designed for reuse and scalability across multiple sequential DUTs.

---

## Example Output

```

UVM_INFO @ 0: [RNTST] Running test clk_div_test
UVM_INFO @ 10ns: [MON] clk_out period = 20 ns
UVM_INFO @ 30ns: [SCOREBOARD] PASS: DIV test 4 OK
UVM_INFO @ 100ns: [UVM/REPORT/SUMMARY] Simulation complete

```

---

## Directory Structure

```

rtl/
└── divider/
├── clk_div.sv
└── clk_div_if.sv

tb/
└── divider_tb/
├── clk_div_seq_item.sv
├── clk_div_sequence.sv
├── clk_div_driver.sv
├── clk_div_monitor.sv
├── clk_div_scoreboard.sv
├── clk_div_env.sv
├── clk_div_test.sv
└── top_clk_div.sv
