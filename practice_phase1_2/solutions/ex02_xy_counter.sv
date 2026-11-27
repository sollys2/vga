module ex02_xy_counter #(
    parameter H_TOTAL = 800,
    parameter V_TOTAL = 525
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en,
    output reg  [9:0] x,
    output reg  [9:0] y
);
    always @(posedge clk)
        if (!rst_n) begin
            x <= 0;
            y <= 0;
        end else if (en) begin
            if (x == H_TOTAL-1) begin
                x <= 0;
                if (y == V_TOTAL-1) y <= 0;
                else                y <= y + 1;
            end else
                x <= x + 1;
        end
endmodule
