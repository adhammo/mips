module control_logic (
  input [6:0] opcode,
  output wire [2:0] branch,
  output wire setC, load,
  output wire imm1, imm2,
  output wire skipE,
  output wire [2:0] func,
  output wire skipM, push, pop, wr,
  output wire skipW
);

  // Control Code
  reg [15:0] code;

  // Control Signals Extraction
  assign {branch, setC, load,
          imm1, imm2,
          skipE, func,
          skipM, push, pop, wr,
          skipW} = code;

  // Control Code Lookup
  always @(*) begin
    case (opcode)
      7'b0000000: code = 16'b0000000100010001; // NOP
      7'b0000100: code = 16'b0000000100010001; // HLT
      7'b0001000: code = 16'b0000000100010001; // RESET
      7'b0001100: code = 16'b0001000100010001; // SETC
      7'b0010000: code = 16'b0000000100010000; // IN
      7'b0010100: code = 16'b0000000100010001; // OUT
      7'b0100101: code = 16'b0000000010110000; // AND
      7'b0100110: code = 16'b0000000011010000; // ORR
      7'b0100111: code = 16'b0000000011110000; // NOT
      7'b0100000: code = 16'b0000000000010000; // ADD
      7'b0101000: code = 16'b0000001000010000; // IADD
      7'b0100001: code = 16'b0000000000110000; // SUB
      7'b0100010: code = 16'b0000000001010000; // INC
      7'b0100011: code = 16'b0000000001110000; // SHL
      7'b0100100: code = 16'b0000000010010000; // SHR
      7'b0110000: code = 16'b0000000100010000; // MOV
      7'b0111000: code = 16'b0000010100010000; // LDM
      7'b1000000: code = 16'b0000000100001011; // PUSH
      7'b1001000: code = 16'b0000000100000100; // POP
      7'b1010000: code = 16'b0000101000000000; // LDD
      7'b1011000: code = 16'b0000001000000011; // STD
      7'b1100000: code = 16'b1010000100010001; // JZ
      7'b1100100: code = 16'b1100000100010001; // JN
      7'b1101000: code = 16'b1110000100010001; // JC
      7'b1101100: code = 16'b1000000100010001; // JMP
      7'b1110000: code = 16'b0000000100010001; // CALL
      7'b1110100: code = 16'b0000000100010001; // RET
      7'b1111000: code = 16'b0000000100010001; // INT
      7'b1111100: code = 16'b0000000100010001; // RTI
      default: code = 16'b0000000100010001;
    endcase
  end

endmodule