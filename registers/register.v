module register #(parameter WIDTH=8) (
  input clk, rst,
  input load,
  input [WIDTH-1:0] in,
  output reg [WIDTH-1:0] out
);

  // Register
  always @(posedge clk or negedge rst) begin
    if (!rst) out <= {WIDTH{1'b0}}; // reset
    else if (load) out <= in;       // load input
  end

endmodule