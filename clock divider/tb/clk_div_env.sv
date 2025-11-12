class clk_div_env extends uvm_env;
  `uvm_component_utils(clk_div_env)
  
  clk_div_agent agt;
  clk_div_scoreboard sb;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    agt = clk_div_agent::type_id::create("agt",this);
    sb = clk_div_scoreboard::type_id::create("sb",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agt.mon.analysis_port.connect(sb.analysis_export);
  endfunction
  
endclass
