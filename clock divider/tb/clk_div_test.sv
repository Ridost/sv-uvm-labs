`include "uvm_macros.svh"
import uvm_pkg::*;


class clk_div_test extends uvm_test;
  `uvm_component_utils(clk_div_test)
  
  clk_div_env env;
  clk_div_sequence seq;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    env = clk_div_env::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this,"test raise the objection");
    seq = clk_div_sequence::type_id::create("seq",this);
    seq.start(env.agt.seqr);
    #10;
    phase.drop_objection(this,"test drop the objection");
  endtask
endclass
