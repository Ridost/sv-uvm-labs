interface adder_if #(parameter WIDTH=8);
  logic [WIDTH-1:0] a,b;
  logic [WIDTH-1:0] sum;
  logic carry;
  
  modport drv_mp(output a,b, input sum,carry);
  modport mon_mp (input a,b, sum, carry);
endinterface

typedef virtual adder_if#(8).drv_mp adder_if_drv_vif_t;
typedef virtual adder_if#(8).mon_mp adder_if_mon_vif_t;
