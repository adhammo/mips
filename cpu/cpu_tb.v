`timescale 10ns/1ns
module cpu_tb;

  reg clk, rst;

  cpu cpu (.clk(clk), .rst(rst));

  initial begin
    // load test code
    $readmemh("../tests/counter.txt", cpu.fetch_unit.instr_memory.mem); 

    // init
    clk = 1'b0;
    rst = 1'b1; #1;

    // reset
    rst = 1'b0; #6;
    rst = 1'b1; #10;

    // clk1
  end

  always #5 clk = ~clk;

endmodule