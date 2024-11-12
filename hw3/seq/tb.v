`timescale 100ps/100ps

`define DELAY 10

module testbench();

reg clk;
reg rst_n;

reg a, vld;
wire y;

seq tb(
    .clk(clk),
    .rst_n(rst_n),
    .din_vld(vld),
    .din(a),
    .result(y)
);

integer i, j;
wire[17:0] mem = 18'b000011101100011100;
wire[17:0] ans = 18'b101000000100000000;

always #`DELAY clk = ~clk;

initial
begin
    clk = 1'b0;
    rst_n = 1'b0;
    vld = 1'bx;
    a = 1'bx;
    j = 0;
    #`DELAY;
    rst_n = 1'b1;
    vld = 1'b1;
    for(i = 0; i < 18; i = i + 1)
    begin
        #`DELAY;
        #`DELAY;
        if (y != ans[i]) $display("error!");
    end
    $stop;
end

always @(posedge clk)
begin
    j <= j + 1;
    a <= mem[j];
end

endmodule
