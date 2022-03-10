module register_file (
  input clk, rst,
  input write,
  input [2:0] wreg, rreg1, rreg2,
  input [15:0] wd,
  output wire [15:0] rd1, rd2
);

  integer i;

  // Register File
  reg [15:0] regfile[0:7];

  // Async Read (with forwarding)
  assign rd1 = (write && rreg1 == wreg) ? wd : regfile[rreg1];
  assign rd2 = (write && rreg2 == wreg) ? wd : regfile[rreg2];

  // Sync Write and Async Reset
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      // reset register file
      for (i = 0; i < 8; i = i + 1)
        regfile[i] <= 16'b0;
    end else if (write) begin
      // write to register file
      regfile[wreg] <= wd;
    end
  end

endmodule