
module imm_generator(
    input[31:0] instruction,
    input[2:0]  imm_sel, 
    output reg[31:0] immediate 
);
    
    parameter I_Type = 3'b000;
    parameter S_Type = 3'b001;
    parameter B_Type = 3'b010;
    parameter U_Type = 3'b011;
    parameter J_Type = 3'b100;

    always @(*) begin
        case (imm_sel)
            I_Type:
                immediate = {{20{instruction[31]}},instruction[31:20]};
                         
            S_Type: 
                immediate = {{20{instruction[31]}}, instruction[31:25],instruction[11:7]};
          
            B_Type:
                immediate = {{19{instruction[31]}},  instruction[31],instruction[7],instruction[30:25], instruction[11:8],   1'b0};
              
            U_Type:
                immediate = {instruction[31:12],12'b0};
               
            J_Type: 
                immediate = {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21], 1'b0};
 
            default:
                immediate = 32'd0;
        endcase
    end
endmodule
