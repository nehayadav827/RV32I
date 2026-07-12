class rv32i_monitor extends uvm_monitor;
  
  `uvm_component_utils(rv32i_monitor)
  uvm_analysis_port #(rv32i_seq_item) item_collected_port;
  
  //standard constructor
  function new (string name = "rv32i_monitor",uvm_component parent);
  
    super.new(name,parent);
    `uvm_info("Monitor Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
endclass
