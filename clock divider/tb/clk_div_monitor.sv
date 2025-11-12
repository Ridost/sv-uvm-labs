class clk_div_monitor extends uvm_component;
	virtual clk_div_if vif;
  	
  	uvm_analysis_port#(clk_div_seq_item) analysis_port;
  
 	`uvm_component_utils(clk_div_monitor)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    analysis_port = new("analysis_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual clk_div_if)::get(this,"","vif",vif))
      begin
      `uvm_fatal("NOVIF", "Virtual interface not found")
      end
  endfunction
      
  task run_phase(uvm_phase phase);
    clk_div_seq_item tr;
    time t_rise1 , t_fall, t_rise2;
    
    @(posedge vif.rst_n);
    forever begin
      @(posedge vif.clk_out);
      t_rise1 = $time;
      @(negedge vif.clk_out);
      t_fall = $time;
      @(posedge vif.clk_out);
      t_rise2 = $time;
      
      tr = clk_div_seq_item::type_id::create("tr");
      tr.period = t_rise2 - t_rise1;
      tr.high_time = t_fall - t_rise1;
      tr.low_time = t_rise2 - t_fall;
      tr.duty = real'(tr.high_time) / real'(tr.period);
    	
      `uvm_info = ("MON",$sformatf("period = %0t high=%0t low = %0t duty=%.2f",tr.period,tr.high_time,tr.low_time,tr.duty),UVM_LOW)
      
      analysis_port.write(tr);
    end
  endtask
endclass
