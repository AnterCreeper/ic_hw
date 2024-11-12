module helper(
    input clk,
    input[7:0] din,
    output reg[9:0] dout
);

reg[7:0] a;
wire[9:0] y;

bcd tb(
    .bin_in(a),
    .bcd_out(y)
);

always @(posedge clk)
begin
    a <= din;
    dout <= y;
end

endmodule
