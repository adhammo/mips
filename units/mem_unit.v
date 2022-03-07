`include "memory/memory.v"

module mem_unit (
  input clk, wr, dirty, skip,
  input [31:0] addr,
  input [31:0] in,
  output wire [16: 0] do
);
  wire write;

  //Memory  write logic
  assign write = ~(wr & ~dirty & ~skip);

  //Memory
  memory #(.DATAWIDTH(16), .ADDRWIDTH(19)) dataMemory(
      .clk(clk), .enable(0),
      .write(), .addr(addr[18:0]), 
      .in(in), .out(do));
endmodule