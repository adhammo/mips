module fetch_control (
  input clk, rst,
  input valid, flush,
  input int,
  output reg extend,
  output reg fetch,
  output reg [1:0] fetchSrc
);

  parameter RSTSRC = 2'b00;
  parameter INTSRC = 2'b01;

  parameter STRT = 2'b00;
  parameter NORM = 2'b01;
  parameter  RST = 2'b10;
  parameter  INT = 2'b11;

  // State
  reg [1:0] state, nextState;

  // State Transition
  always @(posedge clk or negedge rst) begin
    if (!rst) state <= STRT; // reset state
    else state <= nextState; // next state
  end

  // State Operation
  always @(*) begin
    // default: norm
    extend = 1'b0;
    fetch = 1'b0;
    fetchSrc = 2'b00;

    // check if valid
    if (valid) begin
      case (state)
        RST: begin
          extend = 1'b1;
          fetch = 1'b1;
          fetchSrc = RSTSRC;
        end
        INT: begin
          extend = 1'b1;
          fetch = 1'b1;
          fetchSrc = INTSRC;
        end
      endcase
    end
  end

  // Next State
  always @(*) begin
    if (int) nextState = INT;
    else if (state == STRT) nextState = RST;
    else if (flush) nextState = NORM;
    else if (valid) nextState = NORM;
    else nextState = state;
  end

endmodule
