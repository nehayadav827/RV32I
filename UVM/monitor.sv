class rv32i_monitor extends uvm_monitor;
  
  `uvm_component_utils(rv32i_monitor)
  
  //standard constructor
  function new (string name = "rv32i_monitor",uvm_component parent);
  
    super.new(name,parent);
    `uvm_info("Monitor Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
endclass
