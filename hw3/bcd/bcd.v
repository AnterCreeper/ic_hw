`timescale 100ps/100ps

module bcd_lut(
    input c,
    input[3:0] a,
    output[3:0] z
);

reg[3:0] y;
always @(*)
begin
    case(a)
    4'h0: y <= 4'h0;
    4'h1: y <= 4'h1;
    4'h2: y <= 4'h3;
    4'h3: y <= 4'h4;
    4'h4: y <= 4'h6;
    4'h5: y <= 4'h8;
    4'h6: y <= 4'h9;
    4'h7: y <= 4'h1;
    4'h8: y <= 4'h2;
    4'h9: y <= 4'h4;
    4'ha: y <= 4'h6;
    4'hb: y <= 4'h7;
    4'hc: y <= 4'h9;
    4'hd: y <= 4'h0;
    4'he: y <= 4'h2;
    4'hf: y <= 4'h4;
    endcase
end

assign z = y+c;

endmodule

module bcd_enc(
    input[3:0] a,
    input[3:0] x,
    input[3:0] x0,
    output reg c,
    output reg[3:0] y
);

wire[3:0] x_add1,x_add2,x_add3,x_add4;
assign x_add1 = {x[3:1]+1,x[0]};
assign x_add2 = {x[3:1]+2,x[0]};
assign x_add3 = {x[3:1]+3,x[0]};
assign x_add4 = {x[3:1]+4,x[0]};

wire m0,m1,m2,m3,m4;
assign m0 = 0;
assign m1 = x0[3]&~(x0[2]|x0[1]);
assign m2 = (~x0[3]&x0[2]&x0[1])|(x0[3]&~x0[2]&~x0[1]);
assign m3 = (x0[3]|x0[2])&~(x0[3]&(x0[2]^x0[1]));
assign m4 = (x0[1]^x0[3])|x0[2];

always @(*)
begin
    case(a)
    4'h0: begin y <= x;      c <= m0; end
    4'h1: begin y <= x_add3; c <= m3; end
    4'h2: begin y <= x_add1; c <= m1; end
    4'h3: begin y <= x_add4; c <= m4; end
    4'h4: begin y <= x_add2; c <= m2; end
    4'h5: begin y <= x;      c <= m0; end
    4'h6: begin y <= x_add3; c <= m3; end
    4'h7: begin y <= x_add1; c <= m1; end
    4'h8: begin y <= x_add4; c <= m4; end
    4'h9: begin y <= x_add2; c <= m2; end
    4'ha: begin y <= x;      c <= m0; end
    4'hb: begin y <= x_add3; c <= m3; end
    4'hc: begin y <= x_add1; c <= m1; end
    4'hd: begin y <= x_add4; c <= m4; end
    4'he: begin y <= x_add2; c <= m2; end
    4'hf: begin y <= x;      c <= m0; end
    endcase
end

endmodule

module bcd_rec(
    input c,
    input[3:0] z,
    output reg[3:0] y
);

always @(*)
begin
    case({z[3], c})
    2'b00: y <= z;
    2'b01: y <= z[2:0]+1;
    2'b10: y <= z[1]?0:z;
    2'b11: y <= {~(z[0]|z[1]),2'b0,~z[0]};
endcase
end

endmodule

module bcd_hsb(
    input c0,
    input c1,
    input[3:0] a,
    output reg[1:0] y
);

wire z1, z2;
assign z1 = c0|c1;
assign z2 = c0&c1;

always @(*)
begin
    case(a)
    4'h0: y <= 2'b00;
    4'h1: y <= 2'b00;
    4'h2: y <= 2'b00;
    4'h3: y <= 2'b00;
    4'h4: y <= 2'b00;
    4'h5: y <= {1'b0,z2};
    4'h6: y <= {1'b0,z1};
    4'h7: y <= 2'b01;
    4'h8: y <= 2'b01;
    4'h9: y <= 2'b01;
    4'ha: y <= 2'b01;
    4'hb: y <= 2'b01;
    4'hc: y <= {z1,~z1};
    4'hd: y <= 2'b10;
    4'he: y <= 2'b10;
    4'hf: y <= 2'b10;
    endcase
end

endmodule

module bcd(
    input[7:0] bin_in,
    output[9:0] bcd_out
);

//3:0
wire c0;
assign c0 = bin_in[3]&(bin_in[2]|bin_in[1]);
wire[3:0] a1, a2;
assign a1 = c0?{bin_in[3:1]+3,bin_in[0]}:bin_in;
wire c1;
bcd_enc enc(.a(bin_in[7:4]),.x(a1),.x0(bin_in[3:0]),.c(c1),.y(a2));
assign bcd_out[3:0] = c1?{a2[3:1]+3,a2[0]}:a2;

//7:4
wire[3:0] z;
bcd_lut lut(.c(c0),.a(bin_in[7:4]),.z(z));
bcd_rec rec(.c(c1),.z(z),.y(bcd_out[7:4]));

//9:8
bcd_hsb hsb(.c0(c0),.c1(c1),.a(bin_in[7:4]),.y(bcd_out[9:8]));

endmodule
