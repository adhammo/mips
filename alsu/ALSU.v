module ALSU (R, Z, N, C, A, B, FUNC);

parameter DATAWIDTH = 16;
parameter FUNCBITS = 3;

output reg [DATAWIDTH - 1: 0] R;
output reg Z, N, C;
input  wire [DATAWIDTH - 1: 0] A;
input  wire [DATAWIDTH - 1: 0] B;
input  wire [FUNCBITS - 1: 0] FUNC;

parameter ADD = 3'b000;
parameter SUB = 3'b001;
parameter SHL = 3'b010;
parameter SHR = 3'b011;
parameter AND = 3'b100;
parameter XOR = 3'b101;
parameter NOT = 3'b110;
parameter INC = 3'b111;

initial 
    begin
        Z = 1'b0;
        N = 1'b0; 
        C = 1'b0; 
        R = {(DATAWIDTH){1'bx}};      
    end

always@(*)
    begin
       case(FUNC)

       ADD: 
        begin
           {C, R} = A + B;
        end
       SUB: 
        begin
           {C, R} = A + ~B + 1'b1;
        end
       SHL: 
        begin
           {C, R} = A << 1'b1;
        end
       SHR: 
        begin
           {C, R} = A >> 1'b1;
        end
       AND: 
        begin
            R = A & B;
            C = 1'b0;
        end
       XOR: 
        begin
                R = A ^ B;
                C = 1'b0;
        end
       NOT: 
        begin
            R = ~A;
            C = 1'b0;
        end
       INC: 
        begin
           {C, R} = A + 1'b1;
        end
       default:
        begin//IF R = 0 , Z = 1?
           R = {(DATAWIDTH){1'bx}};
        end
    end
    
assign Z = (R == {(DATAWIDTH){1'b0}});
assign N = R[DATAWIDTH - 1];

endmodule