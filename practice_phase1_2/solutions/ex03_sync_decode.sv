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
    assign visible = (x < H_VIS) && (y < V_VIS);
    assign hsync   = ~((x >= H_VIS+H_FP) && (x < H_VIS+H_FP+H_SYNC));
    assign vsync   = ~((y >= V_VIS+V_FP) && (y < V_VIS+V_FP+V_SYNC));
endmodule
