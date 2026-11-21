# QuestaSim: compile + simulate tb_phase1 with waves. Run from sim/: vsim -do run_phase1.do
if {![file exists work]} { vlib work }
vlog -sv ../rtl/vga_phase1.sv ../tb/tb_phase1.sv
# +acc keeps signal names visible; without it vopt optimizes them away
vsim -onfinish stop -voptargs=+acc work.tb_vga_phase1
add wave /tb_vga_phase1/clk /tb_vga_phase1/rst_n /tb_vga_phase1/btn_n
add wave /tb_vga_phase1/dut/sel
add wave /tb_vga_phase1/hsync /tb_vga_phase1/vsync
add wave /tb_vga_phase1/r /tb_vga_phase1/g /tb_vga_phase1/b
add wave -radix unsigned /tb_vga_phase1/dut/x /tb_vga_phase1/dut/y
add wave /tb_vga_phase1/dut/show
run -all
wave zoom full
