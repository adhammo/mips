module pipe_unit (
  input clk, rst,
  input [4:0] stall,
  input [4:0] flush,
  input [4:0] extend,
  output reg [4:0] keep,
  output reg [4:0] throw,
  output reg [4:0] dirtyNow,
  output wire [4:0] dirty
);

  // Bubbles Register
  reg [4:0] bubble;
  reg [4:0] nextBubble;

  // Pipeline Control (bubbles propagation)
  always @(posedge clk or negedge rst) begin
    if (!rst) bubble <= 5'b11111;  // reset pipeline
    else bubble <= nextBubble;     // advance pipeline
  end

  // Next Bubbles Calculation
  always @(*) begin 
    // flushing (set as bubbles)
    casez (flush)
      5'b????1: nextBubble = 5'b11111;
      5'b???10: nextBubble = {4'b1111, bubble[0]};
      5'b??100: nextBubble = {3'b111, bubble[1:0]};
      5'b?1000: nextBubble = {2'b11, bubble[2:0]};
      5'b10000: nextBubble = {1'b1, bubble[3:0]};
      5'b00000: nextBubble = bubble[4:0];
      default: nextBubble = bubble[4:0];
    endcase

    // stalling/extending (insert bubbles)
    casez (stall | extend)
      5'b????1: nextBubble = nextBubble;
      5'b???10: nextBubble = {nextBubble[4:1], 1'b1};
      5'b??100: nextBubble = {nextBubble[4:2], 1'b1, nextBubble[1]};
      5'b?1000: nextBubble = {nextBubble[4:3], 1'b1, nextBubble[2:1]};
      5'b10000: nextBubble = {nextBubble[4], 1'b1, nextBubble[3:1]};
      5'b00000: nextBubble = {1'b0, nextBubble[4:1]};
      default: nextBubble = {1'b0, nextBubble[4:1]};
    endcase
  end

  // Keep Values
  always @(*) begin
    keep[0] = stall[0] || extend[0];
    keep[1] = |stall[1:0] || |extend[1:0];
    keep[2] = |stall[2:0] || |extend[2:0];
    keep[3] = |stall[3:0] || |extend[3:0];
    keep[4] = |stall[4:0] || |extend[4:0];
  end

  // Throw Values
  always @(*) begin
    throw[0] = flush[0];
    throw[1] = |flush[1:0];
    throw[2] = |flush[2:0];
    throw[3] = |flush[3:0];
    throw[4] = |flush[4:0];
  end

  // DirtyNow Values
  always @(*) begin
    dirtyNow[0] = bubble[0] || stall[0];
    dirtyNow[1] = bubble[1] || |stall[1:0] || extend[0];
    dirtyNow[2] = bubble[2] || |stall[2:0] || |extend[1:0];
    dirtyNow[3] = bubble[3] || |stall[3:0] || |extend[2:0];
    dirtyNow[4] = bubble[4] || |stall[4:0] || |extend[3:0];
  end

  // Dirty Values
  assign dirty = dirtyNow | throw;

endmodule