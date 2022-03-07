`timescale 1ns/1ps

module memory_tb();

reg clk, write, enable;
reg [19: 0] addr;
reg [15: 0] in;
wire [15: 0] out;

memory  Memory(.clk(clk), .write(write), .enable(enable), .addr(addr), .in(in), .out(out));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    clk = 1'b0;
    write = 1'b0;
    enable = 1'b0;
    addr = 20'b0;
    in = 16'd15;

    #5
    if(out === in)
        $display("Write1 succeeded.");
    
    #10
    addr = addr + 3'd5;
    in = 16'd10;
    if(out === in)
        $display("Write2 succeeded.");

    #10
    write = 1'b1;
    addr = addr + 3'd7;
    if(out != in)
        $display("Read succeeded.");
    #10
    addr = 16'd0;
    if(out === 16'd10)
        $display("Write1 succeeded.");
    #5
    enable = 1'b1;
    if(out === {(16){1'bz}})
        $display("Disable read succeeded.");

    #5
    $stop;    
 end

always #5 clk = ~clk;

endmodule