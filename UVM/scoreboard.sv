class rv32i_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(rv32i_scoreboard)
  uvm_analysis_imp #(rv32i_seq_item, rv32i_scoreboard) item_collected_export;
  
  //standard constructor
  function new(string name = "rv32i_scoreboard",uvm_component parent);
  
    super.new(name,parent);
    `uvm_info("Scoreboard Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase)'
    super.build_phase(phase);  
  endfunction
  
endclass
