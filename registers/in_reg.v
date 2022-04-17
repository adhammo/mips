module in_reg (
  input clk, rst,
  input [15:0] in_port,
  output wire [15:0] in
);

  // IN Register
  register #(.WIDTH(16)) in_regi (.clk(clk), .rst(rst),
                                  .load(1'b1),
                                  .in(in_port),
                                  .out(in));

endmodule