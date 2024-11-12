`timescale 100ps/100ps

`define DELAY 20
//`define COUNT 1024
`define COUNT 4 //for demo show only

module testbench();

reg[31:0] a;
wire[5:0] y;

clz tb(
    .data_in(a),
    .pos_out(y)
);

integer i, j;
initial
begin
    //corner case
    a = 0;
    #`DELAY if(y != 32) $display("error!");
    //default case
    for(i = 0; i < 31; i = i + 1)
    begin
        for(j = 0; j < `COUNT; j = j + 1)
        begin
            a = ($random&((1<<i)-1))|(1<<i);
            #`DELAY if(y != 31-i) $display("error!");
        end
    end
    $stop();
end
endmodule
