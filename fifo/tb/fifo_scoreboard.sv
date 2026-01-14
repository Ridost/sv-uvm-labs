class fifo_scoreboard extends uvm_component;
  `uvm_component_utils(fifo_scoreboard)

  localparam int DATA_WIDTH = 8;
  localparam int DEPTH = 16;

  uvm_analysis_imp#(fifo_monitor_trans, fifo_scoreboard) analysis_export;

  logic [DATA_WIDTH-1:0] model_data[$];
  int unsigned model_count;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
    model_count = 0;
  endfunction

  function void write(fifo_monitor_trans tr);
    bit expected_full;
    bit expected_empty;

    if (!tr.rst_n) begin
      model_data.delete();
      model_count = 0;
      return;
    end

    bit do_wr;
    bit do_rd;

    do_wr = tr.wr_en && (model_count < DEPTH);
    do_rd = tr.rd_en && (model_count > 0);

    if (do_wr) begin
      model_data.push_back(tr.din);
      model_count++;
      if (model_count > DEPTH)
        `uvm_error("SCOREBOARD", "FIFO overflow detected in scoreboard model")
    end

    if (do_rd) begin
      if (model_data.size() == 0) begin
        `uvm_error("SCOREBOARD", "Read occurred while model was empty")
      end else begin
        logic [DATA_WIDTH-1:0] expected = model_data.pop_front();
        model_count--;
        if (tr.dout !== expected)
          `uvm_error("SCOREBOARD", $sformatf("Data mismatch: saw %0h expected %0h", tr.dout, expected));
        else
          `uvm_info("SCOREBOARD", $sformatf("Read matched expected %0h", expected), UVM_LOW);
      end
    end

    expected_full  = (model_count == DEPTH);
    expected_empty = (model_count == 0);

    if (tr.full !== expected_full)
      `uvm_warning("SCOREBOARD", $sformatf("full signal mismatch (got %0b, expected %0b)", tr.full, expected_full));
    if (tr.empty !== expected_empty)
      `uvm_warning("SCOREBOARD", $sformatf("empty signal mismatch (got %0b, expected %0b)", tr.empty, expected_empty));
  endfunction
endclass
