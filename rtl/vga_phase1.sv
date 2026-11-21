// Phase 1: 640x480 60Hz, hien 2 anh tu ROM, KEY1 doi anh
// clk = 50 mhz, 2 clk = 1 pixel (25 MHz)
// sel = 0: anh cho 240x240, sel = 1: anh woof 320x240
// anh nam giua man hinh, ngoai anh -> mau den
module vga_phase1 #(
    parameter H_VIS  = 640,
    parameter H_FP   = 16,
    parameter H_SYNC = 96,
    parameter H_BP   = 48,
    parameter V_VIS  = 480,
    parameter V_FP   = 10,
    parameter V_SYNC = 2,
    parameter V_BP   = 33,
    // kich thuoc anh
    parameter DOG_W  = 240,
    parameter DOG_H  = 240,
    parameter WOOF_W = 320,
    parameter WOOF_H = 240,
    // file anh: moi dong 1 so 0..7 = {r,g,b}
    // duong dan tinh tu thu muc quartus/ (hoac sim/)
    parameter DOG_FILE  = "../photos/nonmoving_images/hex_format/dog_240x240_3bit.list",
    parameter WOOF_FILE = "../photos/nonmoving_images/hex_format/woof_320x240_3bit.list"
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

    // goc tren trai cua anh (dat giua man hinh)
    localparam DOG_X0  = (H_VIS - DOG_W)  / 2;   // 200
    localparam DOG_Y0  = (V_VIS - DOG_H)  / 2;   // 120
    localparam WOOF_X0 = (H_VIS - WOOF_W) / 2;   // 160
    localparam WOOF_Y0 = (V_VIS - WOOF_H) / 2;   // 120

    localparam DOG_N  = DOG_W  * DOG_H;          // 57600 o
    localparam WOOF_N = WOOF_W * WOOF_H;         // 76800 o

    reg       pix_en;
    reg [9:0] x;          // 799
    reg [9:0] y;          // 524
    reg       sel;        // 0 = cho, 1 = woof
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

    // nut KEY1: bam 1 lan -> doi anh
    always @(posedge clk) begin
        btn_d1 <= btn_n;
        btn_d2 <= btn_d1;
        if (!rst_n)                 sel <= 1'b0;
        else if (btn_d2 && !btn_d1) sel <= ~sel;
    end

    // pixel co nam trong o anh khong
    wire in_dog  = (x >= DOG_X0)  && (x < DOG_X0 + DOG_W)
                && (y >= DOG_Y0)  && (y < DOG_Y0 + DOG_H);
    wire in_woof = (x >= WOOF_X0) && (x < WOOF_X0 + WOOF_W)
                && (y >= WOOF_Y0) && (y < WOOF_Y0 + WOOF_H);

    // dia chi ROM = hang * do rong + cot
    // ngoai o anh thi dia chi sai, nhung bi che boi in_dog / in_woof
    wire [15:0] addr_dog  = (y - DOG_Y0)  * DOG_W  + (x - DOG_X0);
    wire [16:0] addr_woof = (y - WOOF_Y0) * WOOF_W + (x - WOOF_X0);

    // 2 ROM (Quartus dat vao M9K), doc dong bo: q co sau 1 clk
    reg [2:0] rom_dog  [0:DOG_N-1];
    reg [2:0] rom_woof [0:WOOF_N-1];
    initial begin
        $readmemh(DOG_FILE,  rom_dog);
        $readmemh(WOOF_FILE, rom_woof);
    end

    reg [2:0] q_dog, q_woof;
    always @(posedge clk) begin
        q_dog  <= rom_dog[addr_dog];
        q_woof <= rom_woof[addr_woof];
    end

    // chon anh theo sel
    wire [2:0] pix    = sel ? q_woof  : q_dog;
    wire       in_img = sel ? in_woof : in_dog;

    // vung hien thi
    wire visible = (x < H_VIS) && (y < V_VIS);
    wire show    = visible & in_img;
    // q ra sau 1 clk, x y giu nguyen 2 clk -> van khop voi hsync vsync
    always @(posedge clk)
        if (pix_en) begin
            hsync <= ~((x >= H_VIS+H_FP) && (x < H_VIS+H_FP+H_SYNC));
            vsync <= ~((y >= V_VIS+V_FP) && (y < V_VIS+V_FP+V_SYNC));
            r <= show & pix[2];
            g <= show & pix[1];
            b <= show & pix[0];
        end
endmodule
