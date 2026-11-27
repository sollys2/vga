`timescale 1ns/1ps
module tb_ex03;
    reg  [9:0] x = 0, y = 0;
    wire hsync, vsync, visible;
    integer errors = 0, i, xi, yi;
    ex03_sync_decode dut (.x(x), .y(y), .hsync(hsync), .vsync(vsync), .visible(visible));

    // ---------- ket thuc + ghi ket qua ----------
    reg [8*128-1:0] res_path;
    initial if (!$value$plusargs("RES=%s", res_path)) res_path = "results/ex03.txt";
    task finish_test;
        integer fd;
        begin
            fd = $fopen(res_path, "w");
            if (errors == 0) $fwrite(fd, "PASS\n");
            else             $fwrite(fd, "FAIL %0d\n", errors);
            $fclose(fd);
            if (errors == 0) $display("RESULT ex03 PASS");
            else             $display("RESULT ex03 FAIL (%0d loi)", errors);
            $finish;
        end
    endtask
    task err(input [8*256-1:0] msg);
        begin
            errors = errors + 1;
            if (errors <= 10) $display("LOI t=%0t: %0s", $time, msg);
        end
    endtask

    task check;
        reg eh, ev, evis;
        begin
            #1;
            eh   = !((x >= 656) && (x < 752));
            ev   = !((y >= 490) && (y < 492));
            evis = (x < 640) && (y < 480);
            if (hsync !== eh)    err($sformatf("(x,y)=(%0d,%0d): hsync = %b, mong doi %b", x, y, hsync, eh));
            if (vsync !== ev)    err($sformatf("(x,y)=(%0d,%0d): vsync = %b, mong doi %b", x, y, vsync, ev));
            if (visible !== evis) err($sformatf("(x,y)=(%0d,%0d): visible = %b, mong doi %b", x, y, visible, evis));
        end
    endtask
    initial begin
        for (xi = 0; xi < 800; xi = xi + 1) begin x = xi; y = 0;   check; end
        for (yi = 0; yi < 525; yi = yi + 1) begin x = 0;  y = yi;  check; end
        for (i = 0; i < 3000; i = i + 1) begin x = {$random} % 800; y = {$random} % 525; check; end
        finish_test;
    end
endmodule
