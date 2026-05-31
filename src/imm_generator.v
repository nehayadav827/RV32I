`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2026 23:41:20
// Design Name: 
// Module Name: imm_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module imm_generator(
    input[31:0] instruction, //32 bit instruction fetched from inst. memory
    input[2:0]  imm_sel, // control signal fetched from control unit
    output reg[31:0] immediate //32 bit output containing imm. vakue
);

    // for selecting each risc-v format
    parameter I_Type = 3'b000;
    parameter S_Type = 3'b001;
    parameter B_Type = 3'b010;
    parameter U_Type = 3'b011;
    parameter J_Type = 3'b100;

    always @(*) begin
        case (imm_sel)
            I_Type: // stored in bits [31:20]
                immediate = {{20{instruction[31]}},instruction[31:20]};
                         
            S_Type: // stored in bits [31:25],[11:7]
                immediate = {{20{instruction[31]}}, instruction[31:25],instruction[11:7]};
          
            B_Type:// stored in bits [31],[7], [30:25],[11:8], 1'b0
                immediate = {{19{instruction[31]}},  instruction[31],instruction[7],instruction[30:25], instruction[11:8],   1'b0};
              
            U_Type:// stored in bits [31:12], 12'b0
                immediate = {instruction[31:12],12'b0};
               
            J_Type: //stored in bits [31],[19:12],[20], [30:21], 1'b0
                immediate = {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21], 1'b0};
 
            // Default output
            default:
                immediate = 32'd0;
        endcase
    end
endmodule
