`timescale 1ns/1ps
module tb_ex02;
    localparam HT = 7, VT = 5;
    reg  clk = 0, rst_n = 0, en = 0;
    wire [9:0] x, y;
    integer errors = 0;
    ex02_xy_counter #(.H_TOTAL(HT), .V_TOTAL(VT)) dut (.clk(clk), .rst_n(rst_n), .en(en), .x(x), .y(y));
    always #10 clk = ~clk;

    // ---------- ket thuc + ghi ket qua ----------
    reg [8*128-1:0] res_path;
    initial if (!$value$plusargs("RES=%s", res_path)) res_path = "results/ex02.txt";
    task finish_test;
        integer fd;
        begin
            fd = $fopen(res_path, "w");
            if (errors == 0) $fwrite(fd, "PASS\n");
            else             $fwrite(fd, "FAIL %0d\n", errors);
            $fclose(fd);
            if (errors == 0) $display("RESULT ex02 PASS");
            else             $display("RESULT ex02 FAIL (%0d loi)", errors);
            $finish;
        end
    endtask
    task err(input [8*256-1:0] msg);
        begin
            errors = errors + 1;
            if (errors <= 10) $display("LOI t=%0t: %0s", $time, msg);
        end
    endtask

    reg [9:0] ex_, ey_; integer cyc = 0, wraps = 0;
    always @(posedge clk) begin
        cyc <= cyc + 1;
        if (!rst_n) begin ex_ <= 0; ey_ <= 0; end
        else if (en) begin
            if (ex_ == HT-1) begin
                ex_ <= 0;
                if (ey_ == VT-1) begin ey_ <= 0; wraps <= wraps + 1; end
                else ey_ <= ey_ + 1;
            end else ex_ <= ex_ + 1;
        end
    end
    always @(negedge clk) begin
        if (cyc >= 1 && (x !== ex_ || y !== ey_))
            err($sformatf("chu ky %0d (en vua qua = %b): (x,y) = (%0d,%0d), mong doi (%0d,%0d)", cyc, en, x, y, ex_, ey_));
        en <= rst_n ? $random : 1'b0;
    end
    initial begin
        repeat (3) @(posedge clk); #1 rst_n = 1;
        repeat (400) @(posedge clk); #1;
        if (wraps < 1) err("y chua quay ve 0 lan nao");
        finish_test;
    end
endmodule
