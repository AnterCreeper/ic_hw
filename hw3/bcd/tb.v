`timescale 100ps/100ps

`define DELAY 20

module testbench();

reg[7:0] a;
wire[9:0] y;

bcd tb(
    .bin_in(a),
    .bcd_out(y)
);

integer i;
initial
begin
    for(i = 0; i < 256; i = i + 1)
    begin
    a = i;
    #`DELAY if(y[3:0]+y[7:4]*10+y[9:8]*100!=i) $display("error!");
    end
    $stop();
end
endmodule
