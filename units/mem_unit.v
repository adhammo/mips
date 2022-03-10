module mem_unit (
  input clk,
  input dirty, skip,
  input wr,
  input [31:0] addr,
  input [15:0] di,
  output wire [15:0] do
);

  // Write Signal (protect and skip)
  wire write;
  assign write = !dirty && !skip && wr;

  // Data Memory
  memory #(.DATAWIDTH(16), .ADDRWIDTH(19)) data_memory (.clk(clk),
                                                        .write(write),
                                                        .addr(addr[19:1]),
                                                        .in(di),
                                                        .out(do));

endmodule