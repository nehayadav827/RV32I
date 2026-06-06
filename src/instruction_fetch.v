module instruction_memory (
    input  wire [31:0] addr,
    output wire [31:0] instruction
);

    reg [31:0] mem [0:255];

    assign instruction = mem[addr[31:2]];

    initial begin
        $readmemh("instructions.hex", mem);
    end

endmodule
