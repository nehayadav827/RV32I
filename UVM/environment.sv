class rv32i_env extends uvm_env;

  `uvm_component_utils(rv32i_env)
  
  //standard constructor
  function new(string name = "rv32i_env",uvm_component parent);
    super.new(name,parent);
    `uvm_info("env Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
endclass
