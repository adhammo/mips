module branch_logic (
  input valid,
  input z, n, c,
  input [2:0] branch,
  output reg jump
);

  parameter JMP = 3'b100;
  parameter  JZ = 3'b101;
  parameter  JN = 3'b110;
  parameter  JC = 3'b111;

  always @(*) begin
    // default: no jump
    jump = 1'b0;
    
    // check if valid
    if (valid) begin
      // calculate jump
      case (branch)
        JMP: jump = 1'b1;
        JZ: jump = z;
        JN: jump = n;
        JC: jump = c;
      endcase
    end
  end

endmodule