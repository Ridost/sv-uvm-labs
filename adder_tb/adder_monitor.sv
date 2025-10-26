class adder_monitor extends uvm_component;
  adder_if_mon_vif_t vif;
  uvm_analysis_port#(adder_seq_item) analysis_port;
  
  `uvm_component_utils(adder_monitor)
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    analysis_port = new("analysis_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(adder_if_mon_vif_t)::get(this, "", "vif", vif))
      begin
       `uvm_fatal("NOVIF", "No virtual interface")
      end
  endfunction
  
  task run_phase(uvm_phase phase);
  	adder_seq_item tr;
    forever begin
      @(vif.a or vif.b);
      #0;
      tr = adder_seq_item::type_id::create("tr");
      tr.a = vif.a;
      tr.b = vif.b;
      tr.sum = vif.sum;
      tr.carry = vif.carry;
      
      analysis_port.write(tr);
    end
  endtask
endclass
