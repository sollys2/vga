// Waveform dump for Icarus/GTKWave; kept separate so tb.sv stays untouched.
module dump;
    initial begin
        $dumpfile("tb_vga.fst");
        $dumpvars(0, tb_vga);
    end
endmodule
