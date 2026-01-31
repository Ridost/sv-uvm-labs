module fifo_sync
  #(parameter FIFO_DEPTH = 8,
    parameter DATA_WIDTH = 8)
  (input clk,
   input rst_n,
   input wr_en,
   input rd_en,
   input [DATA_WIDTH-1:0] data_in,
   output reg [DATA_WIDTH-1:0] data_out,
   output empty,
   output full);
  
  localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);
  
  reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
  
  reg[FIFO_DEPTH_LOG:0] wr_ptr;
  reg[FIFO_DEPTH_LOG:0] rd_ptr;
  
  // write
  always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
    	wr_ptr <= 0;
    else if (wr_en && !full) begin
      fifo[wr_ptr[FIFO_DEPTH_LOG-1:0]] <= data_in;
      wr_ptr <= wr_ptr + 1'b1;
    end
  end
  
  // read
  always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      rd_ptr <= 0;
      data_out <= 0;
    end
    else if(rd_en && !empty)begin
      data_out <= fifo[rd_ptr[FIFO_DEPTH_LOG-1:0]];
      rd_ptr <= rd_ptr + 1'b1;
    end
  end
  
  assign empty = (wr_ptr == rd_ptr);
  assign full  = (wr_ptr == {~rd_ptr[FIFO_DEPTH_LOG],rd_ptr[FIFO_DEPTH_LOG-1:0]});
  
endmodule
