# QuestaSim: compile + simulate tb_phase1_2 with waves. Run from sim/: vsim -do run_phase1_2.do
if {![file exists work]} { vlib work }
vlog -sv ../rtl/vga_phase1_2.sv ../tb/tb_phase1_2.sv
# +acc keeps signal names visible; without it vopt optimizes them away
vsim -onfinish stop -voptargs=+acc work.tb_vga_phase1_2
add wave /tb_vga_phase1_2/clk /tb_vga_phase1_2/rst_n /tb_vga_phase1_2/btn_n
add wave /tb_vga_phase1_2/dut/mode
add wave /tb_vga_phase1_2/hsync /tb_vga_phase1_2/vsync
add wave -radix unsigned /tb_vga_phase1_2/r /tb_vga_phase1_2/g /tb_vga_phase1_2/b
add wave -radix unsigned /tb_vga_phase1_2/dut/x /tb_vga_phase1_2/dut/y
add wave /tb_vga_phase1_2/dut/visible
run -all
wave zoom full
