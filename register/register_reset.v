module register_reset #(parameter WIDTH=8, parameter RSTVAL=8'b0) (
  input clk, rst,
  input load,
  input [WIDTH-1:0] in,
  output reg [WIDTH-1:0] out
);

  // Sync Write and Async Reset
  always @(posedge clk or negedge rst) begin
    if (!rst) out <= RSTVAL;  // reset register
    else if (load) out <= in; // write to register
  end

endmodule