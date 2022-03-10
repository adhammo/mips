module exec_unit (
  input skip,
  input [2:0] func,
  input [15:0] a, b,
  output wire [15:0] r,
  output wire z, n, c
);

  // Flags Output (reset flags if skip)
  wire zo, no, co;
  assign z = !skip ? zo : 1'b0;
  assign n = !skip ? no : 1'b0;
  assign c = !skip ? co : 1'b0;

  // ALU
  alu alu (.func(func),
           .a(a), .b(b),
           .r(r),
           .z(zo), .n(no), .c(co));

endmodule