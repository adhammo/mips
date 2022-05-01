module control_logic (
  input [6:0] opcode,
  output wire hlt,
  output wire call, int, ret,
  output wire [2:0] branch,
  output wire setC, load,
  output wire in, out,
  output wire imm1, imm2,
  output wire skipE,
  output wire [2:0] func,
  output wire skipM, push, pop, wr,
  output wire skipW
);

  // Control Code
  reg [21:0] code;

  // Control Signals Extraction
  assign {hlt,
          call, int, ret,
          branch, setC, load, in, out,
          imm1, imm2,
          skipE, func,
          skipM, push, pop, wr,
          skipW} = code;

  // Control Code Lookup
  always @(*) begin
    casez (opcode)
      7'b00000??: code = 22'b0000000000000100010001; // NOP
      7'b00001??: code = 22'b1000000000000100010001; // HLT
      7'b00010??: code = 22'b0000000100000100010001; // SETC
      7'b00011??: code = 22'b0000000001000100010000; // IN
      7'b00100??: code = 22'b0000000000100100010001; // OUT
      7'b0100101: code = 22'b0000000000000010110000; // AND
      7'b0100110: code = 22'b0000000000000011010000; // ORR
      7'b0100111: code = 22'b0000000000000011110000; // NOT
      7'b0100000: code = 22'b0000000000000000010000; // ADD
      7'b0101000: code = 22'b0000000000001000010000; // IADD
      7'b0100001: code = 22'b0000000000000000110000; // SUB
      7'b0100010: code = 22'b0000000000000001010000; // INC
      7'b0100011: code = 22'b0000000000000001110000; // SHL
      7'b0100100: code = 22'b0000000000000010010000; // SHR
      7'b0110???: code = 22'b0000000000000100010000; // MOV
      7'b0111???: code = 22'b0000000000010100010000; // LDM
      7'b1000???: code = 22'b0000000000000100001011; // PUSH
      7'b1001???: code = 22'b0000000000000100000100; // POP
      7'b1010???: code = 22'b0000000010001000000000; // LDD
      7'b1011???: code = 22'b0000000000001000000011; // STD
      7'b11000??: code = 22'b0000101000000100010001; // JZ
      7'b11001??: code = 22'b0000110000000100010001; // JN
      7'b11010??: code = 22'b0000111000000100010001; // JC
      7'b11011??: code = 22'b0000100000000100010001; // JMP
      7'b11100??: code = 22'b0100000000000100001011; // CALL
      7'b11101??: code = 22'b0001000000000100000101; // RET
      7'b11110??: code = 22'b0010000000010100001011; // INT
      7'b11111??: code = 22'b0001000000000100000101; // RTI
      default: code = 22'b0000000000000100010001;
    endcase
  end

endmodule