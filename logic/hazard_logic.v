module hazard_logic (
  input ex_valid,
  input ex_load,
  input [6:0] opcode,
  input [2:0] rsrc1, rsrc2,
  input [2:0] ex_rdst,
  output reg stallD
);

  always @(*) begin
    // default: no stall
    stallD = 1'b0;

    // check if valid and load
    if (ex_valid && ex_load) begin
      // stall decode (if needed)
      if (rsrc1 == ex_rdst && rsrc2 == ex_rdst) begin
        // needs both sources
        casez (opcode)
          7'b0100101: stallD = 1'b1; // AND
          7'b0100110: stallD = 1'b1; // ORR
          7'b0100000: stallD = 1'b1; // ADD
          7'b0100001: stallD = 1'b1; // SUB
          7'b1011???: stallD = 1'b1; // STD
        endcase
      end else if (rsrc1 == ex_rdst) begin
        // needs only first source
        casez (opcode)
          7'b00100??: stallD = 1'b1; // OUT
          7'b0100111: stallD = 1'b1; // NOT
          7'b0100010: stallD = 1'b1; // INC
          7'b0100011: stallD = 1'b1; // SHL
          7'b0100100: stallD = 1'b1; // SHR
          7'b0110???: stallD = 1'b1; // MOV
          7'b0101000: stallD = 1'b1; // IADD
          7'b1010???: stallD = 1'b1; // LDD
        endcase
      end else if (rsrc2 == ex_rdst) begin
        // needs only second source
        casez (opcode)
          7'b1000???: stallD = 1'b1; // PUSH
        endcase
      end
    end
  end

endmodule