class clk_div_scoreboard extends uvm_component;
  `uvm_component_utils(clk_div_scoreboard)
  uvm_analysis_imp#(clk_div_seq_item,clk_div_scoreboard) analysis_export;
  int div_param;
  
  time base_clk_period = 10ns;
  function new(string name,uvm_component parent);
    super.new(name,parent);
    analysis_export = new("analysis_export",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!$value$plusargs("DIV=%", div_param)) begin
      div_param = 4;
    end
  endfunction
  
  function automatic int abs(input int x);
    return (x<0) ? -x : x;
  endfunction
  
  function void write(clk_div_seq_item tr);
    time expected_period = base_clk_period * div_param;
    real freq_error = abs(real'(tr.period - expected_period)) / real'(expected_period);
    real duty_error = abs(tr.duty - 0.5);
    
    if(freq_error < 0.05)begin
      `uvm_info("SCOREBOARD",
          $sformatf("PASS: div=%0d period=%0t (expected=%0t)", div_param, tr.period, expected_period),
          UVM_LOW)
    end 
    else begin
      `uvm_error("SCOREBOARD",
        $sformatf("FAIL: div=%0d wrong period=%0t expected=%0t",
                  div_param, tr.period, expected_period))
    end
    if (duty_error < 0.05) begin
      `uvm_info("SCOREBOARD",
        $sformatf("Duty OK: %.2f (near 50%%)", tr.duty),
        UVM_LOW)
    end
    else begin
      `uvm_warning("SCOREBOARD",$sformatf("Duty mismatch: %.2f (expected ≈ 0.5)", tr.duty))
    end
  endfunction
endclass
