class clk_div_agent extends uvm_component;
  `uvm_component_utils(clk_div_agent)	
  
  clk_div_monitor mon;
  clk_div_driver drv;
  uvm_sequencer#(clk_div_seq_item) seqr;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    mon = clk_div_monitor::type_id::create("mon",this);
    drv = clk_div_driver::type_id::create("drv",this);
    seqr = uvm_sequencer#(clk_div_seq_item)::type_id::create("seqr",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
