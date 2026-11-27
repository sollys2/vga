module ex07_out_stage (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       pix_en,
    input  wire       hsync_i,
    input  wire       vsync_i,
    input  wire       visible,
    input  wire [2:0] ri,
    input  wire [2:0] gi,
    input  wire [2:0] bi,
    output reg        hsync,
    output reg        vsync,
    output reg  [2:0] r,
    output reg  [2:0] g,
    output reg  [2:0] b
);
    always @(posedge clk)
        if (!rst_n) begin
            hsync <= 1'b1;
            vsync <= 1'b1;
            r <= 3'd0;
            g <= 3'd0;
            b <= 3'd0;
        end else if (pix_en) begin
            hsync <= hsync_i;
            vsync <= vsync_i;
            r <= visible ? ri : 3'd0;
            g <= visible ? gi : 3'd0;
            b <= visible ? bi : 3'd0;
        end
endmodule
