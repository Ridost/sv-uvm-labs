class my_sequence extends uvm_sequence #(my_transaction);
  `uvm_object_utils(my_sequence)
  
  function new (string name = "my_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    if (starting_phase != null)begin
      starting_phase.raise_objection(this);
    end
    
    repeat(10)begin
      `uvm_do(req)
    end
    
    #100;
    if(starting_phase != null)begin
      starting_phase.drop_objection(this);
    end
  endtask
endclass
