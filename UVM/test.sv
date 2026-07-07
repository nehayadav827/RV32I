class rv32i_test extends uvm_test;
  
  `uvm_component_utils(rv32i_test)
  
  //standard constructor
  function new(string name = "rv32i_test",uvm_component parent);
    super.new(name,parent);
    `uvm_info("Test Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
endclass
