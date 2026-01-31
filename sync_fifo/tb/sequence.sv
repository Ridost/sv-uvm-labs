class fifo_sequence extends uvm_sequence#(fifo_seq_item);
  `uvm_object_utils(fifo_sequence)
  
  function new(string name="fifo_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(150)begin
      req = fifo_seq_item::type_id::create("req");
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
      
      set_response_queue_depth(150);
    end
  endtask
endclass

class fifo_write_sequence extends uvm_sequence#(fifo_seq_item);
  `uvm_object_utils(fifo_write_sequence)
  
  fifo_seq_item item;
  
  function new(string name="fifo_write_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    $display("Starting UVM Seq Body...");
    repeat(8)begin
      item = fifo_seq_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with {item.wr_en==1;item.rd_en==0;});
      finish_item(item);
      
      //set_response_queue_depth(15);;
    end
  endtask
endclass


class fifo_read_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_read_sequence)
   
  function new(string name = "fifo_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(8) begin
      `uvm_do_with(req,{req.rd_en==1;req.wr_en==0;})
      //set_response_queue_depth(25) ;

    end
  endtask
  
endclass


class fifo_wr_then_rd_sequence extends uvm_sequence#(fifo_seq_item);;
  fifo_write_sequence wr_seq;
  fifo_read_sequence  rd_seq;
  
  `uvm_object_utils(fifo_wr_then_rd_sequence)
   
  function new(string name = "fifo_wr_then_rd_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do(wr_seq)
    `uvm_do(rd_seq)
  endtask
  
endclass

class fifo_write_read_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_write_read_sequence)
   
  function new(string name = "fifo_write_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(10) begin
    ///req = fifo_seq_item::type_id::create("req");
      `uvm_do_with(req,{req.wr_en==1;req.rd_en==0;})
      `uvm_do_with(req,{req.wr_en==0;req.rd_en==1;})
     
      set_response_queue_error_report_disabled(1); 

      //set_response_queue_depth(10) ;

    end
  endtask
endclass



class fifo_wr_rd_parallel_seq extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_wr_rd_parallel_seq)
  fifo_write_sequence wr_seq;
  fifo_read_sequence  rd_seq;
  
  function new(string name = "fifo_wr_rd_parallel_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr_en==1;req.rd_en==0;});
      finish_item(req);
      
      repeat(8) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr_en==1;req.rd_en==1;});
      finish_item(req);
      set_response_queue_depth(15) ;

      // `uvm_do_with(req,{req.wr==1;req.rd==1;})
     end
  endtask
endclass
    
