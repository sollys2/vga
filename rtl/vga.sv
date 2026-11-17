// 640x480 60Hz
// clk = 50 mhz, 2 clk = 1 pixel (25 MHz)
module vga (
    input  wire clk,     
    input  wire rst_n,   
    input  wire btn_n,  
    output reg  hsync,
    output reg  vsync,
    output reg  r,
    output reg  g,
    output reg  b
);
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
            if (x == 799) begin //ve dau dong
                x <= 0;
                if (y == 524) y <= 0; //ve dau cot
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
    wire visible = (x < 640) && (y < 480);
    always @(posedge clk)
        if (pix_en) begin
            hsync <= ~((x >= 656) && (x < 752));  
            vsync <= ~((y >= 490) && (y < 492)); 
            r <= visible & on;
            g <= visible & on;
            b <= visible & on;
        end
endmodule