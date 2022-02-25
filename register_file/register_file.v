`include "../registers/register_2oe.v"
module register_file (
  input clock, reset,
  input write,
  input [2:0] wreg, rreg1, rreg2,
  input [15:0] wd,
  output wire [15:0] rd1, rd2
);

  reg [7:0] loads;
  reg [7:0] enables1;
  reg [7:0] enables2;

  // Loads and enables decoders
  always @(*) begin
    // decode rd1 enable
    enables1 = 8'b0;
    enables1[rreg1] = 1'b1;
    
    // decode rd2 enable
    enables2 = 8'b0;
    enables2[rreg2] = 1'b1;
    
    // decode wd load
    loads = 8'b0;
    if (write)
      loads[wreg] = 1'b1;
  end
  
  // Generate x8 16-bit registers
  genvar i;
  generate
    for (i=0; i<8; i=i+1) begin : generate_registers
      register_2oe #(.WIDTH(16)) regi_2oe(.clock(clock), .reset(reset),
                                          .load(loads[i]), .enable1(enables1[i]), .enable2(enables2[i]),
                                          .in(wd), 
                                          .out1(rd1), .out2(rd2));
    end 
  endgenerate

endmodule