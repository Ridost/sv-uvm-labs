// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "clk_div_seq_item.sv"
`include "clk_div_sequence.sv"
`include "clk_div_monitor.sv"
`include "clk_div_driver.sv"
`include "clk_div_agent.sv"
`include "clk_div_scoreboard.sv"
`include "clk_div_env.sv"
`include "clk_div_test.sv"

module top;
  logic clk = 0;
  always #5 clk = ~clk;
  
  clk_div_if bus(clk);
  
  clk_div dut(.bus(bus));
  
  initial begin
  	int div_param = 4;
    if ($value$plusargs("DIV=%d", div_param))begin
    	bus.div_value = div_param;
    end
    $display("[TOP] Using DIV = %0d", div_param);
    
    uvm_config_db#(virtual clk_div_if)::set(null, "*","vif", bus);
    run_test("clk_div_test");
  end

endmodule
