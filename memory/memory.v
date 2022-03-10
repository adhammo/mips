module memory #(parameter DATAWIDTH=8, parameter ADDRWIDTH=20)(
  input clk, write,
  input [ADDRWIDTH-1:0] addr,
  input [DATAWIDTH-1:0] in,
  output wire [DATAWIDTH-1:0] out
);

  // Memory
  reg [DATAWIDTH-1:0] mem[0:(2**ADDRWIDTH)-1];

  // Async Read
  assign out = mem[addr];

  // Sync Write
  always @(posedge clk) begin
    if (write) mem[addr] <= in; // write to memory
  end

endmodule