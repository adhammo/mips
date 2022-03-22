module in_reg (
  input clk,
  input [15:0] in,
  output wire [15:0] out
);

  // IN Register
  register #(.WIDTH(16)) in_regi (.clk(clk), .rst(1'b1),
                                  .load(1'b1),
                                  .in(in),
                                  .out(out));
 
endmodule