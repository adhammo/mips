`timescale 10ns/1ns
module cpu_tb;

  reg clk, rst, RST;
  reg [15:0] in;
  wire [15:0] out;

  cpu cpu (.clk(clk), .rst(rst), .in_port(in), .out_port(out));

  initial begin
    // load test code
    $readmemh("start.txt", cpu.fetch_unit.instr_memory.mem);
    $readmemh("in_out.txt", cpu.fetch_unit.instr_memory.mem, (cpu.fetch_unit.instr_memory.mem[18'd0] >> 2'd2)); 

    // init
    clk = 1'b0;
    rst = 1'b1;
    RST = 1'b1;
    #1;
    in  = 16'd20;

    // reset
    RST = 1'b0;
    rst = 1'b0; #6;
    RST = 1'b1;
    rst = 1'b1; #10;

    // clk1
  end

  always #5 clk = ~clk;

endmodule