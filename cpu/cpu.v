module cpu (
  input clk, rst, 
  input [15:0] in_port,
  output wire [15:0] out_port
);

  // ##### Parameters #####

  // Fetch
  parameter RSTSRC   = 2'b00;
  parameter EXPT1SRC = 2'b01;
  parameter EXPT2SRC = 2'b10;
  parameter INTSRC   = 2'b11;

  // Forward
  parameter MEF = 2'b10;
  parameter WBF = 2'b11;
  
  // ##### Signals #####

  // Keep and Dirty
  wire keepF, keepD, keepE, keepM, keepW;
  wire dirtyF, dirtyD, dirtyE, dirtyM, dirtyW;

  // ===== Fetch =====
  // -- Inputs
  wire [31:0] pc;

  // -- Fetch Control Outputs
  wire extendF;
  wire fetch;
  wire [1:0] fetchSrc;

  // -- Outputs
  // Fetch
  wire [31:0] instr;

  // ===== Decode ====
  // -- Inputs
  wire [31:0] id_pc, id_instr;

  // -- IN Register Output
  wire [15:0] inputData;

  // -- Outputs
  // Decode
  wire [6:0] opcode;
  wire [2:0] rdst, rsrc1, rsrc2;
  wire [15:0] imm;
  // Register File
  wire [15:0] rd1, rd2;
  // Control
  wire hlt;
  wire call, int, ret;
  wire [2:0] branch;
  wire setC, load;
  wire in, out;
  wire imm1, imm2;
  wire skipE;
  wire [2:0] func;
  wire skipM, push, pop, wr;
  wire skipW;
  // Hazard
  wire stallD;

  // ===== Exec ======
  // -- Inputs
  wire [31:0] ex_pc;
  wire [2:0] ex_rdst, ex_rsrc1, ex_rsrc2;
  wire [15:0] ex_rd1, ex_rd2, ex_imm, ex_input;
  wire ex_hlt;
  wire ex_call, ex_int, ex_ret;
  wire [2:0] ex_branch;
  wire ex_setC, ex_load;
  wire ex_in, ex_out;
  wire ex_imm1, ex_imm2;
  wire ex_skipE;
  wire [2:0] ex_func;
  wire ex_skipM, ex_push, ex_pop, ex_wr;
  wire ex_skipW;

  // -- Halt Register Output
  wire halted;
  wire stallE;

  // -- Flags Register Output
  wire z, n, c;

  // -- Outputs
  // Forward
  wire [1:0] fwd1, fwd2;
  reg [15:0] s1, s2;
  // ALU
  wire [15:0] r;
  wire zo, no, co;
  // Branch
  wire flushD;
  wire jump;
  wire [31:0] target;

  // ===== Memory ====
  // -- Inputs
  wire [31:0] me_pc;
  wire [2:0] me_rdst;
  wire [15:0] me_s1, me_r, me_s2;
  wire [31:0] me_target;
  wire me_call, me_int, me_ret;
  wire me_out;
  wire me_skipE;
  wire me_skipM, me_push, me_pop, me_wr;
  wire me_skipW;

  // -- Memory Control Outputs
  wire extendM;
  wire offset;

  // -- SP Register Output
  wire [31:0] sp;

  // -- Outputs
  // Skip Execute
  wire [15:0] r_s1;
  // Memory
  wire [15:0] do;
  // Memory Exception
  wire [31:0] epc;
  wire flushM;
  wire memExpt, memExpt1, memExpt2;
  // Memory Jump
  wire flushE;
  wire memJump, memInt;
  wire [31:0] memTarget;

  // ===== Write =====
  // -- Inputs
  wire [31:0] wb_pc;
  wire [2:0] wb_rdst;
  wire [15:0] wb_r_s1, wb_do;
  wire wb_out;
  wire wb_skipM;
  wire wb_skipW;

  // -- Outputs
  // Write Data
  wire [15:0] wd;

  // ##### Stages #####
  
  // ===== Fetch =====

  // PC Input
  reg [31:0] pc_in;
  always @(*) begin
    // calculate pc input
    if (jump) pc_in = target;
    else if (memJump) pc_in = memTarget;
    else if (fetch) pc_in = instr;
    else pc_in = 32'b0;
  end
 
  // PC Register
  pc_reg pc_reg (.clk(clk), .rst(rst),
                 .enable(!keepF || fetch),
                 .load(fetch || jump || memJump),
                 .in(pc_in),
                 .pc(pc));

  // Instruction Address
  reg [31:0] instrAddr;
  always @(*) begin
    // calculate fetch address
    if (fetch) begin
      case (fetchSrc)
        RSTSRC:   instrAddr = 32'd0;
        EXPT1SRC: instrAddr = 32'd4;
        EXPT2SRC: instrAddr = 32'd8;
        INTSRC:   instrAddr = 32'd12 + ({16'b0, wb_r_s1} << 2);
      endcase
    end else instrAddr = pc;
  end

  // Fetch Unit
  fetch_unit fetch_unit (.clk(clk),
                         .addr(instrAddr),
                         .instr(instr));

  // Fetch Control
  fetch_control fetch_control (.clk(clk), .rst(rst),
                               .valid(!dirtyF), .flush(flushD || flushE || flushM),
                               .int(memInt), .expt1(memExpt1), .expt2(memExpt2),
                               .extend(extendF),
                               .fetch(fetch),
                               .fetchSrc(fetchSrc));

  // ===== Decode ====

  // IF/ID Register
  wire [63:0] if_id_in, if_id_out;
  assign if_id_in = {instr, pc};
  assign {id_instr, id_pc} = if_id_out;
  stage_reg #(.WIDTH(64)) if_id_reg (.clk(clk), .rst(rst),
                                     .keep(keepD),
                                     .in(if_id_in),
                                     .out(if_id_out));

  // Decode Unit
  decode_unit decode_unit (.instr(id_instr),
                           .opcode(opcode),
                           .rdst(rdst), .rsrc1(rsrc1), .rsrc2(rsrc2),
                           .imm(imm));

  // Read/Write Unit
  rd_wr_unit rd_wr_unit (.clk(clk), .rst(rst),
                         .dirty(dirtyW), .skip(wb_skipW),
                         .wreg(wb_rdst), .rreg1(rsrc1), .rreg2(rsrc2),
                         .wd(wd),
                         .rd1(rd1), .rd2(rd2));
                         
  // IN Register
  in_reg in_reg (.clk(clk), .rst(rst),
                 .in_port(in_port),
                 .in(inputData));

  // OUT Register
  out_reg out_reg (.clk(clk), .rst(rst),
                   .enable(wb_out),
                   .out(wd),
                   .out_port(out_port));

  // Control Logic
  control_logic control_logic (.opcode(opcode),
                               .hlt(hlt),
                               .int(int), .call(call), .ret(ret),
                               .branch(branch),
                               .setC(setC), .load(load),
                               .in(in), .out(out),
                               .imm1(imm1), .imm2(imm2),
                               .skipE(skipE),
                               .func(func),
                               .skipM(skipM), .push(push), .pop(pop), .wr(wr),
                               .skipW(skipW));

  // Hazard Logic
  hazard_logic hazard_logic (.ex_valid(!dirtyE),
                             .ex_load(ex_load),
                             .opcode(opcode),
                             .rsrc1(rsrc1), .rsrc2(rsrc2),
                             .ex_rdst(ex_rdst),
                             .stallD(stallD));

  // ===== Exec ======

  // ID/EX Register
  wire [126:0] id_ex_in, id_ex_out;
  assign id_ex_in = {hlt, call, int, ret, branch, setC, load, in, out,
                     imm1, imm2, rsrc1, rsrc2,
                     skipE, func, skipM, push, pop, wr, skipW,
                     inputData, imm, rd2, rd1, rdst, id_pc};
  assign {ex_hlt, ex_call, ex_int, ex_ret, ex_branch, ex_setC, ex_load, ex_in, ex_out,
          ex_imm1, ex_imm2, ex_rsrc1, ex_rsrc2,
          ex_skipE, ex_func, ex_skipM, ex_push, ex_pop, ex_wr, ex_skipW,
          ex_input, ex_imm, ex_rd2, ex_rd1, ex_rdst, ex_pc} = id_ex_out;
  stage_reg #(.WIDTH(127)) id_ex_reg (.clk(clk), .rst(rst),
                                      .keep(keepE),
                                      .in(id_ex_in),
                                      .out(id_ex_out));

  // Forward Logic
  forward_logic forward_logic (.me_valid(!(dirtyM || me_skipW)), .wb_valid(!(dirtyW || wb_skipW)),
                               .rsrc1(ex_rsrc1), .rsrc2(ex_rsrc2),
                               .me_rdst(me_rdst), .wb_rdst(wb_rdst),
                               .fwd1(fwd1), .fwd2(fwd2));

  // Sources
  always @(*) begin
    // calculate s1
    if (ex_in) s1 = ex_input;
    else if (ex_imm1) s1 = ex_imm;
    else begin
      case (fwd1)
        MEF: s1 = r_s1;
        WBF: s1 = wd;
        default: s1 = ex_rd1;
      endcase
    end

    // calculate s2
    case (fwd2)
      MEF: s2 = r_s1;
      WBF: s2 = wd;
      default: s2 = ex_rd2;
    endcase
  end

  // ALU Inputs
  wire [15:0] a, b;
  assign a = s1;
  assign b = ex_imm2 ? ex_imm : s2;

  // Execute Unit
  exec_unit exec_unit (.skip(ex_skipE),
                       .func(ex_func),
                       .a(a), .b(b),
                       .r(r),
                       .z(zo), .n(no), .c(co));

  // Halt Register
  register #(.WIDTH(1)) halt_reg (.clk(clk), .rst(rst),
                                  .load(!dirtyE),
                                  .in(ex_hlt),
                                  .out(halted));

  // Stall Execute
  assign stallE = halted;

  // Flags Register
  flags_reg flags_reg (.clk(clk), .rst(rst),
                       .enable(!dirtyE),
                       .sc(ex_setC),
                       .zi(zo), .ni(no), .ci(co),
                       .z(z), .n(n), .c(c));

  // Target Address
  assign target = ex_pc + ({{16{ex_imm[15]}}, ex_imm} << 2);

  // Branch Logic
  branch_logic branch_logic (.valid(!dirtyE),
                             .z(z), .n(n), .c(c),
                             .branch(ex_branch),
                             .jump(jump));

  // Flush Decode
  assign flushD = jump;

  // ===== Memory ====

  // EX/ME Register
  wire [124:0] ex_me_in, ex_me_out;
  assign ex_me_in = {ex_call, ex_int, ex_ret, ex_out,
                     ex_skipE, ex_skipM, ex_push, ex_pop, ex_wr, ex_skipW,
                     target, s2, r, s1, ex_rdst, ex_pc};
  assign {me_call, me_int, me_ret, me_out,
          me_skipE, me_skipM, me_push, me_pop, me_wr, me_skipW,
          me_target, me_s2, me_r, me_s1, me_rdst, me_pc} = ex_me_out;
  stage_reg #(.WIDTH(125)) ex_me_reg (.clk(clk), .rst(rst),
                                     .keep(keepM),
                                     .in(ex_me_in),
                                     .out(ex_me_out));

  // Memory Exception
  assign memExpt1 = me_pop && (sp == 32'hFFFFFFFF);
  assign memExpt2 = me_r >= 16'hFF00;
  assign memExpt = memExpt1 || memExpt2;

  // Flush Memory
  assign flushM = memExpt;

  // Exception PC Register
  register #(.WIDTH(32)) epc_reg (.clk(clk), .rst(rst),
                                  .load(memExpt),
                                  .in(me_pc),
                                  .out(epc));

  // SP Register
  sp_reg sp_reg (.clk(clk), .rst(rst),
                 .enable(!(dirtyM || me_skipM)),
                 .push(me_push), .pop(me_pop),
                 .sp(sp));

  // Memory PC To Save
  wire [31:0] pc_save;
  assign pc_save = me_pc + 32'd4;

  // Memory Address and Data
  wire [31:0] memAddr;
  wire [15:0] memInput;
  assign memAddr  = (me_push || me_pop) ? sp : {16'b0, me_r};
  assign memInput = (me_call || me_int) ? (offset ? pc_save[31:16] : pc_save[15:0]) : me_s2;

  // Memory Unit
  mem_unit mem_unit (.clk(clk),
                     .dirty(dirtyM), .skip(me_skipM),
                     .wr(me_wr),
                     .addr(memAddr),
                     .di(memInput),
                     .do(do));

  // Skip Execute
  assign r_s1 = me_skipE ? me_s1 : me_r;

  //Memory Control
  mem_control mem_control (.clk(clk), .rst(rst),
                           .valid(!dirtyM), .flush(flushM),
                           .continue(me_call || me_int || me_ret),
                           .extend(extendM),
                           .offset(offset));

  // Memory PC To Load
  wire [31:0] pc_load;
  assign pc_load = {wb_do, do};

  // Memory Target Address
  assign memTarget = me_ret ? pc_load : me_target;

  // Memory Jump
  assign memJump = (me_call || me_ret) && offset;
  assign memInt = me_int && offset;

  // Flush Execute
  assign flushE = memJump || memInt || halted;

  // ===== Write =====

  // ME/WB Register
  wire [69:0] me_wb_in, me_wb_out;
  assign me_wb_in = {me_out, me_skipM, me_skipW,
                     do, r_s1, me_rdst, me_pc};
  assign {wb_out, wb_skipM, wb_skipW,
          wb_do, wb_r_s1, wb_rdst, wb_pc} = me_wb_out;
  stage_reg #(.WIDTH(70)) me_wb_reg (.clk(clk), .rst(rst),
                                     .keep(keepW),
                                     .in(me_wb_in),
                                     .out(me_wb_out));

  // Write Data
  assign wd = wb_skipM ? wb_r_s1 : wb_do;

  // ==== Pipeline ====

  // Pipeline Unit
  pipe_unit pipe_unit (.clk(clk), .rst(rst),
                       .stall({1'b0, stallD, stallE, 1'b0, 1'b0}),
                       .flush({1'b0, flushD, flushE, flushM, 1'b0}),
                       .extend({extendF, 1'b0, 1'b0, extendM, 1'b0}),
                       .keep({keepF, keepD, keepE, keepM, keepW}),
                       .dirty({dirtyF, dirtyD, dirtyE, dirtyM, dirtyW}));

endmodule