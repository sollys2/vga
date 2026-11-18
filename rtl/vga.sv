// 640x480 60Hz
// clk = 50 mhz, 2 clk = 1 pixel (25 MHz)
module vga #(
    parameter H_VIS  = 640,
    parameter H_FP   = 16,
    parameter H_SYNC = 96,
    parameter H_BP   = 48,
    parameter V_VIS  = 480,
    parameter V_FP   = 10,
    parameter V_SYNC = 2,
    parameter V_BP   = 33
)(
    input  wire clk,     
    input  wire rst_n,   
    input  wire btn_n,  
    output reg  hsync,
    output reg  vsync,
    output reg  r,
    output reg  g,
    output reg  b
);
    localparam H_TOTAL = H_VIS + H_FP + H_SYNC + H_BP;
    localparam V_TOTAL = V_VIS + V_FP + V_SYNC + V_BP;

    reg       pix_en;     
    reg [9:0] x;          // 799
    reg [9:0] y;          // 524
    reg       on;         // bat screen
    reg       btn_d1, btn_d2;
    
    // tao xung 25mhz
    always @(posedge clk)
        if (!rst_n) pix_en <= 1'b0;
        else        pix_en <= ~pix_en;
    // dem x y 
    always @(posedge clk)
        if (!rst_n) begin
            x <= 0;
            y <= 0;
        end else if (pix_en) begin
            if (x == H_TOTAL-1) begin //ve dau dong
                x <= 0;
                if (y == V_TOTAL-1) y <= 0; //ve dau cot
                else          y <= y + 1; //xuong dong 
            end else
                x <= x + 1; 
        end

    //rst va on 
    always @(posedge clk) begin
        btn_d1 <= btn_n;
        btn_d2 <= btn_d1;
        if (!rst_n)                 on <= 1'b1;
        else if (btn_d2 && !btn_d1) on <= ~on;
    end

    // vung hien thi 
    wire visible = (x < H_VIS) && (y < V_VIS);
    always @(posedge clk)
        if (pix_en) begin
            hsync <= ~((x >= H_VIS+H_FP) && (x < H_VIS+H_FP+H_SYNC));  
            vsync <= ~((y >= V_VIS+V_FP) && (y < V_VIS+V_FP+V_SYNC)); 
            r <= visible & on;
            g <= visible & on;
            b <= visible & on;
        end
endmodule