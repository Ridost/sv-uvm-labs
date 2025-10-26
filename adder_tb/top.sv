`include "uvm_macros.svh"
import uvm_pkg::*;

`include "adder_seq_item.sv"
`include "adder_sequence.sv"
`include "adder_driver.sv"
`include "adder_monitor.sv"
`include "adder_scoreboard.sv"
`include "adder_agent.sv"
`include "adder_env.sv"
`include "adder_test.sv"

module top;
  adder_if adder_if1();
  adder dut (.adderif(adder_if1));
  
  initial begin
    uvm_config_db#(adder_if_drv_vif_t)::set(null, "*","vif",adder_if1);
    uvm_config_db#(adder_if_mon_vif_t)::set(null, "*","vif",adder_if1);
    run_test("adder_test");
  end
endmodule
