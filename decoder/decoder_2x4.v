//decoder_2x4
module decoder_2x4(
    input wire A,
    input wire B,
    output wire Y0,
    output wire Y1,
    output wire Y2,
    output wire Y3
);
    assign Y3 = (A & B);
    assign Y2 = (A & ~B);
    assign Y1 = (~A & B);
    assign Y0 = (~A & ~B);
endmodule