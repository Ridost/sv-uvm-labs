module fifo #(parameter DATA_WIDTH=8, parameter DEPTH=16)
(
    input logic clk,
    input logic rst_n,
    input logic wr_en,
    input logic rd_en,
    input logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout,
    output logic full,
    output logic empty
);
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;
    logic [$clog2(DEPTH):0] count;
    logic do_wr,do_rd;

    assign do_wr = wr_en && !full;
    assign do_rd = rd_en && !empty;

    always_ff @(posedge clk)begin
        if(!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
            count <= '0;
            dout <= '0;
        end
        else begin
            if(do_wr) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
            end
            if(do_rd) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end
            case ({do_wr, do_rd}) 
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                default: /* no change */ ;
            endcase
        end
    end
    assign full = (count == DEPTH);
    assign empty = (count == 0);

endmodule