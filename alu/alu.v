module alsu (
  input [2:0] func,
  input [15:0] a, b,
  output reg [15:0] r,
  output reg z, n, c
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
    // calculate result and carry
    case (func)
      ADD: {c, r} = a + b;
      SUB: {c, r} = a - b;
      INC: {c, r} = a + 1'b1;
      SHL: {c, r} = {a[15], a << 1'b1};
      SHR: {c, r} = {a[0], a >> 1'b1};
      AND: {c, r} = {1'b0, a & b};
      ORR: {c, r} = {1'b0, a | b};
      NOT: {c, r} = {1'b0, ~a};
      default: {c, r} = 17'b0;
    endcase

    // calculate zero and negative flags
    z = (r == 16'b0);
    n = r[15];
  end

endmodule