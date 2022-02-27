module register_2oe #(parameter WIDTH=8) (
  input clk, rst,
  input load, enable1, enable2,
  input [WIDTH-1:0] in,
  output wire [WIDTH-1:0] out1, out2
);

  wire [WIDTH-1:0] internal;

  // Register
  register #(.WIDTH(WIDTH)) regi(.clk(clk), .rst(rst),
                                 .load(load),
                                 .in(in), 
                                 .out(internal));

  // Tri-state Buffers
  assign out1 = enable1 ? internal : {WIDTH{1'bz}}; // enable output1
  assign out2 = enable2 ? internal : {WIDTH{1'bz}}; // enable output2

endmodule