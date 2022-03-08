`include "memory/memory.v"

module fetch_unit(
  input clk, 
  input [31:0] pc,
  output wire [31:0] instr
);
  wire write;

  initial begin
    $readmemh("testCode.txt",instrMemory.mem); 
  end
  //Memory
  memory #(.DATAWIDTH(32), .ADDRWIDTH(18)) instrMemory(
      .clk(clk), .enable(1'b0),
      .write(1'b1), .addr(pc[19:2]), 
      .in(32'd0), .out(instr));
endmodule