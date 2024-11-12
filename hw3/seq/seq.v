`timescale 100ps/100ps

module dff(
    input clk,
    input rst_n,
    input en,
    input d,
    output reg q
);

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        q <= 0;
    end else
    begin
        q <= en ? d : q;
    end
end

endmodule

module seq(
    input clk,
    input rst_n,
    input din_vld,
    input din,
    output reg result
);

wire[5:0] z;
assign z[0] = din;

//generate shift register
genvar i;
generate
for (i = 0; i < 5; i = i + 1)
begin
dff data(
    .clk(clk),
    .rst_n(rst_n),
    .en(din_vld),
    .d(z[i]),
    .q(z[i+1])
);
end
endgenerate

//detect
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) result <= 0;
    else
    result <= din_vld ? (z == 6'b111000 || z == 6'b101110 ? 1 : 0) : result;
end

endmodule
