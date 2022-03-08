module mips;

 initial begin
    $readmemh("testCode.txt",instrMemory.mem); 
  end

    reg clk, rst;
    
    reg keepF, keepD, keepE, keepM, keepW;
    reg dirtyF, dirtyD, dirtyE, dirtyM, dirtyW;
    
    wire jump;
    wire [31:0] pc, pc_in, target, pc_plus4, sp, sp_in;
    wire [31:0] instr, instrD;

    wire stallD;
    
    //pipeline registers
    wire [63:0] if_id;
    wire [104:0] id_ex;
    wire [88:0] ex_me;
    wire [68:0] me_wb;
    
    //
    wire [2:0] ex_rdst;
    wire ex_load;
    //WB signals
    wire [15:0] rData1, rData2;
    //CU signals
    wire skipW, skipM, skipE, push, pop, wr, imm1, imm2, load, setC;
    wire [2:0] func, branch;
    //EU & ME signals
    wire z,n,c;
    wire ZF, NF, CF;
    wire [2:0] znc;
    wire [1:0] fwd1, fwd2;
    reg  [15:0] a, b, s1, s2;
    wire [15:0] r_s1;
    wire [15:0] r, do, wd;
    wire [31:0] addr;

    initial begin
      dirtyF = 1'b1;
      dirtyD = 1'b1;
      dirtyE = 1'b1;
      dirtyW = 1'b1;
      dirtyM = 1'b1;

      keepF  = 1'b0;
      keepD  = 1'b0;
      keepE  = 1'b0;
      keepM  = 1'b0;
      keepW  = 1'b0;

      rst    = 1'b0;
      clk    = 1'b0;

      #200 
      rst    = 1'b1;
    end

    always #100 clk = ~clk;



    //Fetch Stage Instantiation
    register #(.WIDTH(32)) PC(.clk(clk), .rst(rst), .load(!keepF), 
                              .in(pc_in), .out(pc));

    fetch_unit FU(.clk(clk), .pc(pc), .instr(instr));



    register  #(.WIDTH(64)) IF_ID(.clk(clk), .rst(rst), .load(!keepD),
                                  .in({instr, pc}), .out(if_id));

    //Decode Stage Instantiation
    // decode_unit DU(.instr(instrD), .ex_rdst(id_ex[34:32]), .enable(!dirtyE), 
    //             .ex_ld(id_ex[100]), .stallD(stallD));
                
    register_file RegFile(.clk(clk), .rst(rst), .wd(wd),
                          .wreg(me_wb[34:32]), .rreg1(instrD[12:10]), .rd1(rData1),
                          .rreg2(instrD[15:13]), .rd2(rData2), .write(!me_wb[67] & !dirtyW));



    control_unit CU(.opcode(instrD[6:0]), .wb_cntrl(skipW), .me_cntrl({wr, pop, push, skipM}),
                    .ex_cntrl({func, skipE}), .instr_id_srcs({branch, setC, load, imm2, imm1}));

    register  #(.WIDTH(105)) ID_EX(.clk(clk), .rst(rst), .load(!keepE),
                .in({branch, setC, load, imm2, imm1, instrD[15:13], instrD[12:10], func, skipE, wr,
                pop, push, skipM, skipW,
                instrD[15:0], rData2, rData1, instrD[9:7], if_id[31:0]}), .out(id_ex));
    


    //Execute Stage Instantiation
    exec_unit EU(.a(a), .b(b), .func(id_ex[91:89]), 
                 .r(r), .c(c), .n(n),  .z(z));

    flags FlagRegister(.clk(clk), .ld(!dirtyE), .sc(id_ex[101]), .znc(znc), .z(ZF), .n(NF), .c(CF));

    forward_unit FwdU(.en_me(!dirtyM), .en_wb(!dirtyW), .rsrc1(id_ex[94:92]), .rsrc2(id_ex[97:95]),
                .me_rdst(ex_me[34:32]), .wb_rdst(me_wb[34:32]), .fwd1(fwd1), .fwd2(fwd2));

    branch_unit BU(.enable(!dirtyE), .z(ZF), .n(NF), .c(CF),
                .jump(jump), .branch(id_ex[104:102]));
    


    register  #(.WIDTH(89)) EX_ME(.clk(clk), .rst(rst), .load(~keepM),
                .in({id_ex[88:83], s2, r, s1, id_ex[34:0]}), .out(ex_me)); 
    //Memory Stage Instantiation    
    mem_unit MU(.clk(clk), .wr(ex_me[87]), .dirty(dirtyM), .skip(ex_me[84]),
            .addr(addr), .di(ex_me[82:67]), .do(do));
    register #(.WIDTH(32)) SP(.clk(clk), .rst(rst),
            .load((ex_me[85] || ex_me[86]) && !(dirtyM || ex_me[84])), 
            .in(sp_in), .out(sp));
    register  #(.WIDTH(69)) ME_WB(.clk(clk), .rst(rst), .load(!keepW),
                .in({ex_me[84:83], do, r_s1, ex_me[34:0]}), .out(me_wb)); 

    always @(posedge clk) begin
      dirtyF <= 1'b0;
      dirtyD <= dirtyF;
      dirtyE <= dirtyD;
      dirtyM <= dirtyE;
      dirtyW <= dirtyM;
    end

    //PC input mux
    assign pc_in = jump? target : (pc + 32'd4);
    //IF_ID register
    assign instrD = if_id[63:32];
    //Branch target
    assign target = id_ex[31:0] + {{16{id_ex[82]}}, id_ex[82:67]} << 2; 
    //ALU sources muxes
    always @(fwd1, id_ex, wd, r_s1) begin
        case(id_ex[98])
        1'b0: begin
            case(fwd1)
            2'b00: s1 = id_ex[50:35]; //Rd1
            2'b01: s1 = r_s1; //R/S1 
            2'b10: s1 = wd; //R/S1 
            2'b11: s1 = id_ex[50:35]; //Rd1 
            endcase
            a = s1;
        end
        1'b1: a = id_ex[82:67]; // Imm/Off
        endcase
    end
    always @(fwd2, id_ex, wd, r_s1) begin
        case(id_ex[99])
        1'b0: begin
            case(fwd2)
            2'b00: s2 = id_ex[66:51]; //Rd2
            2'b01: s2 = r_s1; //R/S1 
            2'b10: s2 = wd; //R/S1 
            2'b11: s2 = id_ex[66:51]; //Rd2
            endcase
            b = s2;
        end
        1'b1: b = id_ex[82:67];
        endcase
    end
    //ZNC signals
    assign znc = !skipE? {z,n,c} : 3'b0;
    //Memory signals
    assign r_s1 = ex_me[88] ? ex_me[50:35] : ex_me[66:51];
    assign addr = (ex_me[85] || ex_me[86])?  (ex_me[86]? sp + 32'd2 : sp): ex_me[66:51];
    //SP input mux
    assign sp_in = ex_me[85]? sp - 2'd2 : sp + 2'd2;
    //WB output mux
    assign wd = me_wb[68]? me_wb[50:34] : me_wb[66:51];


endmodule