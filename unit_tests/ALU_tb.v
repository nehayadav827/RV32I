module ALU_tb( );

logic [31:0] A,B;
logic [3:0] alu_op;

logic [31:0] result;
logic zero;

    //ALU operation code
    parameter ALU_ADD = 4'b0000;
    parameter ALU_SUB = 4'b0001;
    parameter ALU_AND = 4'b0010;
    parameter ALU_OR  = 4'b0011;
    parameter ALU_XOR = 4'b0100;
    parameter ALU_SLT = 4'b0101;
    parameter ALU_SLTU =4'b0110;
    parameter ALU_SLL = 4'b0111;
    parameter ALU_SRL = 4'b1000;
    parameter ALU_SRA = 4'b1001;

ALU alu_block(.A(A),.B(B),.alu_op(alu_op),.result(result),.zero(zero));

int pass_count;
int fail_count;
int test_count;

    // for applying different test sequences
task apply_inputs(
    input [31:0] A_in,
    input [31:0] B_in,
    input [3:0] alu_op_in 
);

begin
A = A_in;
B = B_in;
alu_op = alu_op_in;
#1;
end

endtask

    // for verifying result 
task check_results(
    input string test_name,
    input [31:0] expected_result,
    input expected_zero
);
begin
    test_count++;
    
   if(result == expected_result && zero == expected_zero) begin
        pass_count++;
        $display("[PASS] %s",test_name);
   end
   else begin
        fail_count++;
        $display("[FAIL] %s",test_name);
        
        $display("Expected: result =%h ,zero =%b",expected_result,expected_zero);
        $display("Actual: result =%h , zero =%b",result,zero);
   
   end
   
 end
endtask

    // Giving test stimulus 
    initial begin
    
   
    //ADD operations
    apply_inputs(32'd13,32'd17,ALU_ADD);
    check_results("ADD",32'd30,0);
    
    apply_inputs(32'h7FFFFFFF,32'd1,ALU_ADD);
    check_results("ADD_OVERFLOW",32'h80000000,0);
    
    //SUB operations
    apply_inputs(32'd23,32'd19,ALU_SUB);
    check_results("SUB",32'd4,0);
    
    apply_inputs(32'd10,32'd10,ALU_SUB);
    check_results("SUB_0",32'd0,1);
    
    apply_inputs(32'd0,32'd1,ALU_SUB);
    check_results("SUB_UNDERFLOW",32'hFFFFFFFF,0);
    
    //AND operation
    apply_inputs(32'hFFFF,32'hAAAA,ALU_AND);
    check_results("AND",32'hAAAA,0);
    
    //OR operation
    apply_inputs(32'hAA50,32'h5501,ALU_OR);
    check_results("OR",32'hFF51,0);
    
    //XOR operation
    apply_inputs(32'hFFAF,32'hA55F,ALU_XOR);
    check_results("XOR",32'h5AF0,0);
    
    //SLT operation
    apply_inputs(32'd5,32'd10,ALU_SLT);
    check_results("SLT_1",32'd1,0);
    
    apply_inputs(32'd15,32'd10,ALU_SLT);
    check_results("SLT_2",32'd0,1);
    
    apply_inputs(-32'd15,32'd10,ALU_SLT);
    check_results("SLT_3",32'd1,0);
    
    apply_inputs(-32'd5,-32'd10,ALU_SLT);
    check_results("SLT_4",32'd0,1);
    
    apply_inputs(32'd5,32'd5,ALU_SLT);
    check_results("SLT_5",32'd0,1);
    
    //SLTU operation
    apply_inputs(32'd25,32'd30,ALU_SLTU);
    check_results("SLTU_1",32'd1,0);
    
    apply_inputs(32'd10,32'd10,ALU_SLTU);
    check_results("SLTU_2",32'd0,1);
    
    apply_inputs(-32'd5,32'd3,ALU_SLTU);
    check_results("SLTU_3",32'd0,1);
    
    //SLL operation
    apply_inputs(32'd16,32'd4,ALU_SLL);
    check_results("SLL",32'd256,0);
    
    apply_inputs(32'd1,32'd31,ALU_SLL);
    check_results("SLL_MAX_SHIFT",32'h80000000,0);
    
    apply_inputs(32'd1,32'd36,ALU_SLL);
    check_results("SLL_OVERFLOW",32'd16,0);
    
    //SRL operation
    apply_inputs(32'd256,32'd4,ALU_SRL);
    check_results("SLT",32'd16,0);
    
    apply_inputs(32'h80000000,32'd31,ALU_SRL);
    check_results("SRL_MAX_SHIFT",32'd1,0);
    
    // SRA operation
    apply_inputs(-32'd8, 32'd2, ALU_SRA);
    check_results("SRA_1", 32'hFFFFFFFE, 0);
    
    apply_inputs(-32'd1, 32'd4, ALU_SRA);
    check_results("SRA_2", 32'hFFFFFFFF, 0);
    
    //invalid alu operation
    apply_inputs(32'd10,32'd20,4'b1111);
    check_results("INVALID_OPCODE",32'd0,1);
    
     if (fail_count == 0) begin
      $display("All tests passed!");
    end else begin
      $display("Some tests failed!");
    end

    $finish;

    end

endmodule
