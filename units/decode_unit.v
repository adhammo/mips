module decode_unit(
    input wire [31:0] instr,
    input wire [2:0] ex_rdst,
    input wire enable, ex_ld,
    output reg stallD
);

always @(*) begin
    stallD <= 1'b0;
    if(enable)
        if(instr[6:0] == 7'b1011000 || instr[6:0] == 7'b01xxxxx)
            if(ex_ld && (ex_rdst == instr[12:10] || ex_rdst == instr[15:13]))
                stallD <= 1'b1; 
end
endmodule