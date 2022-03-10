module sp_reg (
  input clk, rst,
  input enable,
  input push, pop,
  output wire [31:0] sp
);

  // SP Output
  wire [31:0] sp_out;
  assign sp = pop ? sp_out + 32'd2 : sp_out; // increment before pop

  // SP Input
  wire [31:0] sp_in;
  assign sp_in = push ? sp_out - 32'd2 : sp_out + 32'd2; // calculate new sp

  // SP Register
  register #(.WIDTH(32), .RSTVAL(1'b1)) sp_regi (.clk(clk), .rst(rst),
                                                 .load(enable && (push || pop)),
                                                 .in(sp_in),
                                                 .out(sp_out));

endmodule