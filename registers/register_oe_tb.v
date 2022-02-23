module register_oe_tb;
  
  parameter WIDTH=4;
  
  reg clock, reset;
  reg load, enable;
  reg [WIDTH-1:0] in;
  wire [WIDTH-1:0] out;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  
    // init
    clock = 0;
    reset = 1;
    load = 0;
    enable = 0;
    in = {(WIDTH/2){2'b10}};

    // reset
    reset = 0; #6;

    // clk 1
    reset = 1;
    load = 1; // load input
    #10;

    // clk 2
    load = 0;
    enable = 1; // enable output
    #10;

    // clk 3
    if (out != in) // check output
      $display("Failed to load/enable");
    enable = 0;
    reset = 0; // reset
    #10;

    // clk4
    reset = 1;
    enable = 1; // enable output
    #10;

    // clk 5
    if (out != {WIDTH{1'b0}}) // check output
      $display("Failed to reset");
    enable = 0;
    
    #8 $finish;
  end

  always #5 clock = ~clock;

  register_oe #(.WIDTH(WIDTH)) reg_oe1(.clock(clock), .reset(reset),
                                       .load(load), .enable(enable),
                                       .in(in), 
                                       .out(out));

endmodule