class fifo_agent extends uvm_agent;
  fifo_sequencer seqr;
  fifo_driver driv;
  fifo_monitor mon;
  fifo_coverage cov;
  
  `uvm_component_utils_begin(fifo_agent)
  `uvm_field_object(seqr,UVM_ALL_ON)
  `uvm_field_object(driv,UVM_ALL_ON)
  `uvm_field_object(mon,UVM_ALL_ON)
  `uvm_field_object(cov,UVM_ALL_ON)
  `uvm_component_utils_end
  
  function new(string name="fifo_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  // why here is using virtual funtion ??
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    seqr = fifo_sequencer::type_id::create("seqr",this);
    driv = fifo_driver::type_id::create("driv",this);
    mon  = fifo_monitor::type_id::create("mon",this);
    cov  = fifo_coverage::type_id::create("cov",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    driv.seq_item_port.connect(seqr.seq_item_export);
    mon.ap.connect(cov.analysis_export);
    uvm_report_info("FIFO_AGENT", "connect_phase, Connected driver to sequencer");
  endfunction
endclass
