module flags (
  input clk, rst,
  input enable,
  input sc,
  input zi, ni, ci,
  output wire z, n, c
);

  // Flags Output
  wire [2:0] flags_out;
  assign {z, n, c} = flags_out; // extract flags

  // Flags Input
  wire [2:0] flags_in;
  assign flags_in = {zi, ni, sc || ci}; // combine flags

  // Flags Register
  register #(.WIDTH(3)) flags_regi(.clk(clk), .rst(rst),
                                   .load(enable),
                                   .in(flags_in),
                                   .out(flags_out));

endmodule