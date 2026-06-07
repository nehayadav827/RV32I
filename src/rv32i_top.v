module rv32i_top(
    input clk,
    input rst
    );
    
    //wire connecting submodules
    wire [31:0] pc , next_pc;    // for PC
    wire [31:0] instruction;     // for fetch
    wire [6:0] opcode;           // for decoder
    wire [2:0] funct3;
    wire [6:0] funct7;
    
    wire [31:0] immediate;       // for immediate generator
    
    wire [31:0] alu_result;      // for ALU
    wire alu_zero;
    wire [31:0] alu_B;
    wire [1:0] ALU_op;
    wire [3:0] alu_op;
    
    wire [31:0] mem_read_data;   // for data memory
    
    
    //control signals
    wire RegWrite,MemRead,MemWrite,MemToReg,ALUSrc,Branch,Jump;
    wire [4:0] rs1_addr,rs2_addr,rd_addr;
    
    //___Integration of submodules___
    //PC instantiation
    program_counter pc_block(.clk(clk),.rst_n(rst),.next_pc(next_pc),.pc(pc));
    
    //Instruction Fetch
    instruction_memory imem_block(.addr(pc),.instruction(instruction));
    
    //Decoder instantiation
    instruction_decoder decoder_block(.instruction(instruction),.opcode(opcode),.rs1(rs1_addr)
                                 ,.rs2(rs2_addr),.rd(rd_addr),.funct3(funct3),.funct7(funct7));
    
endmodule
