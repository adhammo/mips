module control_unit (
    input reg [6:0] opcode,
    output reg wb_cntrl,
    output reg [3:0] me_cntrl,
    output reg [3:0] ex_cntrl,
    output reg [6:0] instr_id_srcs
);

reg skipE, skipM, skipW, push, pop, wr;
reg setC, load, imm1, imm2;
reg [2:0] branch;
reg [2:0] func;


always @(*) begin
    skipE <= 1'b1;
    skipM <= 1'b1;
    skipW <= 1'b1;
    func <= 3'bx;
    push <= 1'bx;
    pop  <= 1'bx;
    wr   <= 1'bx;
    imm1 <= 1'bx;
    imm2 <= 1'bx;
    setC <= 1'b0;
    load <= 1'b0;
    branch <= 3'b0xx;

    casex(opcode)
    7'b0001100:  setC <= 1'b1; //SETC
    7'b0010100:  imm1 <= 1'b0; //OUT
    7'b010xxxx: begin // ALU instructions
        skipE <= 1'b0;
        skipW <= 1'b0;
        imm1  <= 1'b0;
        casex(opcode[3:0])
        4'd0: begin
            func <= 3'd0; //ADD
            imm2 <= 1'b0;
        end
        4'd8: begin
            func <= 3'd0; //ADDI
            imm2 <= 1'b1;
        end
        4'd1: begin
            func <= 3'd1; //SUB
            imm2 <= 1'b0; 
        end
        4'd2: func <= 3'd2; //INC
        4'd3: func <= 3'd3; //SHL
        4'd4: func <= 3'd4; //SHR
        4'd5: begin
            func <= 3'd5; //AND
            imm2 <= 1'b0;
        end
        4'd6: begin 
            func <= 3'd6; //ORR
            imm2 <= 1'b0;
        end
        4'd7: func <= 3'd7; //NOT
        endcase
    end
    7'b011x000: begin //MOV, LDM
        skipW <= 1'b0;
        imm1  <= opcode[3];
    end
    7'b100x000: begin //Push, POP
        skipM <= 1'b0;
        wr    <= ~opcode[3];
        pop   <= opcode[3];
        push  <= ~opcode[3];
        skipW <= ~opcode[3];
        imm2  <= opcode[3];
    end
    7'b101x000: begin//LDD, STD
        skipE <= 1'b0;
        skipM <= 1'b0;
        push  <= 1'b0;
        pop   <= 1'b0;
        wr    <= opcode[3];
        skipW <= opcode[3];
        imm1  <= 1'b0;
        imm2  <= 1'b1;
        load  <= ~opcode[3];
    end
    7'b110xxxx: begin//Jump
        case(opcode[3:2])
        2'b00: branch <= 3'b101; //JZ
        2'b01: branch <= 3'b110; //JN
        2'b10: branch <= 3'b111; //JC
        2'b11: branch <= 3'b100; //JMP
        endcase
    end
    default: begin
        skipE <= 1'b1;
        skipM <= 1'b1;
        skipW <= 1'b1;
        func <= 3'bx;
        push <= 1'bx;
        pop  <= 1'bx;
        wr   <= 1'bx;
        imm1 <= 1'bx;
        imm2 <= 1'bx;
        setC <= 1'b0;
        load <= 1'b0;
        branch <= 3'b0xx;
    end
    endcase
    
    wb_cntrl <= skipW;
    me_cntrl <= {wr, pop, push, skipM};
    ex_cntrl <= {func, skipE};
    instr_id_srcs <= {branch, setC, load, imm2, imm1};
end
endmodule