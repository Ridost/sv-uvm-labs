class adder_sequence extends uvm_sequence #(adder_seq_item);
  `uvm_object_utils(adder_sequence)
  
  function new(string name="adder_sequence");
    super.new(name);
  endfunction
  
  task body();
    adder_seq_item item;
    repeat(5)begin
      item = adder_seq_item::type_id::create("item");
      assert(item.randomize());
      start_item(item);
      finish_item(item);
      #1;
    end
  endtask
endclass
