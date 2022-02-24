module shiftLeft (OUT, IN, DIRECTION);

parameter DATAWIDTH  = 16;
parameter NBITS      = 2;
parameter SHIFTLEFT  = 1'b1;


output wire [DATAWIDTH - 1: 0] OUT;
input  wire [DATAWIDTH - 1: 0] IN;
input  wire DIRECTION;

assign OUT = (DIRECTION == SHIFTLEFT)? (IN << NBITS): (IN >> NBITS);
endmodule