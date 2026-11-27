`timescale 1ns/1ps
module tb_ex06;
    reg        mode = 0;
    reg  [9:0] x = 0, y = 0;
    wire [2:0] r, g, b;
    integer errors = 0, yi, m;
    reg [8:0] e;
    ex06_render dut (.mode(mode), .x(x), .y(y), .r(r), .g(g), .b(b));

    // ---------- ket thuc + ghi ket qua ----------
    reg [8*128-1:0] res_path;
    initial if (!$value$plusargs("RES=%s", res_path)) res_path = "results/ex06.txt";
    task finish_test;
        integer fd;
        begin
            fd = $fopen(res_path, "w");
            if (errors == 0) $fwrite(fd, "PASS\n");
            else             $fwrite(fd, "FAIL %0d\n", errors);
            $fclose(fd);
            if (errors == 0) $display("RESULT ex06 PASS");
            else             $display("RESULT ex06 FAIL (%0d loi)", errors);
            $finish;
        end
    endtask
    task err(input [8*256-1:0] msg);
        begin
            errors = errors + 1;
            if (errors <= 10) $display("LOI t=%0t: %0s", $time, msg);
        end
    endtask

    function [8:0] pride(input integer yy);
        if      (yy <  80) pride = {3'd6,3'd0,3'd0};
        else if (yy < 160) pride = {3'd7,3'd4,3'd0};
        else if (yy < 240) pride = {3'd7,3'd7,3'd0};
        else if (yy < 320) pride = {3'd0,3'd4,3'd1};
        else if (yy < 400) pride = {3'd0,3'd2,3'd7};
        else               pride = {3'd3,3'd0,3'd4};
    endfunction
    function [8:0] pan(input integer yy);
        if      (yy < 160) pan = {3'd7,3'd1,3'd4};
        else if (yy < 320) pan = {3'd7,3'd6,3'd0};
        else               pan = {3'd1,3'd5,3'd7};
    endfunction

    initial begin
        for (m = 0; m < 2; m = m + 1)
            for (yi = 0; yi < 480; yi = yi + 1) begin
                mode = m; y = yi; x = {$random} % 640; #1;
                e = m ? pan(yi) : pride(yi);
                if ({r,g,b} !== e)
                    err($sformatf("mode=%0d y=%0d: (r,g,b) = (%0d,%0d,%0d), mong doi (%0d,%0d,%0d)", m, yi, r, g, b, e[8:6], e[5:3], e[2:0]));
            end
        finish_test;
    end
endmodule
