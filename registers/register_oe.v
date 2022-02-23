module register_oe #(parameter WIDTH=8) (
  input clock, reset,
  input load, enable,
  input [WIDTH-1:0] in,
  output wire [WIDTH-1:0] out
);

  wire [WIDTH-1:0] internal;

  // Register
  register #(.WIDTH(WIDTH)) regi(.clock(clock), .reset(reset),
                                 .load(load),
                                 .in(in), 
                                 .out(internal));

  // Tri-state Buffer
  assign out = enable ? internal : {WIDTH{1'bz}}; // enable output

endmodule