module register_tb;
  
  parameter WIDTH=4;
  
  reg clock, reset;
  reg load;
  reg [WIDTH-1:0] in;
  wire [WIDTH-1:0] out;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  
    // init
    clock = 0;
    reset = 1;
    load = 0;
    in = {(WIDTH/2){2'b10}};

    // reset
    reset = 0; #6;

    // clk 1
    reset = 1;
    load = 1; // load input
    #10;

    // clk 2
    load = 0;
    #10;

    // clk 3
    if (out != in) // check output
      $display("Failed to load/enable");
    reset = 0; // reset
    #10;

    // clk 4
    reset = 1;
    #10;

    // clk 5
    reset = 1;
    if (out != {WIDTH{1'b0}}) // check output
      $display("Failed to reset");
    
    #8 $finish;
  end

  always #5 clock = ~clock;

  register #(.WIDTH(WIDTH)) regi(.clock(clock), .reset(reset),
                                 .load(load),
                                 .in(in), 
                                 .out(out));

endmodule