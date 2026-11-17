# Creates the DE0-Nano project. Run: quartus_sh -t setup.tcl
project_new vga -overwrite
set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE EP4CE22F17C6
set_global_assignment -name TOP_LEVEL_ENTITY vga
set_global_assignment -name SYSTEMVERILOG_FILE ../rtl/vga.sv
set_global_assignment -name SDC_FILE vga.sdc
set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (SystemVerilog)"
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"

# DE0-Nano onboard
set_location_assignment PIN_R8  -to clk    ;# CLOCK_50
set_location_assignment PIN_J15 -to rst_n  ;# KEY[0]
set_location_assignment PIN_E1  -to btn_n  ;# KEY[1]

# VGA on GPIO-0 header JP1 (header pin in comment); DE0-Nano has no VGA port.
set_location_assignment PIN_D3 -to hsync   ;# GPIO_0[0], JP1 pin 2
set_location_assignment PIN_C3 -to vsync   ;# GPIO_0[1], JP1 pin 4
set_location_assignment PIN_A2 -to r       ;# GPIO_0[2], JP1 pin 5
set_location_assignment PIN_A3 -to g       ;# GPIO_0[3], JP1 pin 6
set_location_assignment PIN_B3 -to b       ;# GPIO_0[4], JP1 pin 7
project_close
