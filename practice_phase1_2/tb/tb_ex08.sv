`timescale 1ns/1ps
// So sanh ex08_top voi ban goc rtl/vga_phase1_2.sv tung chu ky:
// 1 khung (co pride) -> bam KEY1 trong luc blanking -> 400 dong cua khung sau (pansexual)
module tb_ex08;
    reg  clk = 0, rst_n = 0, btn_n = 1;
    wire       hs_s, vs_s, hs_g, vs_g;
    wire [2:0] r_s, g_s, b_s, r_g, g_g, b_g;
    integer errors = 0;
    integer cyc = 0;
    ex08_top     stu  (.clk(clk), .rst_n(rst_n), .btn_n(btn_n),
                       .hsync(hs_s), .vsync(vs_s), .r(r_s), .g(g_s), .b(b_s));
    vga_phase1_2 gold (.clk(clk), .rst_n(rst_n), .btn_n(btn_n),
                       .hsync(hs_g), .vsync(vs_g), .r(r_g), .g(g_g), .b(b_g));
    always #10 clk = ~clk;

    // ---------- ket thuc + ghi ket qua ----------
    reg [8*128-1:0] res_path;
    initial if (!$value$plusargs("RES=%s", res_path)) res_path = "results/ex08.txt";
    task finish_test;
        integer fd;
        begin
            fd = $fopen(res_path, "w");
            if (errors == 0) $fwrite(fd, "PASS\n");
            else             $fwrite(fd, "FAIL %0d\n", errors);
            $fclose(fd);
            if (errors == 0) $display("RESULT ex08 PASS");
            else             $display("RESULT ex08 FAIL (%0d loi)", errors);
            $finish;
        end
    endtask
    task err(input [8*256-1:0] msg);
        begin
            errors = errors + 1;
            if (errors <= 10) $display("LOI t=%0t: %0s", $time, msg);
        end
    endtask

    always @(posedge clk) cyc <= cyc + 1;
    always @(negedge clk)
        if (cyc >= 1 && {hs_s,vs_s,r_s,g_s,b_s} !== {hs_g,vs_g,r_g,g_g,b_g})
            err($sformatf("chu ky %0d (x=%0d,y=%0d): ban cua ban {hs,vs,r,g,b}={%b,%b,%0d,%0d,%0d}, ban goc={%b,%b,%0d,%0d,%0d}",
                          cyc, gold.x, gold.y, hs_s, vs_s, r_s, g_s, b_s, hs_g, vs_g, r_g, g_g, b_g));
    initial begin
        repeat (4) @(posedge clk); #1 rst_n = 1;
        repeat (790000) @(posedge clk); #1;        // ~ het vung hien thi khung 1 (480 dong x 1600 clk)
        btn_n = 0; repeat (20) @(posedge clk); #1 btn_n = 1;
        repeat (50000 + 400*1600) @(posedge clk); #1;
        if (gold.mode !== 1'b1) err("tb: ban goc chua doi mode (kiem tra lai tb)");
        finish_test;
    end
endmodule
