class adder_seq_item extends uvm_sequence_item;
  rand bit [7:0] a,b;
  bit [7:0] sum;
  bit carry;
  
  `uvm_object_utils(adder_seq_item)
  
  function new(string name="adder_seq_item");
    super.new(name);
  endfunction
  
  function string convert2string();
    //return $sformat("a=%0d b=%0d sum=%0d carry=%0b",a,b,sum,carry);
    return $sformatf("a=%0d b=%0d sum=%0d carry=%0b", a, b, {carry,sum}, carry);
  endfunction
endclass
