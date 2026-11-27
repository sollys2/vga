`timescale 1ns/1ps
module tb_ex07;
    reg clk = 0, rst_n = 0, pix_en = 0, hsync_i = 1, vsync_i = 1, visible = 0;
    reg [2:0] ri = 0, gi = 0, bi = 0;
    wire hsync, vsync;
    wire [2:0] r, g, b;
    integer errors = 0;
    ex07_out_stage dut (.clk(clk), .rst_n(rst_n), .pix_en(pix_en), .hsync_i(hsync_i), .vsync_i(vsync_i),
                        .visible(visible), .ri(ri), .gi(gi), .bi(bi),
                        .hsync(hsync), .vsync(vsync), .r(r), .g(g), .b(b));
    always #10 clk = ~clk;

    // ---------- ket thuc + ghi ket qua ----------
    reg [8*128-1:0] res_path;
    initial if (!$value$plusargs("RES=%s", res_path)) res_path = "results/ex07.txt";
    task finish_test;
        integer fd;
        begin
            fd = $fopen(res_path, "w");
            if (errors == 0) $fwrite(fd, "PASS\n");
            else             $fwrite(fd, "FAIL %0d\n", errors);
            $fclose(fd);
            if (errors == 0) $display("RESULT ex07 PASS");
            else             $display("RESULT ex07 FAIL (%0d loi)", errors);
            $finish;
        end
    endtask
    task err(input [8*256-1:0] msg);
        begin
            errors = errors + 1;
            if (errors <= 10) $display("LOI t=%0t: %0s", $time, msg);
        end
    endtask

    reg eh, ev; reg [2:0] er, eg, eb; integer cyc = 0;
    always @(posedge clk) begin
        cyc <= cyc + 1;
        if (!rst_n) begin eh <= 1; ev <= 1; er <= 0; eg <= 0; eb <= 0; end
        else if (pix_en) begin
            eh <= hsync_i; ev <= vsync_i;
            er <= visible ? ri : 3'd0; eg <= visible ? gi : 3'd0; eb <= visible ? bi : 3'd0;
        end
    end
    always @(negedge clk) begin
        if (cyc >= 1 && {hsync,vsync,r,g,b} !== {eh,ev,er,eg,eb})
            err($sformatf("chu ky %0d: {hs,vs,r,g,b} = {%b,%b,%0d,%0d,%0d}, mong doi {%b,%b,%0d,%0d,%0d}",
                          cyc, hsync, vsync, r, g, b, eh, ev, er, eg, eb));
        // kich thich ngau nhien cho canh len tiep theo
        pix_en  <= $random; hsync_i <= $random; vsync_i <= $random; visible <= $random;
        ri <= $random; gi <= $random; bi <= $random;
    end
    initial begin
        repeat (4) @(posedge clk); #1 rst_n = 1;
        repeat (2000) @(posedge clk); #1;
        finish_test;
    end
endmodule
