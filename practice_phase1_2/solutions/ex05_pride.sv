module ex05_pride (
    input  wire [9:0] y,
    output reg  [2:0] r,
    output reg  [2:0] g,
    output reg  [2:0] b
);
    always @(*) begin
        if      (y <  80) begin r = 3'd6; g = 3'd0; b = 3'd0; end
        else if (y < 160) begin r = 3'd7; g = 3'd4; b = 3'd0; end
        else if (y < 240) begin r = 3'd7; g = 3'd7; b = 3'd0; end
        else if (y < 320) begin r = 3'd0; g = 3'd4; b = 3'd1; end
        else if (y < 400) begin r = 3'd0; g = 3'd2; b = 3'd7; end
        else              begin r = 3'd3; g = 3'd0; b = 3'd4; end
    end
endmodule
