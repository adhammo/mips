module stage_reg #(parameter WIDTH=8) (
  input clk, rst,
  input keep,
  input [WIDTH-1:0] in,
  output wire [WIDTH-1:0] out
);

  // Stage Register
  register #(.WIDTH(WIDTH)) stage_regi (.clk(clk), .rst(rst),
                                        .load(!keep),
                                        .in(in),
                                        .out(out));

endmodule