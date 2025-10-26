`include "uvm_macros.svh"
import uvm_pkg::*;

class adder_test extends uvm_test;
  adder_env env;
  adder_sequence seq;
  
  `uvm_component_utils(adder_test);
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    env = adder_env::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = adder_sequence::type_id::create("seq");
    seq.start(env.agt.seqr);
    #10;
    phase.drop_objection(this);
  endtask
endclass
