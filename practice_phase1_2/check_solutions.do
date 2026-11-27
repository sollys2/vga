# Kiem tra bo testbench bang loi giai mau (chay 1 lan sau khi tai ve).
#   vsim -c -do "do check_solutions.do; quit -f"
# Ket qua mong doi: ca 8 bai PASS. Khong ghi vao progress.md cua ban.
set SRC solutions
do run_all.do
unset SRC
