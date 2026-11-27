// =====================================================================
// BAI 07 - Tang thanh ghi dau ra + ep den ngoai vung hien thi
// Tuong ung: vga_phase1_2.sv dong 78-92
// ---------------------------------------------------------------------
// Yeu cau:
//   - Reset dong bo (rst_n = 0): hsync = 1, vsync = 1, r = g = b = 0.
//   - Khi pix_en = 1 (tai canh len clk):
//       hsync <= hsync_i;  vsync <= vsync_i;
//       r/g/b <= visible ? ri/gi/bi : 0;
//   - Khi pix_en = 0: giu nguyen tat ca.
// Cau hoi suy nghi: vi sao phai cho hsync, vsync, rgb qua CUNG mot tang
//                   thanh ghi? Neu rgb ra som hon hsync 1 pixel thi sao?
// =====================================================================
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
    // TODO: viet code o day

endmodule
