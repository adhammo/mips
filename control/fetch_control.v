module fetch_control (
  input clk, rst,
  input valid, flush,
  input int, expt1, expt2,
  output reg extend,
  output reg fetch,
  output reg [1:0] fetchSrc
);
  parameter RSTSRC   = 2'b00;
  parameter EXPT1SRC = 2'b01;
  parameter EXPT2SRC = 2'b10;
  parameter INTSRC   = 2'b11;

  parameter STRT  = 3'b000;
  parameter NORM  = 3'b001;
  parameter RST   = 3'b010;
  parameter INT   = 3'b011;
  parameter EXPT1 = 3'b100;
  parameter EXPT2 = 3'b101;

  // State
  reg [2:0] state, nextState;

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
        EXPT1: begin
          extend = 1'b1;
          fetch = 1'b1;
          fetchSrc = EXPT1SRC;
        end
        EXPT2: begin
          extend = 1'b1;
          fetch = 1'b1;
          fetchSrc = EXPT2SRC;
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
    if (expt1) nextState = EXPT1;
    else if (expt2) nextState = EXPT2;
    else if (int) nextState = INT;
    else if (state == STRT) nextState = RST;
    else if (flush) nextState = NORM;
    else if (valid) nextState = NORM;
    else nextState = state;
  end

endmodule
