module register_oe #(parameter WIDTH=8) (
  input clk, rst,
  input load, enable,
  input [WIDTH-1:0] in,
  output wire [WIDTH-1:0] out
);

  wire [WIDTH-1:0] internal;

  // Register
  register #(.WIDTH(WIDTH)) regi(.clk(clk), .rst(rst),
                                 .load(load),
                                 .in(in), 
                                 .out(internal));

  // Tri-state Buffer
  assign out = enable ? internal : {WIDTH{1'bz}}; // enable output

endmodule