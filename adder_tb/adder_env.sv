class adder_env extends uvm_env;
	adder_agent agt;
  	adder_scoreboard sb;
  
  `uvm_component_utils(adder_env)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);  
  endfunction
  
  function void build_phase(uvm_phase phase);
    agt = adder_agent::type_id::create("agt",this);
    sb	= adder_scoreboard::type_id::create("sb",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agt.mon.analysis_port.connect(sb.analysis_export);
  endfunction
endclass
