module branch_unit (
    input wire z, n, c, enable,
    input wire [2:0] branch,
    output reg jump
);

always @(*) begin
    if(!enable) begin
        case(branch)
        3'b0xx: jump <= 1'b0;
        3'b100: jump <= 1'b1;
        3'b101: jump <= z;
        3'b110: jump <= n;
        3'b111: jump <= c;
        default: jump <= 1'b0;
        endcase
    end
end
endmodule