// Inputs:
//   clk - Clock signal
//   memread - Read enable (from Control Unit)
//   memwrite - Write enable (from Control Unit)
//   address[31:0] - Byte address from ALU result
//   write_data[N-1:0] - Data from Register File rd2
//
// Outputs:
//   read_data[N-1:0]  - Data to MemToReg MUX
//
// Parameters:
//   M = 256    - Number of memory locations
//   N = 32     - Bits per location (confirmed for RV32I)
//   ADDR_WIDTH - Auto derived as $clog2(M) = 8
module data_memory #(
    parameter M = 256,  // Number of memory locations
    parameter N = 32,  // 32-bit each 
    parameter ADDR_WIDTH = $clog2(M)    // = 8 for 256 locations
)(
    input  wire clk,
    input  wire memread,    
    input  wire memwrite,   
    input  wire [31:0] address,     
    input  wire [N-1:0] write_data,  
    output reg  [N-1:0] read_data  
);

    // Memory array: 256 locations x 32 bits = 1KB
    reg [N-1:0] memory [0:M-1];

    wire [ADDR_WIDTH-1:0] mem_addr;
    assign mem_addr = address[ADDR_WIDTH+1:2];

    // Synchronous write on rising clock edge
    always @(posedge clk)
    begin
        if (memwrite)
            memory[mem_addr] <= write_data;
    end

    // Asynchronous read, output 0 when memread is low
    always @(*)
    begin
        if (memread)
            read_data = memory[mem_addr];
        else
            read_data = {N{1'b0}};
    end
endmodule
