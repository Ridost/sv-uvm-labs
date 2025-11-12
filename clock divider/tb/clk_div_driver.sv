class clk_div_driver extends uvm_driver #(clk_div_seq_item);
  virtual clk_div_if vif;
  
  `uvm_component_utils(clk_div_driver)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual clk_div_if)::get(this,"","vif",vif))
      begin
      `uvm_fatal("NOVIF", "Virtual interface not found")
      end
  endfunction
   
  task run_phase(uvm_phase phase);
    clk_div_seq_item tr;
    
  	vif.rst_n = 0;
    repeat(2) @(posedge vif.clk);
    vif.rst_n = 1;
    
    `uvm_info("DRV", "Reset deasserted", UVM_LOW)
    
    forever begin
      seq_item_port.get_next_item(tr);
      
      @(posedge vif.clk);
      `uvm_info("DRV", "Transacion applied", UVM_LOW)
      
      seq_item_port.item_done();
    	
    end
    
  endtask
endclass
      
      

      
