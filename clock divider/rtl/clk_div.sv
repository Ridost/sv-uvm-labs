interface clk_div_if(input logic clk);
  logic rst_n;
  logic clk_out;
  logic [31:0] div_value;
endinterface

module clk_div(clk_div_if bus);
  logic [31:0] cnt;
  
  always_ff @(posedge bus.clk or negedge bus.rst_n) begin
    if(!bus.rst_n)
      cnt <= '0;
    else if (cnt == bus.div_value-1)
      cnt <= '0;
    else
      cnt <= cnt + 1;
  end
  
  assign bus.clk_out = (cnt < bus.div_value/2);
endmodule
