module fetch_control (
  input clk, rst, int,
  output reg extend,
  output reg fetch,
  output reg [1:0] fetchSrc
);

  parameter RSTSRC = 2'b00;
  parameter INTSRC = 2'b01;

  parameter NORM = 1'b0;
  parameter LOOK = 1'b1;

  // Current State
  reg state;

  // State Transition
  always @(posedge clk or negedge rst) begin
    if (!rst) state <= LOOK;
    else if(int) state <= LOOK;
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
        if(int)  begin
          fetchSrc = INTSRC;
        end
      end
    endcase
  end

endmodule
