module fetch_control (
  input clk, rst,
  output reg extend,
  output reg fetch,
  output reg [1:0] fetchSrc
);

  parameter RSTSRC = 2'b00;

  parameter NORM = 1'b0;
  parameter LOOK = 1'b1;

  // Current State
  reg state;

  // State Transition
  always @(posedge clk or negedge rst) begin
    if (!rst) state <= LOOK;
    else state <= NORM;
  end

  // State Operation
  always @(*) begin
    case (state)
      NORM: begin
        extend = 1'b0;
        fetch = 1'b0;
        fetchSrc = 2'b00;
      end
      LOOK: begin
        extend = 1'b1;
        fetch = 1'b1;
        fetchSrc = RSTSRC;
      end
    endcase
  end

endmodule
