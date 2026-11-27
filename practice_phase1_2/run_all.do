# =====================================================================
# Chay va cham diem bai tap. Mo QuestaSim, cd vao thu muc practice_phase1_2:
#   Tat ca bai :  vsim -c -do "do run_all.do; quit -f"
#   Mot bai    :  vsim -c -do "do run_all.do ex03; quit -f"
# Ket qua: in ra man hinh, results/exNN.txt, progress.md (bang tong), history.csv (lich su)
# =====================================================================
if {![info exists SRC]} { set SRC ex }
if {$SRC eq "ex"} { set RESDIR results } else { set RESDIR results_sol }
file mkdir $RESDIR
if {![file exists work]} { vlib work }

set ALL {ex01_pix_en ex02_xy_counter ex03_sync_decode ex04_btn_toggle ex05_pride ex06_render ex07_out_stage}
set EXS [list \
  [list ex01 {ex01_pix_en}                  tb_ex01 {}] \
  [list ex02 {ex02_xy_counter}              tb_ex02 {}] \
  [list ex03 {ex03_sync_decode}             tb_ex03 {}] \
  [list ex04 {ex04_btn_toggle}              tb_ex04 {}] \
  [list ex05 {ex05_pride}                   tb_ex05 {}] \
  [list ex06 {ex05_pride ex06_render}       tb_ex06 {}] \
  [list ex07 {ex07_out_stage}               tb_ex07 {}] \
  [list ex08 [concat $ALL ex08_top]         tb_ex08 {../rtl/vga_phase1_2.sv}] ]

set ONLY ""
if {[info exists argc] && $argc >= 1} { set ONLY $1 }

proc read_result {f} {
    if {![file exists $f]} { return "CHUA CHAY" }
    set fd [open $f r]; set s [string trim [read $fd]]; close $fd
    return $s
}
proc write_result {f s} { set fd [open $f w]; puts $fd $s; close $fd }

foreach e $EXS {
    lassign $e id mods tb extra
    if {$ONLY ne "" && $ONLY ne $id} { continue }
    set resf $RESDIR/$id.txt
    file delete -force $resf
    set files {}
    foreach m $mods { lappend files $SRC/$m.sv }
    foreach x $extra { lappend files $x }
    lappend files tb/$tb.sv
    echo "===== $id ====="
    if {[catch {eval vlog -sv -quiet -timescale 1ns/1ps $files} msg]} {
        write_result $resf "COMPILE_ERROR"
    } elseif {[catch {vsim -quiet -onfinish stop +RES=$resf work.$tb} msg]} {
        write_result $resf "SIM_ERROR"
    } else {
        run -all
        quit -sim
        if {![file exists $resf]} { write_result $resf "NO_RESULT" }
    }
    set r [read_result $resf]
    echo ">>> $id: $r"
    if {$SRC eq "ex"} {
        set fd [open history.csv a]
        puts $fd "[clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}],$id,$r"
        close $fd
    }
}

# ----- bang tong ket -----
if {$SRC eq "ex"} {
    set TITLES {
        ex01 "Tao xung pix_en 25 MHz"
        ex02 "Bo dem x, y"
        ex03 "Giai ma hsync, vsync, visible"
        ex04 "Nut bam: dong bo 2 FF + bat canh"
        ex05 "Render co pride"
        ex06 "Render 2 co theo mode"
        ex07 "Tang thanh ghi dau ra + ep den"
        ex08 "Ghep top, so voi ban goc"
    }
    set npass 0
    set fd [open progress.md w]
    puts $fd "# Tien do bai tap vga_phase1_2\n"
    puts $fd "Cap nhat: [clock format [clock seconds] -format {%Y-%m-%d %H:%M}]\n"
    puts $fd "| Bai | Noi dung | Ket qua | Lan cham gan nhat |"
    puts $fd "|---|---|---|---|"
    foreach {id title} $TITLES {
        set f results/$id.txt
        set r [read_result $f]
        if {[string match "PASS*" $r]} { incr npass; set mark "DUNG" } elseif {$r eq "CHUA CHAY"} { set mark "-" } else { set mark "SAI" }
        if {[file exists $f]} { set t [clock format [file mtime $f] -format {%Y-%m-%d %H:%M}] } else { set t "-" }
        puts $fd "| $id | $title | $mark ($r) | $t |"
    }
    puts $fd "\n**Dung: $npass / 8**"
    close $fd
    echo "===== TONG: $npass / 8 bai dung (xem progress.md) ====="
}
