module moduleName (OUT, IN, ADDR, OE, WE, RST, CLK);

parameter DATAWIDTH = 16;
parameter ADDRBUS   = 20;

output reg [DATAWIDTH - 1: 0] OUT;

input wire [DATAWIDTH - 1: 0] IN;
input wire [ADDRBUS   - 1: 0] ADDR;
input wire OE, WE, CLK, RST;
    
reg [DATAWIDTH - 1: 0] mem[2**ADDRBUS - 1: 0];
integer i;

always @(posedge CLK, negedge RST)
    begin
        if(!RST)
            for(i = 20'b0; i < 2**ADDRBUS - 1; i = i + 1'b1)
                mem[i] <= {(DATAWIDTH){1'b0}};
        else
        begin
            if(!WE) //Write active low
                mem[ADDR] <= IN;            
        end
    end

always@(*)
    begin 
        if(!OE)
            OUT <= mem[ADDR]; 
        else 
            OUT <= {(DATAWIDTH){1'bz}};
    end
endmodule