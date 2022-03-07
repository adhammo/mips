module flags (
    input wire clk, ld,
    input wire sc,
    input wire [2:0] znc,
    output reg z,n,c
);
  always@(posedge clk) begin
    if(ld)
        {z,n,c} <= znc;
    if(sc)
        c <= 1'b1; 
  end  
endmodule