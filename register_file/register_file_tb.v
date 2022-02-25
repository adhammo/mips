module register_file_tb;

  reg clock, reset;
  reg write;
  reg [2:0] wreg, rreg1, rreg2;
  reg [15:0] in;
  wire [15:0] out1, out2;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  
    // init
    clock = 0;
    reset = 1;
    write = 0;

    // reset
    reset = 0; #6;

    // clk 1
    reset = 1;
    in = {8{2'b10}};
    wreg = 3;
    write = 1; // write reg3
    #10;

    // clk 2
    write = 0;
    rreg1 = 3;
    #10;

    // clk 3
    if (out1 != in) // check output1
      $display("Failed to write/rreg1");
    in = {8{2'b01}};
    wreg = 5;
    write = 1; // write reg5
    #10;

    // clk 4
    write = 0;
    rreg2 = 5;
    #10;

    // clk 4
    if (out2 != in) // check output2
      $display("Failed to write/rreg2");
    reset = 0; // reset
    #10;

    // clk 5
    reset = 1;
    if (out1 != 16'b0 || out2 != 16'b0) // check output1 and output2
      $display("Failed to reset");

    #8 $finish;
  end

  always #5 clock = ~clock;

  register_file regi_file(.clock(clock), .reset(reset),
                          .write(write),
                          .wreg(wreg), .rreg1(rreg1), .rreg2(rreg2),
                          .wd(in),
                          .rd1(out1), .rd2(out2));

endmodule