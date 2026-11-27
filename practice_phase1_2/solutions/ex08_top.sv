module ex08_top (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       btn_n,
    output wire       hsync,
    output wire       vsync,
    output wire [2:0] r,
    output wire [2:0] g,
    output wire [2:0] b
);
    wire       pix_en, mode, hs_i, vs_i, visible;
    wire [9:0] x, y;
    wire [2:0] rr, gg, bb;

    ex01_pix_en      u_pix  (.clk(clk), .rst_n(rst_n), .pix_en(pix_en));
    ex02_xy_counter #(.H_TOTAL(800), .V_TOTAL(525))
                     u_cnt  (.clk(clk), .rst_n(rst_n), .en(pix_en), .x(x), .y(y));
    ex04_btn_toggle  u_btn  (.clk(clk), .rst_n(rst_n), .btn_n(btn_n), .mode(mode));
    ex06_render      u_rend (.mode(mode), .x(x), .y(y), .r(rr), .g(gg), .b(bb));
    ex03_sync_decode u_dec  (.x(x), .y(y), .hsync(hs_i), .vsync(vs_i), .visible(visible));
    ex07_out_stage   u_out  (.clk(clk), .rst_n(rst_n), .pix_en(pix_en),
                             .hsync_i(hs_i), .vsync_i(vs_i), .visible(visible),
                             .ri(rr), .gi(gg), .bi(bb),
                             .hsync(hsync), .vsync(vsync), .r(r), .g(g), .b(b));
endmodule
