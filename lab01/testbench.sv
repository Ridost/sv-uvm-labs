// Code your testbench here
// or browse Examples
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "my_transaction.sv"
`include "my_sequence.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "master_agent.sv"
`include "my_env.sv"
`include "my_test.sv"

module top;
  	
  	
	initial $display("[TB] Hello, simulation starts");
  
  	initial begin
      run_test("my_test");
    end

endmodule
