// =====================================================================
// BAI 04 - Nut bam KEY1: dong bo 2 tang FF + bat canh xuong -> dao mode
// Tuong ung: vga_phase1_2.sv dong 61-67
// ---------------------------------------------------------------------
// Yeu cau:
//   - btn_n la nut tich cuc muc thap (nhan = 0), KHONG dong bo voi clk.
//   - Cho btn_n qua 2 FF: btn_d1 <= btn_n; btn_d2 <= btn_d1;
//   - Khi btn_d2 = 1 va btn_d1 = 0 (vua chuyen 1 -> 0 = vua nhan) thi mode <= ~mode.
//   - Reset dong bo (rst_n = 0): mode = 0.
//   - Giu nut lau van chi dao 1 lan; tha nut khong dao.
// Cau hoi suy nghi: vi sao can 2 FF truoc khi dung btn_n? (metastability)
// =====================================================================
module ex04_btn_toggle (
    input  wire clk,
    input  wire rst_n,
    input  wire btn_n,
    output reg  mode
);
    // TODO: viet code o day

endmodule
