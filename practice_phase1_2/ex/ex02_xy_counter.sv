// =====================================================================
// BAI 02 - Bo dem toa do x (cot) va y (dong)
// Tuong ung: vga_phase1_2.sv dong 47-59
// ---------------------------------------------------------------------
// Yeu cau:
//   - Reset dong bo (rst_n = 0): x = 0, y = 0.
//   - Chi dem khi en = 1 (en chinh la pix_en cua bai 01); en = 0 thi giu nguyen.
//   - x dem 0,1,...,H_TOTAL-1 roi quay ve 0.
//   - Moi lan x quay ve 0 thi y tang 1; y dem 0..V_TOTAL-1 roi quay ve 0.
//   - Dung tham so H_TOTAL, V_TOTAL (tb se thu voi so nho, vd 7 va 5).
// Cau hoi suy nghi: vi sao x can 10 bit? y can toi thieu bao nhieu bit?
// =====================================================================
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
    // TODO: viet code o day

endmodule
