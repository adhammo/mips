module cpu (
  input clk, rst, 
  input [15:0] in_port,
  output wire [15:0] out_port
);

  // ##### Parameters #####

  // Fetch
  parameter RSTSRC = 2'b00;
  parameter INTSRC = 2'b01;

  // Forward
  parameter MEF = 2'b10;
  parameter WBF = 2'b11;
  
  // ##### Signals #####

  // Keep and Dirty
  wire keepF, keepD, keepE, keepM, keepW;
  wire dirtyF, dirtyD, dirtyE, dirtyM, dirtyW;
  wire extendF, extendD, extendE, extendM, extendW;

  // ===== Fetch =====
  // -- Inputs
  wire [31:0] pc, memTarget;

  // -- Fetch Control Outputs
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
  wire int, call, ret, hlt;
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
  wire [2:0] ex_branch;
  wire ex_setC, ex_load;
  wire ex_in, ex_out;
  wire ex_imm1, ex_imm2;
  wire ex_skipE;
  wire [2:0] ex_func;
  wire ex_skipM, ex_int, ex_call, ex_ret, ex_push, ex_pop, ex_wr;
  wire ex_skipW;

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
  wire jump;
  wire [31:0] target;

  // ===== Memory ====
  // -- Inputs
  wire [31:0] me_pc;
  wire [2:0] me_rdst;
  wire [15:0] me_s1, me_r, me_s2;
  wire me_out;
  wire me_skipE;
  wire me_skipM, me_int, me_call, me_ret, me_push, me_pop, me_wr;
  wire me_skipW;

  // -- SP Register Output
  wire [31:0] sp;

  // -- Outputs
  // Skip Execute
  wire [15:0] r_s1;
  // Memory
  wire [15:0] do;
  //Memory Control
  wire callM, jumpM, intM;
  wire [31:0] me_target;

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
  wire [31:0] pc_in;
  reg [31:0] pc_src;
  always @(*) begin
    // calculate pc input
    if (fetch) pc_src = instr;
    else if (jump) pc_src = target;
    else if (callM) pc_src = me_target;
    else pc_src = 32'b0;
  end
 
  assign pc_in = jumpM? memTarget : pc_src;
  // PC Register
  pc_reg pc_reg (.clk(clk), .rst(rst),
                 .enable(!keepF||(!dirtyF&&fetch)),
                 .load(jump || fetch || jumpM || callM),
                 .in(pc_in),
                 .pc(pc));

  // Instruction Address
  reg [31:0] instrAddr;
  always @(*) begin
    // calculate fetch address
    if (fetch) begin
      case (fetchSrc)
        RSTSRC: instrAddr = 32'b0;
        INTSRC: instrAddr = 32'd4 + wb_r_s1; //Index + 4 
        default: instrAddr = 32'b0;
      endcase
    end else instrAddr = pc;
  end

  // Fetch Unit
  fetch_unit fetch_unit (.clk(clk),
                         .addr(instrAddr),
                         .instr(instr));

  // Fetch Control
  fetch_control fetch_control (.clk(clk), .rst(rst),
                               .extend(extendF), .int(intM),
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
                               .int(int), .call(call), .ret(ret),
                               .hlt(hlt),
                               .branch(branch),
                               .setC(setC), .load(load),
                               .in(in), .out(out),
                               .imm1(imm1), .imm2(imm2),
                               .skipE(skipE),
                               .func(func),
                               .skipM(skipM), .push(push), .pop(pop), .wr(wr),
                               .skipW(skipW));

  // Stall Decode
  wire stallD_i;
  reg stallD_c;
  assign stallD = stallD_i && !stallD_c;
  always @(posedge clk) begin
    if (stallD_i) stallD_c <= 1'b1;
    else stallD_c <= 1'b0;
  end

  // Hazard Logic
  hazard_logic hazard_logic (.ex_valid(!dirtyE),
                             .ex_load(ex_load),
                             .opcode(opcode),
                             .rsrc1(rsrc1), .rsrc2(rsrc2),
                             .ex_rdst(ex_rdst),
                             .stallD(stallD_i));

  // ===== Exec ======

  // ID/EX Register
  wire [125:0] id_ex_in, id_ex_out;
  assign id_ex_in = {branch, setC, load, in, out, imm1, imm2, rsrc1, rsrc2,
                     skipE, func, skipM, int, call, ret, push, pop, wr, skipW,
                     inputData, imm, rd2, rd1, rdst, id_pc};
  assign {ex_branch, ex_setC, ex_load, ex_in, ex_out, ex_imm1, ex_imm2, ex_rsrc1, ex_rsrc2,
          ex_skipE, ex_func, ex_skipM, ex_int, ex_call, ex_ret, ex_push, ex_pop, ex_wr, ex_skipW,
          ex_input, ex_imm, ex_rd2, ex_rd1, ex_rdst, ex_pc} = id_ex_out;
  stage_reg #(.WIDTH(126)) id_ex_reg (.clk(clk), .rst(rst),
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

  // ===== Memory ====

  // EX/ME Register
  wire [124:0] ex_me_in, ex_me_out;
  assign ex_me_in = {ex_out, ex_skipE, ex_skipM, ex_int, ex_call, ex_ret, ex_push, ex_pop, ex_wr, ex_skipW, 
                     target, s2, r, s1, ex_rdst, ex_pc}; 
  assign {me_out, me_skipE, me_skipM, me_int, me_call, me_ret, me_push, me_pop, me_wr, me_skipW,
          me_target, me_s2, me_r, me_s1, me_rdst, me_pc} = ex_me_out; 
  stage_reg #(.WIDTH(125)) ex_me_reg (.clk(clk), .rst(rst),
                                     .keep(keepM),
                                     .in(ex_me_in),
                                     .out(ex_me_out));

  // SP Register
  sp_reg sp_reg (.clk(clk), .rst(rst),
                 .enable(!(dirtyM || me_skipM)),
                 .push(me_push), .pop(me_pop),
                 .sp(sp));

  // Memory Data
  wire [31:0] memAddr;
  wire [15:0] memInput;
  wire count;
  assign memAddr  = me_push || me_pop ? sp : {16'b0, me_r};
  assign memInput = me_int?  (count?  me_pc[31:16]: me_pc[15:0] + 16'd4) : me_s2;
  //Memory Control
  mem_control mem_control (.clk(clk), .rst(rst),
                           .int(me_int), .ret(me_ret), .call(me_call),
                           .count(count), 
                           .extend(extendM), 
                           .jumpRet(jumpM), .jumpCall(callM), .jumpInt(intM));
  //Memory Shift Register
  shift_reg shift_reg (.clk(clk), .rst(rst),
                       .load(me_ret),
                       .in(do),
                       .out(memTarget));                       
  // Memory Unit
  mem_unit mem_unit (.clk(clk),
                     .dirty(dirtyM), .skip(me_skipM),
                     .wr(me_wr),
                     .addr(memAddr),
                     .di(memInput),
                     .do(do));

  // Skip Execute
  assign r_s1 = me_skipE ? me_s1 : me_r;

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
  assign wd = skipM ? wb_r_s1 : wb_do;

  // ==== Pipeline ====

  // Pipeline Unit
  pipe_unit pipe_unit (.clk(clk), .rst(rst),
                       .stall({1'b0, stallD, 1'b0, 1'b0, 1'b0}),
                       .flush({1'b0, jump, 1'b0, 1'b0, 1'b0}),
                       .extend({extendF, 1'b0, 1'b0, extendM, 1'b0}),
                       .keep({keepF, keepD, keepE, keepM, keepW}),
                       .dirty({dirtyF, dirtyD, dirtyE, dirtyM, dirtyW}));

endmodule