module fetch_control (
  input clk, rst, int,
  output reg extend,
  output reg fetch,
  output reg [1:0] fetchSrc
);

  parameter RSTSRC = 2'b00;
  parameter INTSRC = 2'b01;

  parameter NORM = 2'b00;
  parameter RST  = 2'b01;
  parameter INT  = 2'b10;

  // Current State
  reg [1:0] state;

  // State Transition
  always @(posedge clk or negedge rst) begin
    if (!rst) state <= RST;
    else if(int) state <= INT;
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

endmodule
