module ex06_render (
    input  wire       mode,
    input  wire [9:0] x,
    input  wire [9:0] y,
    output reg  [2:0] r,
    output reg  [2:0] g,
    output reg  [2:0] b
);
    wire [2:0] pr, pg, pb;
    ex05_pride u_pride (.y(y), .r(pr), .g(pg), .b(pb));

    reg [2:0] sr, sg, sb;
    always @(*) begin
        if      (y < 160) begin sr = 3'd7; sg = 3'd1; sb = 3'd4; end
        else if (y < 320) begin sr = 3'd7; sg = 3'd6; sb = 3'd0; end
        else              begin sr = 3'd1; sg = 3'd5; sb = 3'd7; end
    end

    always @(*) begin
        if (mode) begin r = sr; g = sg; b = sb; end
        else      begin r = pr; g = pg; b = pb; end
    end
endmodule
