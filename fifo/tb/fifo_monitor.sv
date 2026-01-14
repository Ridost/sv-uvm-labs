class fifo_monitor_trans extends uvm_sequence_item;
  bit wr_en;
  bit rd_en;
  logic [7:0] din;
  logic [7:0] dout;
  bit full;
  bit empty;
  bit rst_n;

  `uvm_object_utils(fifo_monitor_trans)

  function new(string name="fifo_monitor_trans");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("wr=%0b rd=%0b din=%0h dout=%0h full=%0b empty=%0b rst=%0b",
                     wr_en, rd_en, din, dout, full, empty, rst_n);
  endfunction
endclass

class fifo_monitor extends uvm_component;
  fifo_if_mon_vif_t vif;
  uvm_analysis_port#(fifo_monitor_trans) analysis_port;

  `uvm_component_utils(fifo_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(fifo_if_mon_vif_t)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Missing virtual interface for fifo_monitor")
  endfunction

  task run_phase(uvm_phase phase);
    fifo_monitor_trans tr;
    forever begin
      @(posedge vif.clk);
      tr = fifo_monitor_trans::type_id::create("tr");
      tr.wr_en = vif.wr_en;
      tr.rd_en = vif.rd_en;
      tr.din   = vif.din;
      tr.dout  = vif.dout;
      tr.full  = vif.full;
      tr.empty = vif.empty;
      tr.rst_n = vif.rst_n;
      analysis_port.write(tr);
    end
  endtask
endclass
