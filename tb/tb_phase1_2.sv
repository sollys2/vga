`timescale 1ns/1ps
// tb don gian cho vga_phase1_2
// - chay 1 frame (co pride), bam KEY1, chay 1 frame (co pansexual)
// - luu moi frame thanh frame0.ppm, frame1.ppm (mo bang GIMP / IrfanView)
// - kiem tra: do rong hsync/vsync, mode doi khi bam nut, mau giua moi soc
module tb_vga_phase1_2;
    reg  clk   = 0;
    reg  rst_n = 0;
    reg  btn_n = 1;
    wire       hsync, vsync;
    wire [2:0] r, g, b;

    vga_phase1_2 dut (.clk(clk), .rst_n(rst_n), .btn_n(btn_n),
                      .hsync(hsync), .vsync(vsync), .r(r), .g(g), .b(b));

    always #10 clk = ~clk;   // 20 ns -> 50 MHz

    integer errors = 0;

    // ---------------- chup 1 frame ----------------
    // r g b la FF: sau canh pix_en, r g b la mau cua pixel (x, y) truoc canh do
    reg [9:0] px, py;
    always @(posedge clk)
        if (dut.pix_en) begin
            px <= dut.x;
            py <= dut.y;
        end

    reg [8:0] img [0:640*480-1];   // {r[2:0], g[2:0], b[2:0]}
    integer   frame = 0;
    integer   f, i;

    // so sanh mau 1 pixel voi gia tri mong doi
    task check_pix(input [9:0] cx, input [9:0] cy, input [8:0] exp, input [8*16-1:0] name);
        if (img[cy*640 + cx] !== exp) begin
            $display("LOI frame%0d %0s (%0d,%0d): rgb = %0d%0d%0d, mong doi %0d%0d%0d",
                     frame, name, cx, cy,
                     img[cy*640+cx][8:6], img[cy*640+cx][5:3], img[cy*640+cx][2:0],
                     exp[8:6], exp[5:3], exp[2:0]);
            errors = errors + 1;
        end
    endtask

    always @(negedge clk)
        if (rst_n && dut.pix_en == 1'b0 && px < 640 && py < 480) begin
            img[py*640 + px] = {r, g, b};
            if (px == 639 && py == 479) begin   // pixel cuoi -> ghi file + kiem tra
                f = $fopen($sformatf("frame%0d.ppm", frame), "w");
                $fwrite(f, "P3\n640 480\n7\n");  // moi kenh 0..7
                for (i = 0; i < 640*480; i = i + 1)
                    $fwrite(f, "%0d %0d %0d\n", img[i][8:6], img[i][5:3], img[i][2:0]);
                $fclose(f);
                $display("[%0t] da luu frame%0d.ppm (mode = %0d)", $time, frame, dut.mode);

                // kiem tra giua moi soc (x = 320)
                if (frame == 0) begin            // co pride: 6 soc x 80 dong
                    check_pix(320,  40, {3'd6,3'd0,3'd0}, "do");
                    check_pix(320, 120, {3'd7,3'd4,3'd0}, "cam");
                    check_pix(320, 200, {3'd7,3'd7,3'd0}, "vang");
                    check_pix(320, 280, {3'd0,3'd4,3'd1}, "xanh la");
                    check_pix(320, 360, {3'd0,3'd2,3'd7}, "xanh duong");
                    check_pix(320, 440, {3'd3,3'd0,3'd4}, "tim");
                end else begin                   // co pansexual: 3 soc x 160 dong
                    check_pix(320,  80, {3'd7,3'd1,3'd4}, "hong");
                    check_pix(320, 240, {3'd7,3'd6,3'd0}, "vang");
                    check_pix(320, 400, {3'd1,3'd5,3'd7}, "xanh");
                end
                frame = frame + 1;
            end
        end

    // ngoai vung hien thi thi rgb phai = 0
    always @(negedge clk)
        if (rst_n && dut.pix_en == 1'b0 && (px >= 640 || py >= 480) && {r,g,b} !== 9'd0
            && frame < 2 && $time > 1000) begin
            $display("LOI: rgb khac 0 ngoai vung hien thi tai (%0d,%0d)", px, py);
            errors = errors + 1;
        end

    // ---------------- kiem tra hsync, vsync ----------------
    // hsync thap 96 pixel = 192 clk, vsync thap 2 dong = 2*800*2 clk
    integer hs_cnt = 0, vs_cnt = 0;
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

        wait (frame == 1);                 // xong 1 frame co pride
        if (dut.mode !== 1'b0) begin $display("LOI: sau reset mode phai = 0"); errors = errors + 1; end

        btn_n = 0; #100 btn_n = 1;         // bam KEY1 -> doi sang pansexual
        #100;
        if (dut.mode !== 1'b1) begin $display("LOI: bam nut ma mode khong doi"); errors = errors + 1; end

        wait (frame == 2);                 // xong 1 frame co pansexual
        if (errors == 0) $display("PASS: khong co loi");
        else             $display("FAIL: %0d loi", errors);
        $finish;
    end
endmodule
