
`timescale 1ns/1ns

`inlcude "uvm_macros.svh" 
import uvm_pkg::*;

module top();
  
  logic clk;
  logic rst;
  
  rv32i_top dut(.clk(intf.clk),.rst(intf.rst));
  
  rv32i_intf intf(.clk(clk),.rst(rst));
  
  clk=0;
  always #10 clk = ~clk;
  
  initial begin
    $monitor("$time","Clk = %d",clk);
  	$100 finish;
  end
  
endmodule
