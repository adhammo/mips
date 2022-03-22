module out_reg (
  input clk, rst,
  input load,
  input [15:0] in,
  output wire [15:0] out
);

  // IN Register
  register #(.WIDTH(16)) in_regi (.clk(clk), .rst(rst),
                                  .load(load),
                                  .in(in),
                                  .out(out));
 
endmodule