class rv32i_agent extends uvm_agent;

  `uvm_component_utils(rv32i_agent)
  
  //standard constructor
  function new(string name = "rv32i_agent",uvm_component parent);
  
    super.new(name,parent);
    `uvm_info("Agent Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
endclass
