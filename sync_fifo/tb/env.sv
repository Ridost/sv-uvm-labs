class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)
  
  fifo_agent agt;
  fifo_scoreboard scb;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agt = fifo_agent::type_id::create("agt",this);
    scb = fifo_scoreboard::type_id::create("scb",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.ap.connect(scb.scb_port);
    
    uvm_report_info("FIFO_ENVIRONMENT","connect_phase, Connected monitor to scoreboard");
  endfunction
endclass
