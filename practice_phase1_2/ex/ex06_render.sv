// =====================================================================
// BAI 06 - Khoi render day du: chon co theo mode
// Tuong ung: vga_phase1_2.sv dong 96-147 (module render)
// ---------------------------------------------------------------------
// Yeu cau (mach TO HOP):
//   - mode = 0: co pride (giong bai 05). Ban co the instantiate ex05_pride.
//   - mode = 1: co pansexual, 3 soc moi soc 160 dong:
//       y   0..159 : hong  (7,1,4)
//       y 160..319 : vang  (7,6,0)
//       y 320..479 : xanh  (1,5,7)
//   - x chua dung toi (de san), nhung van phai co cong x.
// Cau hoi suy nghi: muon ve co soc DOC thi doi y thanh gi?
// =====================================================================
module ex06_render (
    input  wire       mode,
    input  wire [9:0] x,
    input  wire [9:0] y,
    output reg  [2:0] r,
    output reg  [2:0] g,
    output reg  [2:0] b
);
    // TODO: viet code o day

endmodule
