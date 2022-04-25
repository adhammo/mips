module mem_control (
    input clk, rst,
    input ret, int, call,
    output reg count,
    output reg extend,
    output reg jumpRet, jumpCall, jumpInt
);
  parameter NORM = 2'b00;
  parameter RET  = 2'b01;
  parameter INT  = 2'b10;

  reg [1:0] state, nextstate;
  //State Transition
//   always@(posedge clk or negedge rst) begin
//       if(!rst) begin 
//          // nextstate <= NORM;
//         //  state <= NORM;
//       end
//       else if(int) state <= INT;
//       else if(ret) state <= RET;
//       else state <= nextstate;
//   end
  //Transition Logic
  always@(*) begin
      if(!rst) begin
        state = NORM;
     end  
      else if(int) state = INT;
      else if(ret) state = RET;
      else state = NORM;
      if(count == 1'b1) state = int ? INT : (ret? RET: NORM);
  end

  //Clock Transition
  always@(posedge clk or negedge rst) begin
      if(!rst) begin 
          count <= 1'b0;
      end
      else if(state == INT || state == RET) begin 
          count <= count + 1'b1;
        //   if(count >= 2'b10)
        //     count <= 2'b00;
      end
      else begin
          count <= 1'b0;
      end
  end
  //State Operation
  always @(*) begin
      jumpRet   = 1'b0;
      jumpInt   = 1'b0;
      jumpCall   = 1'b0;
      case(state)
        NORM: begin
            extend = 1'b0;
        end
        INT: begin
            if(count == 2'b00)
                extend = 1'b1;
            else if(count == 2'b01) begin
                extend = 1'b0;
                if(int) jumpInt = 1'b1;
                else if(call) jumpCall = 1'b1; 
            end
        end
        RET: begin
            if(count == 1'b0)
                extend = 1'b1;
            else if(count == 1'b1) begin
                extend = 1'b0;
                jumpRet = 1'b1; 
            end
        end
        default: begin
            extend = 1'b0;
        end        
      endcase    
  end
endmodule