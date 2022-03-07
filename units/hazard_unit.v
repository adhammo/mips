module hazard_unit (
    input wire opcode, enable, ex_ld
    input wire [2:0] rsrc1, rsrc2, ex_rdst
    output wire stallD 
);

always @(*) begin
    if(!enable) begin
        stallD = 1'b0;
        if(ex_ld)
            if(ex_rdst == rsrc1 || ex_rdst == rsrc2)
                stallD = 1'b1;
    end
end    
endmodule