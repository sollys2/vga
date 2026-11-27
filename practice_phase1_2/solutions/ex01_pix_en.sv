module ex01_pix_en (
    input  wire clk,
    input  wire rst_n,
    output reg  pix_en
);
    always @(posedge clk)
        if (!rst_n) pix_en <= 1'b0;
        else        pix_en <= ~pix_en;
endmodule
