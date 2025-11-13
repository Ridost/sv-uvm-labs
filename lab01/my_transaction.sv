class my_transaction extends uvm_sequence_item;
  rand bit [3:0] sa;
  rand bit [3:0] da;
  rand reg [7:0] payload[$];
  
  `uvm_object_utils(my_transaction)
  

  constraint Limit{
    sa inside {[0:15]};
    da inside {[0:15]};
    payload.size() inside {[2:4]};
  }
                
  function new (string name = "my_transaction");
  	super.new(name);
  endfunction
endclass	
