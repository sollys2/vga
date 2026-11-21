// Waveform dump for Icarus/GTKWave; works with any testbench (dumps every signal).
module dump;
    initial begin
        $dumpfile("wave.fst");
        $dumpvars;
    end
endmodule
