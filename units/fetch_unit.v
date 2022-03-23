module fetch_unit (
  input clk, rst,
  input keep, jump,
  input [31:0] target,
  output reg extend,
  output wire [31:0] pc, instr
);
  //Internal Variables
  reg [31:0] pc_in;
  reg [17:0] instrAddr;
  //FSM
  localparam NORMAL = 1'b0;
  localparam LOOKUP  = 1'b1;
  reg currentState;


  always @(posedge clk, negedge rst) begin
    if(!rst) begin
      currentState <= LOOKUP; 
    end
  end

  always @(*) begin
    case (currentState)
      NORMAL: begin
        //calculate new pc
        if (jump)
          pc_in = target;
        else
          pc_in = pc + 32'd4; 
        instrAddr = pc[19:2];
      end
      LOOKUP: begin
        extend = 1'b1;
        instrAddr = 18'd0; 
        pc_in  = instr;
        extend = 1'b0;
      end
      default: currentState = NORMAL;
    endcase
  end

  always @(*) begin
    case (currentState)
      NORMAL: 
        if(!rst)
          currentState = LOOKUP;
      LOOKUP: 
        if(!rst)
          currentState = LOOKUP;
        else if(pc == instr)
          currentState = NORMAL;
      default: currentState = NORMAL;
    endcase
  end

  // PC Register
  pc_reg pc_reg (.clk(clk), .rst(rst),
                 .keep(keep),
                 .pc_in(pc_in),
                 .pc(pc));
  // Instruction Memory
  memory #(.DATAWIDTH(32), .ADDRWIDTH(18)) instr_memory (.clk(clk),
                                                         .write(1'b0),
                                                         .addr(instrAddr),
                                                         .in(32'd0),
                                                         .out(instr));

endmodule