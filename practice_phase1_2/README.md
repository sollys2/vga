# Bài tập hiểu `rtl/vga_phase1_2.sv`

8 bài, mỗi bài là một khối nhỏ của bộ điều khiển VGA. Làm từ bài 01 đến 08; bài 08 ghép tất cả lại và được so sánh **từng chu kỳ clock** với file gốc.

| Bài | File cần sửa | Khối trong `vga_phase1_2.sv` | Dòng |
|---|---|---|---|
| 01 | `ex/ex01_pix_en.sv` | Tạo xung pix_en 25 MHz | 42–45 |
| 02 | `ex/ex02_xy_counter.sv` | Bộ đếm x, y | 47–59 |
| 03 | `ex/ex03_sync_decode.sv` | Giải mã hsync, vsync, visible | 75–76, 87–88 |
| 04 | `ex/ex04_btn_toggle.sv` | Nút KEY1: 2 FF + bắt cạnh | 61–67 |
| 05 | `ex/ex05_pride.sv` | Render cờ pride | 113–130 |
| 06 | `ex/ex06_render.sv` | Render 2 cờ theo mode | 96–147 |
| 07 | `ex/ex07_out_stage.sv` | Thanh ghi đầu ra + ép đen | 78–92 |
| 08 | `ex/ex08_top.sv` | Ghép toàn bộ | cả file |

Mỗi file trong `ex/` có sẵn khung module, yêu cầu và một câu hỏi suy nghĩ. Chỉ viết code vào chỗ `// TODO`, **không đổi tên module hay cổng**.

## Chấm điểm và theo dõi

Mở QuestaSim, `cd` vào thư mục này:

```
vsim -c -do "do run_all.do; quit -f"        # chấm tất cả
vsim -c -do "do run_all.do ex03; quit -f"   # chấm 1 bài
```

- Mỗi bài in `RESULT exNN PASS` hoặc `FAIL`, kèm tối đa 10 lỗi đầu tiên (giá trị đo được và giá trị mong đợi).
- `progress.md`: bảng tổng, bài nào ĐÚNG / SAI / chưa chạy, thời điểm chấm gần nhất.
- `history.csv`: lịch sử mọi lần chấm, để xem mình sai bao nhiêu lần trước khi đúng.
- Trạng thái lỗi khác: `COMPILE_ERROR` (lỗi cú pháp), `SIM_ERROR` (không nạp được thiết kế), `NO_RESULT` (testbench không chạy tới cuối).

Bài 08 dùng lại các module bài 01–07 trong `ex/`, nên cần làm xong chúng trước.

## Lời giải

`solutions/` có lời giải mẫu. **Đừng mở trước khi làm.** Chạy `vsim -c -do "do check_solutions.do; quit -f"` một lần để chắc bộ testbench chạy đúng trên máy bạn (cả 8 bài phải PASS); lệnh này không ghi vào `progress.md`.
