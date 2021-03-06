`timescale 10ns/1ns
module cpu_tb;

  reg clk, rst;
  reg [15:0] in;
  wire [15:0] out;

  cpu cpu (.clk(clk), .rst(rst), .in_port(in), .out_port(out));

  initial begin
    // load test code
    $readmemh("tests/table.txt", cpu.fetch_unit.instr_memory.mem, 18'd0);
    $readmemh("tests/int.txt", cpu.fetch_unit.instr_memory.mem, (cpu.fetch_unit.instr_memory.mem[18'd0] >> 2)); 

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