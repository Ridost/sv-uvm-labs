class adder_driver extends uvm_driver #(adder_seq_item);
  adder_if_drv_vif_t vif;
  
  `uvm_component_utils(adder_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(adder_if_drv_vif_t)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "No Virtual Interface")
  endfunction
  
  task run_phase(uvm_phase phase);
    adder_seq_item tr;
    //phase.raise_objection(this);
    forever begin
      seq_item_port.get_next_item(tr);
      vif.a = tr.a;
      vif.b = tr.b;
      #1;
      tr.sum   = vif.sum;
      tr.carry = vif.carry;
      `uvm_info("DRIVER", tr.convert2string(), UVM_LOW)
      seq_item_port.item_done();
    end
    //phase.drop_objection(this);
  endtask
endclass
