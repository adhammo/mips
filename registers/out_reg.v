module out_reg (
  input clk, rst,
  input enable,
  input [15:0] out,
  output wire [15:0] out_port
);

  // OUT Register
  register #(.WIDTH(16)) out_regi (.clk(clk), .rst(rst),
                                   .load(enable),
                                   .in(out),
                                   .out(out_port));

endmodule