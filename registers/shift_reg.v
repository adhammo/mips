module shift_reg (
  input clk, rst,
  input load,
  input [15:0] in,
  output wire [31:0] out
);

  reg [31:0] val;
  always @(posedge clk or negedge rst) begin
      if(!rst) begin
          val <= 32'd0;
      end
      else if(load) val <= val << 16;
  end
  always @(*) begin
    // calculate new pc
    if(load)
      val = {val[31:16], in};
  end
 
 assign out = val;
endmodule