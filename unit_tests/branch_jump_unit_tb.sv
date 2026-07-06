module Branch_Jump_Unit_tb;

logic rst;
logic jump;
logic jalr;
logic brh;

logic [2:0] func_b;
logic [31:0] src_reg_1;
logic [31:0] src_reg_2;
logic [31:0] imm;
logic [31:0] pc_in;

logic [31:0] pc_out;
logic [31:0] link_addr;
logic brh_taken;
logic jump_taken;

localparam BEQ  = 3'b000;
localparam BNE  = 3'b001;
localparam BLT  = 3'b100;
localparam BGE  = 3'b101;
localparam BLTU = 3'b110;
localparam BGEU = 3'b111;

Branch_Jump_Unit dut(
    .rst(rst),
    .jump(jump),
    .jalr(jalr),
    .brh(brh),
    .func_b(func_b),
    .src_reg_1(src_reg_1),
    .src_reg_2(src_reg_2),
    .imm(imm),
    .pc_in(pc_in),
    .pc_out(pc_out),
    .link_addr(link_addr),
    .brh_taken(brh_taken),
    .jump_taken(jump_taken)
);

integer tests  = 0;
integer passed = 0;

task run_test(
    input string name,
    input rst_i,
    input jump_i,
    input jalr_i,
    input brh_i,
    input [2:0] func_i,
    input [31:0] rs1_i,
    input [31:0] rs2_i,
    input [31:0] imm_i,
    input [31:0] pc_i,
    input [31:0] exp_pc,
    input [31:0] exp_link,
    input exp_brh,
    input exp_jump
);

begin
    rst       = rst_i;
    jump      = jump_i;
    jalr      = jalr_i;
    brh       = brh_i;
    func_b    = func_i;
    src_reg_1 = rs1_i;
    src_reg_2 = rs2_i;
    imm       = imm_i;
    pc_in     = pc_i;

    #1;

    tests++;

    if (pc_out      == exp_pc &&
        link_addr   == exp_link &&
        brh_taken   == exp_brh &&
        jump_taken  == exp_jump)
    begin
        passed++;
        $display("[PASS] %s", name);
    end
    else begin
        $display("[FAIL] %s", name);
        $display(" Expected : pc=%h link=%h brh=%b jump=%b", exp_pc, exp_link, exp_brh, exp_jump);
        $display(" Got      : pc=%h link=%h brh=%b jump=%b", pc_out, link_addr, brh_taken, jump_taken);
    end
end

endtask

initial begin

// Reset
run_test("RESET",1,0,0,0,0,0,0,0,0,32'h00000000,32'h00000000,0,0);

// Sequential PC
run_test("PC+4",0,0,0,0,0,0,0,0,32'd100,32'd104,32'd0,0,0);

// JAL
run_test("JAL",0,1,0,0,0,0,0,32'd20,32'd100,32'd120,32'd104,0,1);

// JAL Backward
run_test("JAL Backward",0,1,0,0,0,0,0,-32'd40,32'd100,32'd60,32'd104,0,1);

// JALR
run_test("JALR",0,0,1,0,0,32'd200,0,32'd12,32'd100,32'd212,32'd104,0,1);

// JALR Alignment
run_test("JALR Alignment",0,0,1,0,0,32'd101,0,32'd2,32'd100,32'd102,32'd104,0,1);

// BEQ Taken
run_test("BEQ Taken",0,0,0,1,BEQ,10,10,16,100,116,0,1,0);

// BEQ Not Taken
run_test("BEQ Not Taken",0,0,0,1,BEQ,10,20,16,100,104,0,0,0);

// BNE Taken
run_test("BNE Taken",0,0,0,1,BNE,10,20,12,100,112,0,1,0);

// BLT Taken
run_test("BLT Taken",0,0,0,1,BLT,-5,10,8,100,108,0,1,0);

// BGE Taken
run_test("BGE Taken",0,0,0,1,BGE,20,10,8,100,108,0,1,0);

// BLTU Taken
run_test("BLTU Taken",0,0,0,1,BLTU,5,10,24,100,124,0,1,0);

// BGEU Taken
run_test("BGEU Taken",0,0,0,1,BGEU,20,10,24,100,124,0,1,0);

// Negative Offset Branch
run_test("Negative Branch",0,0,0,1,BEQ,5,5,-20,100,80,0,1,0);

// Zero Offset Branch
run_test("Zero Offset",0,0,0,1,BEQ,5,5,0,100,100,0,1,0);

// Signed Extreme
run_test("BLT Extreme",0,0,0,1,BLT,32'h80000000,32'h7FFFFFFF, 8, 100,108,0,1,0);

// Unsigned Extreme
run_test("BGEU Extreme",0,0,0,1,BGEU, 32'hFFFFFFFF, 32'h00000000, 12, 100, 112,0,1,0);

// PC Overflow
run_test("PC Overflow",0,0,0,0,0,0,0,0,32'hFFFFFFFC,32'h00000000,0,0,0);

// Priority (jump > jalr)
run_test("Jump Priority",0,1,1,0,0,32'd200,0,20,100,120,104,0,1);

// All Zero
run_test("All Zero",0,0,0,0,0,0,0,0,0,4,0,0,0);

// BNE Not Taken  
run_test("BNE Not Taken",0,0,0,1,BNE,10,10,12,100,104,0,0,0);

// BLT Not Taken   
run_test("BLT Not Taken",0,0,0,1,BLT,20,10,8,100,104,0,0,0);

// BGE Not Taken    
run_test("BGE Not Taken",0,0,0,1,BGE,10,20,8,100,104,0,0,0);

// BLTU Not Taken    
run_test("BLTU Not Taken",0,0,0,1,BLTU,20,10,24,100,104,0,0,0);

// BGEU Not Taken    
run_test("BGEU Not Taken",0,0,0,1,BGEU,5,10,24,100,104,0,0,0);

// BEQ Max Offset    
run_test("BEQ Max Offset",0,0,0,1,BEQ,5,5,32'h7FFFFFFC,100,32'h80000060,0,1,0);

// BGE Extreme     
run_test("BGE Extreme",0,0,0,1,BGE,32'h7FFFFFFF,32'h80000000,8,100,108,0,1,0);

// BLTU Extreme    
run_test("BLTU Extreme",0,0,0,1,BLTU,32'h00000000,32'hFFFFFFFF, 12,100,112,0,1,0);

// Jump and Branch    
run_test("Jump and Branch",0,1,0,1,BEQ,10,10,16,100,116,0,1,0);

//  JALR and Branch  
run_test("JALR and Branch",0,0,1,1,BEQ,10,10,16,100,116,0,1,0);

// Reset Priority    
run_test("Reset Priority",1,1,1,1,BEQ,10,10,16,100,0,0,0,0);

// Invalid func3    
run_test("Invalid func3",0,0,0,1,3'b010,10,10,16,100,104,0,0,0);

// JAL Zero Offset   
run_test("JAL Zero Offset",0,1,0,0,0,0,0,0,100,100,104,0,1);

// JALR Negative Offset    
run_test("JALR Negative Offset",0,0,1,0,0,200,0,-32'd12,100,188,104,0,1);

$display("");
$display("--------------------------------");
$display("Tests Passed : %0d / %0d", passed, tests);
$display("--------------------------------");

if (passed == tests)
    $display("ALL TESTS PASSED");
else
    $display("SOME TESTS FAILED");

$finish;

end

endmodule
