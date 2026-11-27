// =====================================================================
// BAI 03 - Giai ma hsync, vsync, visible tu (x, y)   (mach TO HOP)
// Tuong ung: vga_phase1_2.sv dong 75-76 va 87-88
// ---------------------------------------------------------------------
// Yeu cau (tat ca la to hop, dung assign):
//   - visible = 1 khi x < H_VIS va y < V_VIS
//   - hsync   = 0 khi H_VIS+H_FP <= x < H_VIS+H_FP+H_SYNC   (656..751), con lai = 1
//   - vsync   = 0 khi V_VIS+V_FP <= y < V_VIS+V_FP+V_SYNC   (490..491), con lai = 1
// Cau hoi suy nghi: vi sao hsync/vsync la xung AM (muc 0 khi retrace)?
// =====================================================================
module ex03_sync_decode #(
    parameter H_VIS  = 640,
    parameter H_FP   = 16,
    parameter H_SYNC = 96,
    parameter H_BP   = 48,
    parameter V_VIS  = 480,
    parameter V_FP   = 10,
    parameter V_SYNC = 2,
    parameter V_BP   = 33
)(
    input  wire [9:0] x,
    input  wire [9:0] y,
    output wire       hsync,
    output wire       vsync,
    output wire       visible
);
    // TODO: viet code o day

endmodule
