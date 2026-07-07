class rv32i_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(rv32i_scoreboard)
  
  //standard constructor
  function new(string name = "rv32i_scoreboard",uvm_component parent);
  
    super.new(name,parent);
    `uvm_info("Scoreboard Class","Constructor",UVM_MEDIUM)
    
  endfunction
  
endclass
