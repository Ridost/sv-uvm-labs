class adder_agent extends uvm_component;
  adder_driver drv;
  adder_monitor mon;
  uvm_sequencer#(adder_seq_item) seqr;
	
  `uvm_component_utils(adder_agent)
  	
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    drv = adder_driver::type_id::create("drv",this);
    mon	= adder_monitor::type_id::create("mon",this);
    seqr = uvm_sequencer#(adder_seq_item)::type_id::create("seqr",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
