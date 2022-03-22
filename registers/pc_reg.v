module pc_reg (
  input clk, rst, 
  input keep,
  input wire [31:0] pc_in,
  output wire [31:0] pc
);

  // PC Register
  register #(.WIDTH(32)) pc_regi (.clk(clk), .rst(rst),
                                  .load(!keep),
                                  .in(pc_in),
                                  .out(pc));
 
endmodule