class rv32i_driver extends uvm_driver;
  
  `uvm_component_utils(rv32i_driver)
  
  //standard constructor
  function new(string name = "rv32i_driver",uvm_component parent);
  
    super.new(name,parent);
    `uvm_info("Driver Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
endclass
