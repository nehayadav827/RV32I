module tb_instruction_memory;

    logic [31:0] addr;
    logic [31:0] instruction;

    instruction_memory uut (
        .addr(addr),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("imem.vcd");
        $dumpvars(0, tb_instruction_memory);

        // Test all 8 loaded instructions
        for (int i = 0; i < 8; i++) begin
            addr = i * 4;
            #10;
            $display("PC=%h | Instruction=%h", addr, instruction);
        end

        // Test out-of-range address
        addr = 32'h00000100;
        #10;
        $display("PC=%h | Instruction=%h (out of range)", addr, instruction);

        $finish;
    end

endmodule
