class rv32i_sequencer extends uvm_sequencer;

  `uvm_component_utils(rv32i_sequencer);
  
  //standard constructor
  function new(string name = "rv32i_sequencer", uvm_component parent);
  
    super.new(name,parent);
    `uvm_info("Sequencer Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
endclass
