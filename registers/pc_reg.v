module pc_reg (
  input clk, rst,
  input keep,
  input jump,
  input [31:0] target,
  output wire [31:0] pc
);

  // PC Input
  reg [31:0] pc_in;
  always @(*) begin
    // calculate new pc
    if (jump)
      pc_in = target;
    else
      pc_in = pc + 32'd4;
  end

  // PC Register
  register #(.WIDTH(32)) pc_regi (.clk(clk), .rst(rst),
                                  .load(!keep),
                                  .in(pc_in),
                                  .out(pc));
 
endmodule