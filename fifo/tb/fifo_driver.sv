class fifo_driver extends uvm_driver#(fifo_seq_item);
  fifo_if_drv_vif_t vif;

  `uvm_component_utils(fifo_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(fifo_if_drv_vif_t)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Missing virtual interface for fifo_driver")
  endfunction

  task run_phase(uvm_phase phase);
    fifo_seq_item tr;
    forever begin
      seq_item_port.get_next_item(tr);
      vif.wr_en = tr.wr_en;
      vif.rd_en = tr.rd_en;
      vif.din   = tr.din;
      @(posedge vif.clk);
      #1;
      vif.wr_en = 0;
      vif.rd_en = 0;
      vif.din   = '0;
      seq_item_port.item_done();
    end
  endtask
endclass
