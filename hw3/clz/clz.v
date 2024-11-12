`timescale 100ps/100ps

module clz(
    input[31:0] data_in,
    output[5:0] pos_out
);

//encode
wire[3:0] ai;
wire[11:0] z;
genvar i;
generate
for (i = 0; i < 4; i = i + 1)
begin
    assign ai[i    ] = ~|data_in[i*8+7:i*8];
    assign  z[i*3+2] = ~|data_in[i*8+7:i*8+4];
    assign  z[i*3+1] = ~(data_in[i*8+7]|data_in[i*8+6]|(~(data_in[i*8+5]|data_in[i*8+4])&(data_in[i*8+3]|data_in[i*8+2])));
    assign  z[i*3] = ~(data_in[i*8+7]|(~data_in[i*8+6]&data_in[i*8+5]))&
                    (data_in[i*8+6]|data_in[i*8+4]|~(data_in[i*8+3]|(~data_in[i*8+2]&data_in[i*8+1])));
end
endgenerate

//assembly
assign pos_out = ai[3] ? (
                ai[2] ? (
                ai[1] ? (
                ai[0] ? 6'h20
                : {3'h3, z[2:0]})
                : {3'h2, z[5:3]})
                : {3'h1, z[8:6]})
                : {3'h0, z[11:9]};

endmodule
