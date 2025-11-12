class clk_div_sequence extends uvm_sequence #(clk_div_seq_item);
  `uvm_object_utils(clk_div_sequence)
  
  function new(string name="clk_div_sequence");
    super.new(name);
  endfunction
  
  task body();
    clk_div_seq_item item;
    
  	
    repeat(3)begin
      item = clk_div_seq_item::type_id::create("item");
      assert(item.randomize());
      start_item(item);
      finish_item(item);
      #1;
    end
  endtask
endclass
