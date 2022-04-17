module fetch_unit (
  input clk,
  input [31:0] addr,
  output wire [31:0] instr
);

  // Instruction Memory
  memory #(.DATAWIDTH(32), .ADDRWIDTH(18)) instr_memory (.clk(clk),
                                                         .write(1'b0),
                                                         .addr(addr[19:2]),
                                                         .in(32'd0),
                                                         .out(instr));

endmodule