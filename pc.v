module pc(OUT, IN, LD, INCR, RST, CLK);

parameter  DATAWIDTH = 32;

output reg [DATAWIDTH - 1: 0] OUT;

input wire [DATAWIDTH - 1: 0] IN;
input wire INCR, LD, RST, CLK;


always @(posedge CLK, negedge RST, posedge LD)
    begin
        if(!RST)
            OUT <= 32'b0;
        else if(LD)
            OUT <= IN;
        else
            begin
                if(INCR)
                    OUT <= OUT + 1'b1;
            end
    end
endmodule