class fifo_sequence extends uvm_sequence#(fifo_seq_item);
  `uvm_object_utils(fifo_sequence)

  function new(string name="fifo_sequence");
    super.new(name);
  endfunction

  task body();
    fifo_seq_item tr;
    repeat(40) begin
      tr = fifo_seq_item::type_id::create("tr");
      assert(tr.randomize());
      start_item(tr);
      finish_item(tr);
      #5;
    end
  endtask
endclass
