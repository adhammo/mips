`timescale 1ns/1ns
module mem_tb (
);
  reg clk, rst;
  reg int, ret;
  
   mem_control mem_control (.clk(clk), .rst(rst), .int(int), .ret(ret));

   initial begin
    // init
    clk = 1'b0;
    rst = 1'b0; #1;

    // reset
    rst = 1'b1; 
    ret = 1'b1; #6
    ret = 1'b0; #6
    int = 1'b1;

    // clk1
  end

  always #2 clk = ~clk;
endmodule