`timescale 1ns/1ps
// tb don gian cho vga_phase1
// - chay 1 frame anh cho, bam nut, chay 1 frame anh woof
// - luu moi frame thanh file anh frame0.ppm, frame1.ppm (mo bang GIMP / IrfanView)
// - kiem tra: do rong hsync, vsync, sel doi khi bam nut
module tb_vga_phase1;
    reg  clk   = 0;
    reg  rst_n = 0;
    reg  btn_n = 1;
    wire hsync, vsync, r, g, b;
    vga_phase1 dut (.clk(clk), .rst_n(rst_n), .btn_n(btn_n),
                    .hsync(hsync), .vsync(vsync), .r(r), .g(g), .b(b));

    always #10 clk = ~clk;   // 20 ns -> 50 MHz

    // ---------------- chup 1 frame ----------------
    // r g b la FF: sau canh pix_en, r g b la mau cua pixel (x, y) truoc canh do
    reg [9:0] px, py;
    always @(posedge clk)
        if (dut.pix_en) begin
            px <= dut.x;
            py <= dut.y;
        end

    reg [2:0] img [0:640*480-1];   // {r,g,b} cua tung pixel
    integer   frame = 0;
    integer   f, i;
    always @(negedge clk)
        if (rst_n && dut.pix_en == 1'b0 && px < 640 && py < 480) begin
            img[py*640 + px] = {r, g, b};
            if (px == 639 && py == 479) begin   // pixel cuoi -> ghi file
                f = $fopen($sformatf("frame%0d.ppm", frame), "w");
                $fwrite(f, "P3\n640 480\n1\n");  // anh mau, moi kenh 0 hoac 1
                for (i = 0; i < 640*480; i = i + 1)
                    $fwrite(f, "%0d %0d %0d\n", img[i][2], img[i][1], img[i][0]);
                $fclose(f);
                $display("[%0t] da luu frame%0d.ppm (sel = %0d)", $time, frame, dut.sel);
                frame = frame + 1;
            end
        end

    // ---------------- kiem tra hsync, vsync ----------------
    // hsync thap 96 pixel = 192 clk, vsync thap 2 dong = 2*800*2 clk
    integer hs_cnt = 0, vs_cnt = 0, errors = 0;
    always @(posedge clk) begin
        if (!hsync) hs_cnt = hs_cnt + 1;
        else if (hs_cnt != 0) begin
            if (hs_cnt != 192) begin
                $display("LOI: hsync thap %0d clk, mong doi 192", hs_cnt);
                errors = errors + 1;
            end
            hs_cnt = 0;
        end
        if (!vsync) vs_cnt = vs_cnt + 1;
        else if (vs_cnt != 0) begin
            if (vs_cnt != 3200) begin
                $display("LOI: vsync thap %0d clk, mong doi 3200", vs_cnt);
                errors = errors + 1;
            end
            vs_cnt = 0;
        end
    end

    // ---------------- kich thich ----------------
    initial begin
        #100 rst_n = 1;

        wait (frame == 1);                 // xong 1 frame anh cho
        if (dut.sel !== 1'b0) begin $display("LOI: sau reset sel phai = 0"); errors = errors + 1; end

        btn_n = 0; #100 btn_n = 1;         // bam KEY1 -> doi sang woof
        #100;
        if (dut.sel !== 1'b1) begin $display("LOI: bam nut ma sel khong doi"); errors = errors + 1; end

        wait (frame == 2);                 // xong 1 frame anh woof
        if (errors == 0) $display("PASS: khong co loi");
        else             $display("FAIL: %0d loi", errors);
        $finish;
    end
endmodule
