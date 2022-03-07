module memory #(parameter DATAWIDTH = 16, parameter ADDRWIDTH = 20)(
  input wire clk, write, enable,
  input wire [ADDRWIDTH - 1:0] addr,
  input wire [DATAWIDTH - 1:0] in,
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