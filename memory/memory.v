module memory (
  input clk,
  input write, enable,
  input [19:0] addr,
  input [15:0] in,
  output wire [15:0] out
);

  reg [15: 0] mem[(2**20)-1:0];

  // Memory
  always @(posedge clk) begin
    if(!write) 
      mem[addr] <= in;  // write input (active-low)
  end

  assign out = (!enable)? mem[addr] : {(16){1'bz}}; // enable output (active-low)
endmodule