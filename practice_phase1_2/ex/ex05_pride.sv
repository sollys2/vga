// =====================================================================
// BAI 05 - Khoi render co pride (mach TO HOP, chi phu thuoc y)
// Tuong ung: vga_phase1_2.sv dong 113-130
// ---------------------------------------------------------------------
// Yeu cau: 6 soc ngang, moi soc 80 dong (y = 0..479). Mau 3 bit moi kenh:
//   y   0.. 79 : do        (r,g,b) = (6,0,0)
//   y  80..159 : cam       (7,4,0)
//   y 160..239 : vang      (7,7,0)
//   y 240..319 : xanh la   (0,4,1)
//   y 320..399 : xanh duong(0,2,7)
//   y 400..479 : tim       (3,0,4)
// Goi y: always @(*) + chuoi if / else if. Nho gan DU r, g, b o moi nhanh
//        (thieu se sinh latch).
// Cau hoi suy nghi: (7,4,0) tao ra dien ap bao nhieu tren chan RED/GREEN?
// =====================================================================
module ex05_pride (
    input  wire [9:0] y,
    output reg  [2:0] r,
    output reg  [2:0] g,
    output reg  [2:0] b
);
    // TODO: viet code o day

endmodule
