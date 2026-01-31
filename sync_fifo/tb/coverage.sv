class fifo_coverage extends uvm_subscriber#(fifo_seq_item);
  `uvm_component_utils(fifo_coverage)
  
  
  covergroup cg with function sample (bit wr_en, bit rd_en);
    cp_write : coverpoint wr_en { bins write = {1};}
    cp_read  : coverpoint rd_en { bins read  = {1};}
    write_and_read: cross cp_write,cp_read;
  endgroup
  
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    cg = new();
  endfunction
  
 
  function void write(fifo_seq_item t);
    cg.sample(t.wr_en,t.rd_en);
  endfunction
  
  function void check_phase(uvm_phase phase);
    $display("---------------------------------------");
    `uvm_info("COVERAGE", $sformatf("Functional Coverage = %0.2f%%\%",cg.get_coverage()),UVM_MEDIUM)
    $display("---------------------------------------");
  endfunction
endclass
