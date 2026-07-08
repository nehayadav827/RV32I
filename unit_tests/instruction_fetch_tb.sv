
module tb_instruction_memory;

    //  Testbench Signals 
    logic [31:0] addr;           // Input: memory address (from PC)
    logic [31:0] instruction;    // Output: fetched 32-bit instruction

    //  Test Tracking 
    integer pass;                // Counter for passed tests
    integer fail;                // Counter for failed tests

    //  Expected Values 
    // These hex values come from RARS 1.6 assembler
    // Each value is the correct machine code for the instruction
    // at that memory location
    logic [31:0] expected [0:36]; // Array of 37 expected hex values

    //  Instantiate Design Under Test (DUT) 
    instruction_memory uut (
        .addr(addr),
        .instruction(instruction)
    );

    //  Load Expected Values 
    // Each index corresponds to one instruction in memory
    initial begin

        // R-Type instructions (index 0-9)
        // Format: funct7 | rs2 | rs1 | funct3 | rd | opcode
        expected[0]  = 32'h003100b3; // add  x1, x2, x3
        expected[1]  = 32'h40628233; // sub  x4, x5, x6
        expected[2]  = 32'h009413b3; // sll  x7, x8, x9
        expected[3]  = 32'h00c5a533; // slt  x10, x11, x12
        expected[4]  = 32'h00f736b3; // sltu x13, x14, x15
        expected[5]  = 32'h0128c833; // xor  x16, x17, x18
        expected[6]  = 32'h015a59b3; // srl  x19, x20, x21
        expected[7]  = 32'h418bdb33; // sra  x22, x23, x24
        expected[8]  = 32'h01bd6cb3; // or   x25, x26, x27
        expected[9]  = 32'h01eefe33; // and  x28, x29, x30

        // I-Type ALU instructions (index 10-18)
        // Format: imm[11:0] | rs1 | funct3 | rd | opcode
        expected[10] = 32'h00500093; // addi x1, x0, 5
        expected[11] = 32'h00a1a113; // slti x2, x3, 10
        expected[12] = 32'h0062b213; // sltiu x4, x5, 6
        expected[13] = 32'h0033c313; // xori x6, x7, 3
        expected[14] = 32'h0074e413; // ori  x8, x9, 7
        expected[15] = 32'h00f5f513; // andi x10, x11, 15
        expected[16] = 32'h00269613; // slli x12, x13, 2
        expected[17] = 32'h0017d713; // srli x14, x15, 1
        expected[18] = 32'h4038d813; // srai x16, x17, 3

        // Load instructions (index 19-23)
        // Format: imm[11:0] | rs1 | funct3 | rd | opcode
        expected[19] = 32'h00010083; // lb   x1, 0(x2)
        expected[20] = 32'h00021183; // lh   x3, 0(x4)
        expected[21] = 32'h00032283; // lw   x5, 0(x6)
        expected[22] = 32'h00044383; // lbu  x7, 0(x8)
        expected[23] = 32'h00055483; // lhu  x9, 0(x10)

        // Store instructions (index 24-26)
        // Format: imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode
        expected[24] = 32'h00110023; // sb   x1, 0(x2)
        expected[25] = 32'h00321023; // sh   x3, 0(x4)
        expected[26] = 32'h00532023; // sw   x5, 0(x6)

        // Branch instructions (index 27-32)
        // Format: scattered immediate | rs2 | rs1 | funct3 | opcode
        expected[27] = 32'h00208c63; // beq  x1, x2, label1
        expected[28] = 32'h00419a63; // bne  x3, x4, label2
        expected[29] = 32'h0062c863; // blt  x5, x6, label3
        expected[30] = 32'h0083d663; // bge  x7, x8, label4
        expected[31] = 32'h00a4e463; // bltu x9, x10, label5
        expected[32] = 32'h00c5f263; // bgeu x11, x12, label6

        // U-Type instructions (index 33-34)
        // Format: imm[31:12] | rd | opcode
        expected[33] = 32'h123450b7; // lui  x1, 0x12345
        expected[34] = 32'h12345117; // auipc x2, 0x12345

        // Jump instructions (index 35-36)
        // JAL:  J-type | JALR: I-type
        expected[35] = 32'h008000ef; // jal  x1, label7
        expected[36] = 32'h00008167; // jalr x2, x1, 0
    end

    //  Main Test Execution 
    initial begin

        // Initialize counters
        pass = 0;
        fail = 0;

        $dumpfile("imem.vcd");
        $dumpvars(0, tb_instruction_memory);

        $display("  Instruction Memory Verification Test  ");
        $display("");

        //  Test All 37 Instructions 
        // Loop through each memory address 
        for (int i = 0; i < 37; i++) begin

            // Set address: instruction i is at byte address i*4
            addr = i * 4;
            #10;
            if (instruction === expected[i]) begin
                $display("PASS [%2d] PC=%h | Got=%h | Expected=%h",
                          i, addr, instruction, expected[i]);
                pass = pass + 1;
            end else begin
                $display("FAIL [%2d] PC=%h | Got=%h | Expected=%h",
                          i, addr, instruction, expected[i]);
                fail = fail + 1;
            end
        end

        //  Boundary Test:
        // Address 0x100 (256) is beyond the 37 loaded instructions
        // Memory at this location should be x or zero
        addr = 32'h00000100;
        #10;
        $display("");
        $display("Boundary test: addr=%h instruction=%h", addr, instruction);

        // Print Summary 
        $display("");
        $display("           TEST SUMMARY                 ");
        $display("  Passed: %0d / %0d", pass, pass + fail);
        $display("  Failed: %0d / %0d", fail, pass + fail);

        if (fail == 0)
            $display("  RESULT: ALL TESTS PASSED");
        else
            $display("  RESULT: SOME TESTS FAILED");
        $finish;
    end

endmodule
