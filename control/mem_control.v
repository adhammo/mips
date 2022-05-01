module mem_control (
  input clk, rst,
  input valid, flush,
  input continue,
  output reg extend,
  output reg offset
);

  parameter NORM = 2'b0;
  parameter CONT = 2'b1;

  // State
  reg state, nextState;

  // State Transition
  always @(posedge clk or negedge rst) begin
    if (!rst) state <= NORM; // reset state
    else state <= nextState; // next state
  end

  // State Operation
  always @(*) begin
    // default: no continue
    extend = 1'b0;
    offset = 1'b0;

    // check if valid
    if (valid) begin
      case (state)
        NORM: begin
          extend = continue;
          offset = 1'b0;
        end
        CONT: begin
          extend = 1'b0;
          offset = 1'b1;
        end
      endcase
    end
  end

  // Next State
  always @(*) begin
    if (flush) nextState = NORM;
    else if (valid) begin
      if (continue) nextState = CONT;
      else nextState = NORM;
    end else nextState = state;
  end

endmodule