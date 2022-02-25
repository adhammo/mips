module signExtend (OUT, IN);

parameter DATAWIDTH = 32;

output wire [DATAWIDTH - 1: 0] OUT;

input wire [DATAWIDTH/2 - 1: 0] IN;
    
assign OUT = { {(DATAWIDTH/2) {IN[DATAWIDTH/2 - 1]}}, IN[DATAWIDTH/2 - 1: 0]};

endmodule