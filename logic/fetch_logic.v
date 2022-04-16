module fetch_logic #(
  parameter NORMAL  = 1'b0,
  parameter LOOKUP  = 1'b1
) (
  input clk, rst,
  input int, expt1, expt2,
  input [31:0] pc, instr,
  output reg extend, fetch, currentState,
  output reg [1:0] fetch_src
);


  always @(posedge clk, negedge rst) begin
    if(!rst)
      currentState <= LOOKUP; 
  end

  // State Operation
  always @(*) begin
    case (currentState)
      NORMAL: begin
        extend = 1'b0;
        fetch  = 1'b0;
        fetch_src = 2'b00;
      end
      LOOKUP: begin
        extend = 1'b1;
        fetch  = 1'b1;
        if(int)
          fetch_src = 2'b01;
        else
          fetch_src = 2'b00;
      end
    endcase
  end
  //State Transition
  always @(posedge clk, negedge rst) begin
    case (currentState)
      NORMAL: 
        if(!rst)
          currentState <= LOOKUP;
      LOOKUP: 
        if(!rst)
          currentState <= LOOKUP;
        else if(pc == instr) begin
          currentState <= NORMAL;
        end 
      default: currentState <= NORMAL;
    endcase
  end

endmodule
