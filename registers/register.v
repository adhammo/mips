module register #(parameter WIDTH=8) (
  input clock, reset,
  input load,
  input [WIDTH-1:0] in,
  output reg [WIDTH-1:0] out
);

  // Register
  always @(posedge clock or negedge reset) begin
    if (!reset) out <= {WIDTH{1'b0}}; // reset
    else if (load) out <= in;         // load input
  end

endmodule