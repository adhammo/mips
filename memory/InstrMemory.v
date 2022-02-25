module InstrMemory(DO, DI, ADDR, OE, WE, RST, CLK);
    
parameter DATAWIDTH = 16;
parameter ADDRBUS   = 20;

output reg [DATAWIDTH - 1: 0] DO;

input wire [DATAWIDTH - 1: 0] DI;
input wire [ADDRBUS   - 1: 0] ADDR;
input wire OE, WE, CLK, RST;
    
memory #(.DATAWIDTH(DATAWIDTH), .ADDRBUS(ADDRBUS)) DataMemory(
    .OUT(DO), .IN(DI),
     .ADDR(ADDR), .OE(1'b0),
      .WE(1'b1), .RST(RST),
       .CLK(CLK));
endmodule