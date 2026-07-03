// Inputs:
//   clk - Clock signal
//   memread - Read enable (from Control Unit)
//   memwrite - Write enable (from Control Unit)
//   funct3[2:0] - Load/Store type (from instruction decoder)
//            000 = LB/SB  (byte, sign-extend on read)
//            001 = LH/SH  (halfword, sign-extend on read)
//            010 = LW/SW  (word)
//            100 = LBU    (byte, zero-extend on read)
//            101 = LHU    (halfword, zero-extend on read)
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
    parameter M = 256,
    parameter N = 32,
    parameter ADDR_WIDTH = $clog2(M)
)(
    input  wire clk,
    input  wire memread,
    input  wire memwrite,
    input  wire [2:0]    funct3,
    input  wire [31:0]   address,
    input  wire [N-1:0]  write_data,
    output reg  [N-1:0]  read_data
);
    // Memory array: 256 locations x 32 bits = 1KB
    reg [N-1:0] memory [0:M-1];

    wire [ADDR_WIDTH-1:0] mem_addr;
    assign mem_addr = address[ADDR_WIDTH+1:2];

    // Byte offset within the 32-bit word
    wire [1:0] byte_off = address[1:0];

    // Synchronous write on rising clock edge
    always @(posedge clk) begin
        if (memwrite) begin
            case (funct3)
                3'b000: begin // SB - write 1 byte only, leave other 3 untouched
                    case (byte_off)
                        2'd0: memory[mem_addr][7:0]   <= write_data[7:0];
                        2'd1: memory[mem_addr][15:8]  <= write_data[7:0];
                        2'd2: memory[mem_addr][23:16] <= write_data[7:0];
                        2'd3: memory[mem_addr][31:24] <= write_data[7:0];
                    endcase
                end
                3'b001: begin // SH - write 2 bytes only, leave other 2 untouched
                    if (byte_off[1] == 1'b0)
                        memory[mem_addr][15:0]  <= write_data[15:0];
                    else
                        memory[mem_addr][31:16] <= write_data[15:0];
                end
                3'b010: begin // SW - write full word
                    memory[mem_addr] <= write_data;
                end
                default: begin // invalid funct3 - safe no-op
                    memory[mem_addr] <= memory[mem_addr];
                end
            endcase
        end
    end

    // Asynchronous read, output 0 when memread is low
    always @(*) begin
        if (memread) begin
            case (funct3)
                3'b000: begin // LB - sign extend byte
                    case (byte_off)
                        2'd0: read_data = {{24{memory[mem_addr][7]}},  memory[mem_addr][7:0]};
                        2'd1: read_data = {{24{memory[mem_addr][15]}}, memory[mem_addr][15:8]};
                        2'd2: read_data = {{24{memory[mem_addr][23]}}, memory[mem_addr][23:16]};
                        2'd3: read_data = {{24{memory[mem_addr][31]}}, memory[mem_addr][31:24]};
                    endcase
                end
                3'b100: begin // LBU - zero extend byte
                    case (byte_off)
                        2'd0: read_data = {24'b0, memory[mem_addr][7:0]};
                        2'd1: read_data = {24'b0, memory[mem_addr][15:8]};
                        2'd2: read_data = {24'b0, memory[mem_addr][23:16]};
                        2'd3: read_data = {24'b0, memory[mem_addr][31:24]};
                    endcase
                end
                3'b001: begin // LH - sign extend halfword
                    if (byte_off[1] == 1'b0)
                        read_data = {{16{memory[mem_addr][15]}}, memory[mem_addr][15:0]};
                    else
                        read_data = {{16{memory[mem_addr][31]}}, memory[mem_addr][31:16]};
                end
                3'b101: begin // LHU - zero extend halfword
                    if (byte_off[1] == 1'b0)
                        read_data = {16'b0, memory[mem_addr][15:0]};
                    else
                        read_data = {16'b0, memory[mem_addr][31:16]};
                end
                3'b010: begin // LW - full word read
                    read_data = memory[mem_addr];
                end
                default: begin // invalid funct3 - output 0
                    read_data = {N{1'b0}};
                end
            endcase
        end
        else
            read_data = {N{1'b0}};
    end
endmodule
