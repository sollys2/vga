`timescale 1ns/1ps
module tb_ex01;
    reg  clk = 0, rst_n = 0;
    wire pix_en;
    integer errors = 0;
    ex01_pix_en dut (.clk(clk), .rst_n(rst_n), .pix_en(pix_en));
    always #10 clk = ~clk;

    // ---------- ket thuc + ghi ket qua ----------
    reg [8*128-1:0] res_path;
    initial if (!$value$plusargs("RES=%s", res_path)) res_path = "results/ex01.txt";
    task finish_test;
        integer fd;
        begin
            fd = $fopen(res_path, "w");
            if (errors == 0) $fwrite(fd, "PASS\n");
            else             $fwrite(fd, "FAIL %0d\n", errors);
            $fclose(fd);
            if (errors == 0) $display("RESULT ex01 PASS");
            else             $display("RESULT ex01 FAIL (%0d loi)", errors);
            $finish;
        end
    endtask
    task err(input [8*256-1:0] msg);
        begin
            errors = errors + 1;
            if (errors <= 10) $display("LOI t=%0t: %0s", $time, msg);
        end
    endtask

    // mo hinh tham chieu
    reg exp; integer cyc = 0, highs = 0;
    always @(posedge clk) begin
        cyc <= cyc + 1;
        if (!rst_n) exp <= 1'b0; else exp <= ~exp;
    end
    always @(negedge clk) if (cyc >= 1) begin
        if (pix_en !== exp) err($sformatf("chu ky %0d: pix_en = %b, mong doi %b", cyc, pix_en, exp));
        if (rst_n && pix_en === 1'b1) highs = highs + 1;
    end
    initial begin
        repeat (4) @(posedge clk); #1 rst_n = 1;
        repeat (100) @(posedge clk); #1;
        if (highs < 49 || highs > 51) err($sformatf("100 chu ky co %0d chu ky pix_en=1, mong doi ~50", highs));
        finish_test;
    end
endmodule
