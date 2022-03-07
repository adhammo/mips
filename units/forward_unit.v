module forward_unit (
    input wire  en_me, en_wb,
    input wire  [2:0] rsrc1, rsrc2,
    input wire  [2:0] me_rdst, wb_rdst,
    output reg [1:0] fwd1, fwd2
);
    
always @(*) begin
    if((rsrc1 == me_rdst) && !en_me)
        fwd1 <= 2'b01;
    else if((rsrc1 == wb_rdst) && !en_wb)
        fwd1 <= 2'b10;
    else
        fwd1 <= 2'b00;

    if((rsrc2 == me_rdst) && !en_me)
        fwd2 <= 2'b01;
    else if((rsrc2 == wb_rdst) && !en_wb)
        fwd2 <= 2'b10;
    else
        fwd2 <= 2'b00;
end

endmodule