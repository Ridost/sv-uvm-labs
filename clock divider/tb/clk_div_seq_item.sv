class clk_div_seq_item extends uvm_sequence_item;
  time period;
  time high_time;
  time low_time;
  real duty;
  
  `uvm_object_utils(clk_div_seq_item)
  
  function new(string name="clk_div_seq_item");
    super.new(name);
  endfunction
endclass
