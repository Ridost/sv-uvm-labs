interface fifo_if #(parameter DATA_WIDTH=8, parameter DEPTH=16) (input logic clk);
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [DATA_WIDTH-1:0] din;
    logic [DATA_WIDTH-1:0] dout;
    logic full;
    logic empty;

    

    modport DRV( input clk,
                 output rst_n,
                 input full,
                 input empty,
                 input dout,
                 output wr_en,
                 output rd_en,
                 output din);

    modport MON( input clk,
                 input rst_n,
                 input wr_en,
                 input rd_en,
                 input din,
                 input dout,
                 input full,
                 input empty);
endinterface

typedef virtual fifo_if#(.DATA_WIDTH(8), .DEPTH(16)).DRV fifo_if_drv_vif_t;
typedef virtual fifo_if#(.DATA_WIDTH(8), .DEPTH(16)).MON fifo_if_mon_vif_t;
