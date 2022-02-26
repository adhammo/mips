module register_oe_tb;
  
  parameter WIDTH=4;
  
  reg clock, reset;
  reg load, enable1, enable2;
  reg [WIDTH-1:0] in;
  wire [WIDTH-1:0] out1, out2;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  
    // init
    clock = 0;
    reset = 1;
    load = 0;
    enable1 = 0;
    enable2 = 0;
    in = {(WIDTH/2){2'b10}};

    // reset
    reset = 0; #6;

    // clk 1
    reset = 1;
    load = 1; // load input
    #10;

    // clk 2
    load = 0;
    enable1 = 1; // enable output1
    #10;

    // clk 3
    if (out1 != in) // check output1
      $display("Failed to load/enable1");
    enable1 = 0;
    enable2 = 1; // enable output2
    #10;

    // clk 4
    if (out2 != in) // check output2
      $display("Failed to load/enable2");
    enable2 = 0;
    reset = 0; // reset
    #10;

    // clk 5
    reset = 1;
    enable1 = 1; // enable output1
    #10;

    // clk 6
    if (out1 != {WIDTH{1'b0}}) // check output1
      $display("Failed to reset");
    enable1 = 0;
    
    #8 $finish;
  end

  always #5 clock = ~clock;

  register_2oe #(.WIDTH(WIDTH)) regi_2oe(.clock(clock), .reset(reset),
                                         .load(load), .enable1(enable1), .enable2(enable2),
                                         .in(in), 
                                         .out1(out1), .out2(out2));

endmodule