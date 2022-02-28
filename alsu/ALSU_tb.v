module ALSU_tb();

reg [15: 0] A, B;
reg [2: 0] FUNC;
wire [15: 0] R;
wire Z, N, C;


ALSU  alsu(.r(R), .z(Z), .n(N), .c(C), .a(A), .b(B), .FUNC(FUNC));

initial 
    begin
        $dumpfile("dump.vcd");
        $dumpvars;
        
        A = 16'd3;
        B = 16'd10;
        FUNC = 3'd0; //ADD
        #2
        if(R == 16'd13)
            $display("Add succeed");
        #3
        FUNC = 3'd1;
        #1
        if(R == 16'hFFF9)
            $display("Sub succeed");
        #2
        FUNC = 3'd2;
        #1
        if(R == 16'd3)
            $display("SHL succeed");        
        #2
        FUNC = 3'd3;
        #1
        if(R == 16'd1)
            $display("SHR succeed");   
        #2
        FUNC = 3'd4; 
        #1
        if(R == 16'd2)
            $display("AND succeed");         
        #2
        FUNC = 3'd5;
        #1
        if(R == 16'd9)
            $display("XOR succeed");  
        #2
        FUNC = 3'd6;
        #1
        if(R == 16'hFFFC)
            $display("Not succeed");          
        #2
        FUNC = 3'd7; 
        #1
        if(R == 16'd4)
            $display("INC succeed");  
        #6
        $stop;

    end
endmodule