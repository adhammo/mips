module alsu (
  input [15:0] a, b,
  input [2:0] func,
  output reg [15:0] r,
  output reg c,
  output wire z, n
);

  parameter ADD = 3'b000;
  parameter SUB = 3'b001;
  parameter INC = 3'b010;
  parameter SHL = 3'b011;
  parameter SHR = 3'b100;
  parameter AND = 3'b101;
  parameter ORR = 3'b110;
  parameter NOT = 3'b111;

  always @(*) begin
    {c, r} = 17'bx;
    case (func)
      ADD: {c, r} = a + b;
      SUB: {c, r} = a - b;
      INC: {c, r} = a + 1'b1;
      SHL: {c, r} = {a[15], a << 1'b1};
      SHR: {c, r} = {a[0], a >> 1'b1};
      AND: r = a & b;
      ORR: r = a | b;
      NOT: r = ~a;
    endcase
  end


  assign z = (r == 16'b0);
  assign n = r[15];

endmodule