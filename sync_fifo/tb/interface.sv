interface fifo_interface(input logic clk,rst_n);

  logic [7:0]data_in;
  logic [7:0]data_out;
  logic empty;
  logic full;
  logic rd_en;
  logic wr_en;
  logic [3:0]fifo_cnt;
  
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output data_in;
    output rd_en,wr_en;
    input full,empty;
    input data_out;
    input fifo_cnt;
  endclocking
  
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input data_in;
    input rd_en,wr_en;
    input full,empty;
    input data_out;
    input fifo_cnt;
  endclocking  
  
  modport DRIVER(clocking driver_cb,input clk,rst_n);
  modport MONITOR(clocking monitor_cb,input clk,rst_n);
  
endinterface
