module mux4_1 #(parameter WIDTH = 32) (
    input wire [1:0] sel,
    input wire  [WIDTH - 1:0] in1,
    input wire  [WIDTH - 1:0] in2,
    input wire  [WIDTH - 1:0] in3,
    input wire  [WIDTH - 1:0] in4,
    output wire [WIDTH - 1:0] out,
);
  always@(*) begin
      case(sel)
      2'b00: out <= in1;
      2'b01: out <= in2;
      2'b10: out <= in3;
      2'b11: out <= in4;
      endcase
  end  
endmodule