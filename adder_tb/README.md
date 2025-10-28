# Adder UVM Verification Project

## Overview
This project implements a simple parameterized adder design and a complete UVM verification environment for it.  
The goal is to provide a compact yet full SystemVerilog + UVM example that demonstrates how to connect a DUT through an interface, drive transactions, monitor outputs, and verify results using a scoreboard.

This project serves as a foundational exercise for learning UVM structure and can be extended later to verify more complex designs such as dividers, FSMs, or UARTs.

---

## Design Description
### DUT: Parameterized Adder
The DUT performs addition between two N-bit inputs and outputs the sum and carry.

**Module:**
```systemverilog
module adder #(parameter WIDTH = 8)(
  adder_if adderif
);
  assign {adderif.carry, adderif.sum} = adderif.a + adderif.b;
endmodule
````

### Interface

The interface defines input and output signals of the adder and includes modports for driver and monitor access.

```systemverilog
interface adder_if #(parameter WIDTH = 8);
  logic [WIDTH-1:0] a, b, sum;
  logic carry;
  modport drv_mp (output a, b, input sum, carry);
  modport mon_mp (input a, b, sum, carry);
endinterface
```

---

## UVM Environment Structure

The testbench follows the standard UVM hierarchy.
Each class and component has a clear, single purpose.

```
top.sv
  ├── adder_test
      └── adder_env
          ├── adder_agent
          │    ├── adder_driver
          │    ├── adder_monitor
          │    └── adder_sequencer
          └── adder_scoreboard
```

### Sequence Item

Represents one adder operation with random input values.

```systemverilog
class adder_seq_item extends uvm_sequence_item;
  rand bit [7:0] a, b;
       bit [7:0] sum;
       bit carry;
endclass
```

### Sequence

Generates multiple randomized sequence items to test the DUT.

```systemverilog
class adder_sequence extends uvm_sequence #(adder_seq_item);
  task body();
    repeat(5) begin
      adder_seq_item item = adder_seq_item::type_id::create("item");
      assert(item.randomize());
      start_item(item);
      finish_item(item);
    end
  endtask
endclass
```

### Driver

Drives randomized inputs into the DUT through the virtual interface.

```systemverilog
vif.a = tr.a;
vif.b = tr.b;
#1;
tr.sum = vif.sum;
tr.carry = vif.carry;
```

### Monitor

Passively observes signal activity and sends sampled transactions to the scoreboard for checking.

### Scoreboard

Computes expected results and compares them with DUT outputs.

```systemverilog
bit [8:0] expected = tr.a + tr.b;
if ({tr.carry, tr.sum} !== expected)
  `uvm_error("SCOREBOARD", "Mismatch detected")
else
  `uvm_info("SCOREBOARD", "PASS", UVM_LOW)
```

---

## Testbench Operation Flow

1. **Sequence Generation** – Creates random input combinations (a, b).
2. **Driver** – Applies inputs to the DUT.
3. **DUT Execution** – Adder computes sum and carry.
4. **Monitor** – Captures DUT output.
5. **Scoreboard** – Compares actual vs expected results.
6. **UVM Report** – Prints summary of all test transactions.

---

## Expected Simulation Output

Example Riviera or Questa console log:

```
UVM_INFO [DRIVER] a=188 b=151 sum=83 carry=1
UVM_INFO [SCOREBOARD] PASS: a=188 b=151 sum=83 carry=1
UVM_INFO [DRIVER] a=129 b=135 sum=8 carry=1
UVM_INFO [SCOREBOARD] PASS: a=129 b=135 sum=8 carry=1
UVM_INFO [UVM/REPORT/SUMMARY] Simulation complete
```

---

## File Organization

```
rtl/
  adder/
    adder.sv
    adder_if.sv

tb/
  adder_tb/
    adder_seq_item.sv
    adder_sequence.sv
    adder_driver.sv
    adder_monitor.sv
    adder_scoreboard.sv
    adder_agent.sv
    adder_env.sv
    adder_test.sv
    top.sv

sim/
  Makefile
  run_adder.do
```

---

## How to Run

### Using Makefile

```bash
cd sim
make adder
```

### Using Riviera-PRO

```tcl
vlib work
vlog ../rtl/adder/*.sv ../tb/adder_tb/*.sv +incdir+../tb/common
vsim -c top -do "run -all; quit"
```
