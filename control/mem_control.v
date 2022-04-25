module mem_control (
    input clk, rst,
    input ret, int,
    output reg count,
    output reg extend,
    output reg jump
);
  parameter NORM = 2'b00;
  parameter RET  = 2'b01;
  parameter INT  = 2'b10;

  reg [1:0] state, nextstate;
  //State Transition
  always@(posedge clk or negedge rst) begin
      if(!rst) begin 
          nextstate <= NORM;
          state <= NORM;
      end
      else state <= nextstate;
  end
  //Transition Logic
  always@(*) begin
      if(ret) nextstate = RET;
      else if(int) nextstate = INT;
      if(count == 1'b1) nextstate = NORM;
  end
  //Clock Transition
  always@(posedge clk or negedge rst) begin
      if(!rst) begin 
          count <= 1'b0;
      end
      else if(state == INT || state == RET) begin 
          count <= count + 1'b1;
      end
      else begin
          count <= 1'b0;
      end
  end
  //State Operation
  always @(*) begin
      jump   = 1'b0;
      case(state)
        NORM: begin
            extend = 1'b0;
        end
        INT: begin
            extend = 1'b1;
        end
        RET: begin
            extend = 1'b1;
            if(count == 1'b1)
              jump = 1'b1;
        end
        default: begin
            extend = 1'b0;
        end        
      endcase    
  end
endmodule