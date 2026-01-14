class fifo_seq_item extends uvm_sequence_item;
  rand bit wr_en;
  rand bit rd_en;
  rand logic [7:0] din;
  
  `uvm_object_utils(fifo_seq_item)

  constraint single_op {
    wr_en + rd_en <= 1;
  }

  function new(string name="fifo_seq_item");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("wr=%0b rd=%0b din=%0h", wr_en, rd_en, din);
  endfunction
endclass
