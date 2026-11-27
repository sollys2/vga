// =====================================================================
// BAI 01 - Tao xung cho phep pixel (pix_en) 25 MHz tu clock 50 MHz
// Tuong ung: vga_phase1_2.sv dong 42-45
// ---------------------------------------------------------------------
// Yeu cau:
//   - Dong bo theo canh len clk, reset dong bo muc thap (rst_n = 0).
//   - Khi reset: pix_en = 0.
//   - Sau reset: pix_en dao gia tri moi chu ky clk -> 0,1,0,1,...
//     => pix_en = 1 dung 1 trong 2 chu ky = "1 pixel moi 2 clk" (25 MHz).
// Cau hoi suy nghi: vi sao khong tao clock 25 MHz rieng ma dung "enable"?
// =====================================================================
module ex01_pix_en (
    input  wire clk,
    input  wire rst_n,
    output reg  pix_en
);
    // TODO: viet code o day

endmodule
