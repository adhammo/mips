module decode_unit (
  input [31:0] instr,
  output wire [6:0] opcode,
  output wire [2:0] rdst, rsrc1, rsrc2,
  output wire [15:0] imm
);

  // Instruction Extraction
  assign {opcode, rdst, rsrc1, rsrc2, imm} = instr;

endmodule