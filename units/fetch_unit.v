module fetch_unit (
  input clk, rst_signal,
  input keep, jump,
  input [31:0] target,
  output reg extend,
  output wire [31:0] pc, instr
);
  reg [31:0] pc_in;
  reg rst;
  //FSM
  localparam IDLE = 2'b00;
  localparam RST  = 2'b01;
  reg [1:0] currentState;
  reg [1:0] count;
  reg rstPC;

  always @(posedge clk, negedge rst_signal) begin
    if(!rst_signal) begin
      rst <= 1'b0;
      rstPC <= 1'b0;
      currentState <= 2'b00; //Normal
      count <= 2'b00;
    end
    else if(!rstPC) begin
      count <= count + 1;
      rst <= 1'b1;
    end
    else 
      count <= 2'b00;
  end

always @(*) begin
  case (currentState)
    IDLE: begin
      if(!rst_signal)
        currentState = RST;
      else  //calculate new pc
        if (jump)
          pc_in = target;
        else
          pc_in = pc + 32'd4; 
    end
    RST: begin
      rstPC  = 1'b0;
      extend = 1'b1;
      if(count == 2'b01) begin  
        pc_in  = instr;
      end
      else if(count == 2'b11) begin
        extend = 1'b0;
        currentState = IDLE;
        rstPC = 1'b1;
      end
    end
    default: currentState = IDLE;
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
                                                         .addr(pc[19:2]),
                                                         .in(32'd0),
                                                         .out(instr));

endmodule