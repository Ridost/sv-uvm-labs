class adder_scoreboard extends uvm_component;
  uvm_analysis_imp#(adder_seq_item, adder_scoreboard) analysis_export;
  
  `uvm_component_utils(adder_scoreboard)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    analysis_export = new("analysis_export",this);
  endfunction
  
  function void write(adder_seq_item tr);
    bit[8:0] expected = tr.a + tr.b;
    if( {tr.carry,tr.sum} != expected)
      `uvm_error("SCOREBOARD", $sformatf("Mismatch! %s expected=%0d", tr.convert2string(), expected))
	else
      `uvm_info("SCOREBOARD", $sformatf("PASS: %s", tr.convert2string()),UVM_LOW)
  endfunction
endclass
