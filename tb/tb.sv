`timescale 1ns/1ps
module tb_vga;
    reg  clk   = 0;
    reg  rst_n = 0;
    reg  btn_n = 1;
    wire hsync, vsync, r, g, b;
    vga dut (.clk(clk), .rst_n(rst_n), .btn_n(btn_n),
             .hsync(hsync), .vsync(vsync), .r(r), .g(g), .b(b));

    always #10 clk = ~clk;   
    initial begin
        #100 rst_n = 1;
        #20000000; //rst xong cho 20ms 

        btn_n = 0; #20 btn_n = 1; // nhan nut=> tat man
        #20000000; //cho 20ms   

        btn_n = 0; #20 btn_n = 1; // nhan nut=> bat man
        #20000000; //cho 20ms
        $stop;
    end
endmodule