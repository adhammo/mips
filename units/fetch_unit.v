module fetch_unit (
  input clk, rst,
  input dirty, jump, int, expt1, expt2,
  input [31:0] target,
  output wire extend,
  output wire [31:0] pc, instr
);
  //Internal Variables
  wire fetch, currentState;
  wire [1:0] fetch_src;
  reg [17:0] fetch_addr;
  
  reg [31:0] pc_in;
  reg [31:0] mem_target;
  wire [17:0] instrAddr;
  //FSM
  localparam NORMAL  = 1'b0;
  localparam LOOKUP  = 1'b1;


  //Assign New InstrAddr
  assign instrAddr = fetch ? fetch_addr : pc[19:2];
  //Assign New FetchAddr
  always @(*) begin
    case (fetch_src)
      2'b00:
        fetch_addr = 18'd0;
      2'b01:
        fetch_addr = 18'd4;
      2'b10:
        fetch_addr = 18'd8;
      2'b11:
        fetch_addr = 18'd12;
    endcase
  end
  //Assign New pc_in
  always @(*) begin
    case ({fetch, jump})
      2'b00:
        pc_in = pc + 32'd4;
      2'b01:
        pc_in = target;
      2'b10:
        pc_in = instr;
      2'b11:
        pc_in = mem_target;
      endcase
  end

  // PC Register
  pc_reg pc_reg (.clk(clk), .rst(rst),
                 .dirty(dirty),
                 .pc_in(pc_in),
                 .pc(pc));
  // Instruction Memory
  memory #(.DATAWIDTH(32), .ADDRWIDTH(18)) instr_memory (.clk(clk),
                                                         .write(1'b0),
                                                         .addr(instrAddr),
                                                         .in(32'd0),
                                                         .out(instr));
  fetch_logic #(.NORMAL(NORMAL), .LOOKUP(LOOKUP)) fetch_logic (.clk(clk), .rst(rst),
                                                               .pc(pc), .instr(instr),
                                                               .int(int), .expt1(expt1), .expt2(expt2),
                                                               .extend(extend), .fetch(fetch), .currentState(currentState),
                                                               .fetch_src(fetch_src));

endmodule