module helper(
    input clk,
    input[31:0] din,
    output reg[5:0] dout
);

reg[31:0] a;
wire[5:0] y;

clz tb(
    .data_in(a),
    .pos_out(y)
);

always @(posedge clk)
begin
    a <= din;
    dout <= y;
end

endmodule
