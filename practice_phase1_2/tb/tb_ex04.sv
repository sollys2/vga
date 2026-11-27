`timescale 1ns/1ps
module tb_ex04;
    reg  clk = 0, rst_n = 0, btn_n = 1;
    wire mode;
    integer errors = 0;
    reg exp_mode = 0;
    ex04_btn_toggle dut (.clk(clk), .rst_n(rst_n), .btn_n(btn_n), .mode(mode));
    always #10 clk = ~clk;

    // ---------- ket thuc + ghi ket qua ----------
    reg [8*128-1:0] res_path;
    initial if (!$value$plusargs("RES=%s", res_path)) res_path = "results/ex04.txt";
    task finish_test;
        integer fd;
        begin
            fd = $fopen(res_path, "w");
            if (errors == 0) $fwrite(fd, "PASS\n");
            else             $fwrite(fd, "FAIL %0d\n", errors);
            $fclose(fd);
            if (errors == 0) $display("RESULT ex04 PASS");
            else             $display("RESULT ex04 FAIL (%0d loi)", errors);
            $finish;
        end
    endtask
    task err(input [8*256-1:0] msg);
        begin
            errors = errors + 1;
            if (errors <= 10) $display("LOI t=%0t: %0s", $time, msg);
        end
    endtask

    // nhan nut trong 'hold' chu ky, roi tha 10 chu ky
    task press(input integer hold);
        integer k;
        begin
            @(posedge clk); #1 btn_n = 0;
            exp_mode = ~exp_mode;
            for (k = 0; k < hold; k = k + 1) begin
                @(posedge clk); #1;
                if (k >= 3 && mode !== exp_mode)
                    err($sformatf("dang giu nut (chu ky %0d): mode = %b, mong doi %b", k, mode, exp_mode));
            end
            btn_n = 1;
            repeat (10) @(posedge clk); #1;
            if (mode !== exp_mode)
                err($sformatf("sau khi nhan %0d chu ky va tha: mode = %b, mong doi %b", hold, mode, exp_mode));
        end
    endtask
    initial begin
        repeat (4) @(posedge clk); #1 rst_n = 1;
        repeat (3) @(posedge clk); #1;
        if (mode !== 1'b0) err($sformatf("sau reset mode = %b, mong doi 0", mode));
        press(5);     // -> 1
        press(50);    // giu lau -> 0 (chi dao 1 lan)
        press(1);     // nhan 1 chu ky -> 1
        press(8);     // -> 0
        finish_test;
    end
endmodule
