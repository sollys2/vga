//mode 1 (0): les, mode 2(1): pan 
module vga_phase1_2 #(
    parameter H_VIS  = 640,
    parameter H_FP   = 16,
    parameter H_SYNC = 96,
    parameter H_BP   = 48,
    parameter V_VIS  = 480,
    parameter V_FP   = 10,
    parameter V_SYNC = 2,
    parameter V_BP   = 33
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       btn_n,
    output reg        hsync,
    output reg        vsync,
    output reg  [2:0] r,
    output reg  [2:0] g,
    output reg  [2:0] b
);
    localparam H_TOTAL = H_VIS + H_FP + H_SYNC + H_BP;   // 800
    localparam V_TOTAL = V_VIS + V_FP + V_SYNC + V_BP;   // 525

    reg       pix_en;
    reg [9:0] x;         
    reg [9:0] y;        
    reg       mode;    
    reg       btn_d1, btn_d2;
    always @(posedge clk)
        if (!rst_n) pix_en <= 1'b0;
        else        pix_en <= ~pix_en;
    always @(posedge clk)
        if (!rst_n) begin
            x <= 0;
            y <= 0;
        end else if (pix_en) begin
            if (x == H_TOTAL-1) begin
                x <= 0;
                if (y == V_TOTAL-1) y <= 0;
                else                y <= y + 1;
            end else
                x <= x + 1;
        end

    //key1
    always @(posedge clk) begin
        btn_d1 <= btn_n;
        btn_d2 <= btn_d1;
        if (!rst_n)                 mode <= 1'b0;
        else if (btn_d2 && !btn_d1) mode <= ~mode;
    end

    // khoi render: tinh mau tu (x, y), khong doc bo nho
    wire [2:0] rr, gg, bb;
    render #(.H_VIS(H_VIS), .V_VIS(V_VIS)) u_render (
        .mode(mode), .x(x), .y(y), .r(rr), .g(gg), .b(bb)
    );
    wire visible = (x < H_VIS) && (y < V_VIS);

    // hsync, vsync, rgb cung qua 1 tang thanh ghi -> tre bang nhau
    always @(posedge clk)
        if (!rst_n) begin
            hsync <= 1'b1;
            vsync <= 1'b1;
            r <= 3'd0;
            g <= 3'd0;
            b <= 3'd0;
        end else if (pix_en) begin
            hsync <= ~((x >= H_VIS+H_FP) && (x < H_VIS+H_FP+H_SYNC));
            vsync <= ~((y >= V_VIS+V_FP) && (y < V_VIS+V_FP+V_SYNC));
            r <= visible ? rr : 3'd0;
            g <= visible ? gg : 3'd0;
            b <= visible ? bb : 3'd0;
        end
endmodule


//
module render #(
    parameter H_VIS = 640,
    parameter V_VIS = 480
)(
    input  wire       mode,
    input  wire [9:0] x,
    input  wire [9:0] y,
    output reg  [2:0] r,
    output reg  [2:0] g,
    output reg  [2:0] b
);
    // 5 soc, 96 dong each
    localparam LS = V_VIS / 5;       // 96

    reg [2:0] les_r, les_g, les_b;
    always @(*) begin
        if      (y <   LS) begin les_r = 3'd6; les_g = 3'd1; les_b = 3'd0; end
        else if (y < 2*LS) begin les_r = 3'd7; les_g = 3'd4; les_b = 3'd2; end
        else if (y < 3*LS) begin les_r = 3'd7; les_g = 3'd7; les_b = 3'd7; end
        else if (y < 4*LS) begin les_r = 3'd6; les_g = 3'd3; les_b = 3'd5; end
        else               begin les_r = 3'd4; les_g = 3'd0; les_b = 3'd3; end
    end

// 3 soc, 160 dong each
    localparam PS = V_VIS / 3;       // 160

    reg [2:0] pan_r, pan_g, pan_b;
    always @(*) begin
        if      (y <   PS) begin pan_r = 3'd7; pan_g = 3'd1; pan_b = 3'd4; end
        else if (y < 2*PS) begin pan_r = 3'd7; pan_g = 3'd6; pan_b = 3'd0; end
        else               begin pan_r = 3'd1; pan_g = 3'd5; pan_b = 3'd7; end
    end

    // chon co theo che do
    always @(*) begin
        if (mode) begin r = pan_r; g = pan_g; b = pan_b; end
        else      begin r = les_r; g = les_g; b = les_b; end
    end
endmodule
