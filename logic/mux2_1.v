module mux4_1 #(parameter WIDTH = 32) (
    input wire sel,
    input wire  [WIDTH - 1:0] in1,
    input wire  [WIDTH - 1:0] in2,
    output wire [WIDTH - 1:0] out,
);
  always@(*) begin
      case(sel)
      1'b0: out <= in1;
      1'b1: out <= in2;
      endcase
  end  
endmodule