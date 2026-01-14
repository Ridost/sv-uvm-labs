`include "uvm_macros.svh"
import uvm_pkg::*;

`include "fifo_if.sv"
`include "fifo_seq_item.sv"
`include "fifo_sequence.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_scoreboard.sv"
`include "fifo_agent.sv"
`include "fifo_env.sv"
`include "fifo_test.sv"

module test;
  logic clk = 0;
  always #5 clk = ~clk;

  fifo_if #(.DATA_WIDTH(8), .DEPTH(16)) vif();

  fifo #(.DATA_WIDTH(8), .DEPTH(16)) dut (
    .clk(clk),
    .rst_n(vif.rst_n),
    .wr_en(vif.wr_en),
    .rd_en(vif.rd_en),
    .din(vif.din),
    .dout(vif.dout),
    .full(vif.full),
    .empty(vif.empty)
  );

  initial begin
    vif.rst_n = 0;
    #15;
    vif.rst_n = 1;
  end

  initial begin
    uvm_config_db#(fifo_if_drv_vif_t)::set(null, "*", "vif", vif);
    uvm_config_db#(fifo_if_mon_vif_t)::set(null, "*", "vif", vif);
    run_test("fifo_test");
  end
endmodule
