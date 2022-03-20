module pipe_unit (
  input clk, rst, hlt,
  input [4:0] stall,
  input [4:0] flush,
  output reg [4:0] keep,
  output reg [4:0] dirty
);

  localparam IDLE = 2'b00;
  localparam HLT  = 2'b01;
  localparam RESET = 2'b10;
  //Status Register
  reg [1:0] currentState;
  // Bubbles Register
  reg [4:0] bubble;
  reg [4:0] nextBubble;

  // Pipeline Control (bubbles propagation)
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      bubble <= 5'b01111;  // reset pipeline
      currentState <= 1'b00; //Reset state
    end 
    else bubble <= nextBubble;     // advance pipeline
  end

  // Next Bubbles Calculation
  always @(*) begin
      //Next bubble calculation
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

        // stalling (insert bubbles)
        casez (stall)
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
    keep[0] = stall[0];
    keep[1] = |stall[1:0];
    keep[2] = |stall[2:0];
    keep[3] = |stall[3:0] | hlt;
    keep[4] = |stall[4:0] | hlt;
  end

  // Dirty Values
  always @(*) begin
    dirty[0] = bubble[0] || flush[0] || stall[0];
    dirty[1] = bubble[1] || |flush[1:0] || |stall[1:0];
    dirty[2] = bubble[2] || |flush[2:0] || |stall[2:0];
    dirty[3] = bubble[3] || |flush[3:0] || |stall[3:0];
    dirty[4] = bubble[4] || |flush[4:0] || |stall[4:0];
  end

endmodule