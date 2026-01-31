class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  
  uvm_analysis_imp #(fifo_seq_item,fifo_scoreboard) scb_port;
  
  
  logic [7:0] mem [$];
  logic full = 0;
  logic empty = 1;
  logic [7:0] data_out;
  logic read_data = 0;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb_port = new ("scv_port",this);
  endfunction
  
  function void write(fifo_seq_item transaction);
    if(mem.size==8 && !read_data) begin
        full = 1;
        if(transaction.full)
        	`uvm_info("SCOREBOARD",$sformatf("======DATA FULL========  : dut.full=%0d",transaction.full),UVM_MEDIUM)
      	else
          `uvm_info("SCOREBOARD", "=======DATA FULL MISMATCH=========",UVM_MEDIUM)
      end
      else full = 0;
    if(read_data) begin
      data_out  = mem.pop_front();
      if(mem.size==0) empty = 1;
      else empty = 0;
      read_data = 0; 
      if(transaction.data_out == data_out)
        `uvm_info("SCOREBOARD","=======================SUCCESS====================",UVM_MEDIUM)
      else
        `uvm_info("SCOREBOARD","=======================FAILED=====================",UVM_MEDIUM)
      `uvm_info("SCOREBOARD", $sformatf("EXPECTED (data_out=%0d,empty=%0d,full=%0d)",data_out,empty,full),UVM_MEDIUM)
    `uvm_info("SCOREBOARD", $sformatf("REAL     (data_out=%0d,empty=%0d,full=%0d)",transaction.data_out,transaction.empty,transaction.full),UVM_MEDIUM)
      
    end
    
    if(!transaction.full && transaction.wr_en)begin
      mem.push_back(transaction.data_in);
      //`uvm_info("SCOREBOARD", "WRITE DATA", UVM_MEDIUM)
    end
    if(!transaction.empty && transaction.rd_en)begin
      	//`uvm_info("SCOREBOARD", "READ DATA",UVM_MEDIUM)
      	read_data = 1;
    end
    
    
    
  endfunction
endclass
