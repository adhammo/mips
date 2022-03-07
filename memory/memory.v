module memory #(parameter DATAWIDTH = 16, parameter ADDRWIDTH = 20)(
  input clk,
  input write, enable,
  input [ADDRWIDTH - 1:0] addr,
  input [DATAWIDTH - 1:0] in,
  output wire [DATAWIDTH - 1:0] out
);

  reg [DATAWIDTH - 1: 0] mem[(2**ADDRWIDTH)-1:0];

  // Memory
  always @(posedge clk) begin
    if(!write) 
      mem[addr] <= in;  // write input (active-low)
  end

  assign out = !enable? mem[addr] : {(16){1'bz}}; // enable output (active-low)
endmodule