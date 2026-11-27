module ex04_btn_toggle (
    input  wire clk,
    input  wire rst_n,
    input  wire btn_n,
    output reg  mode
);
    reg btn_d1, btn_d2;
    always @(posedge clk) begin
        btn_d1 <= btn_n;
        btn_d2 <= btn_d1;
        if (!rst_n)                 mode <= 1'b0;
        else if (btn_d2 && !btn_d1) mode <= ~mode;
    end
endmodule
