// =====================================================================
// BAI 08 - Ghep tat ca thanh bo dieu khien VGA hoan chinh
// Tuong ung: toan bo vga_phase1_2.sv
// ---------------------------------------------------------------------
// Yeu cau:
//   - Hanh vi phai GIONG HET rtl/vga_phase1_2.sv tung chu ky clk
//     (tb chay song song 2 thiet ke va so sanh hsync, vsync, r, g, b).
//   - Goi y: instantiate cac module bai 01..07:
//       ex01_pix_en -> pix_en
//       ex02_xy_counter (en = pix_en, H_TOTAL = 800, V_TOTAL = 525) -> x, y
//       ex04_btn_toggle -> mode
//       ex06_render (mode, x, y) -> mau
//       ex03_sync_decode (x, y) -> hsync_i, vsync_i, visible
//       ex07_out_stage -> hsync, vsync, r, g, b
//   - KHONG dat ten module la "render" hay "vga_phase1_2" (trung voi ban goc).
// Cau hoi suy nghi: ve so do khoi cua bai nay truoc khi viet code.
// =====================================================================
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
    // TODO: viet code o day

endmodule
