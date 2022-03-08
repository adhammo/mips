module register #(parameter WIDTH=8, parameter RSTVAL=1'b0) (
  input clk, rst,
  input load,
  input [WIDTH-1:0] in,
  output reg [WIDTH-1:0] out
);

  // Register (with Async Reset)
  always @(posedge clk or negedge rst) begin
    if (!rst) out <= {WIDTH{RSTVAL}}; // reset register
    else if (load) out <= in;         // write to register
  end

endmodule