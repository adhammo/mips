`include "memory/memory.v"

module fetch_unit(
  input clk, 
  input [31:0] pc,
  output wire [31:0] instr
);
  wire write;

  //Memory
  memory #(.DATAWIDTH(32), .ADDRWIDTH(18)) dataMemory(
      .clk(clk), .enable(0),
      .write(1), .addr(pc[17:0]), 
      .in(0), .out(instr));
endmodule