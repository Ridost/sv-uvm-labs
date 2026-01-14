class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  fifo_agent agt;
  fifo_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    agt = fifo_agent::type_id::create("agt", this);
    sb  = fifo_scoreboard::type_id::create("sb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agt.mon.analysis_port.connect(sb.analysis_export);
  endfunction
endclass
