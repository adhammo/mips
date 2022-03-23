module pc_reg (
  input clk, rst, 
  input dirty,
  input wire [31:0] pc_in,
  output wire [31:0] pc
);

  // PC Register
  register #(.WIDTH(32)) pc_regi (.clk(clk), .rst(rst),
                                  .load(!dirty),
                                  .in(pc_in),
                                  .out(pc));
 
endmodule