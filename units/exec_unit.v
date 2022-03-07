`include "alsu/alsu.v"
module exec_unit (
  input skip,
  input [15:0] a, b,
  input [2:0] func,
  output wire [15:0] ra,
  output wire c, z, n
);

  wire [15:0] r;

  // Exec output (skip)
  assign ra = !skip ? r : a;

  // ALSU
  alsu alu(.a(a), .b(b),
           .func(func),
           .r(r),
           .c(c), .z(z), .n(n));
  
endmodule