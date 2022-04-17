module pc_reg (
  input clk, rst,
  input enable,
  input load,
  input [31:0] in,
  output wire [31:0] pc
);

  // PC Input
  reg [31:0] pc_in;
  always @(*) begin
    // calculate new pc
    if (load)
      pc_in = in;
    else
      pc_in = pc + 32'd4;
  end

  // PC Register
  register #(.WIDTH(32)) pc_regi (.clk(clk), .rst(rst),
                                  .load(enable),
                                  .in(pc_in),
                                  .out(pc));
 
endmodule