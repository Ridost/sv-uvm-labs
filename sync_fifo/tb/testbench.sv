import uvm_pkg::*;
`include "uvm_macros.svh"

`include "sequence_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "interface.sv"
`include "monitor.sv"
`include "coverage.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"
`include "wr_test.sv"
`include "wr_rd_test.sv"
`include "wr_then_rd_test.sv"
`include "wr_rd_parll_test.sv"

module top;
  bit clk;
  bit rst_n;
  
  initial begin
  	clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
  	rst_n = 0;
    #2 rst_n = 1;
  end
  
  fifo_interface in(clk,rst_n);;
  
  fifo_sync dut(.data_in(in.data_in),
                .clk(in.clk),
                .rst_n(in.rst_n),
                .wr_en(in.wr_en),
                .rd_en(in.rd_en),
                .empty(in.empty),
                .full(in.full),
                .data_out(in.data_out)
               );
  initial begin
    uvm_config_db#(virtual fifo_interface)::set(null,"*","vif",in);
  end
  
  initial begin
    //1. random stimulus
    //run_test("fifo_test");
    
    //2. write only
    //run_test("fifo_wr_test");
    
    //3. back to back write & read
    //run_test("fifo_wr_rd_test");
    
    //4. write complete then read
    run_test("fifo_wr_then_rd_test");
    
    //5. write read parallel
    //run_test("fifo_wr_rd_parll_test");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
