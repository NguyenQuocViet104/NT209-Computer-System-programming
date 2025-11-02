# ===============================================
#  C3.s — Nhập 5 ký tự số (0–9), xác định số lớn nhất
#  Môi trường: Linux 64-bit, syscall cổ điển (int 0x80)
# ===============================================

.section .data
input:
    .ascii "Enter a number (1-digit) : "
input_len = . - input                 # Độ dài thông báo nhập

output:
    .ascii "Max number: "
output_len = . - output               # Độ dài chuỗi in kết quả

newline:
    .ascii "\n"
newline_len = . - newline             # Một byte xuống dòng

invalid:
    .ascii "Invalid input! Please enter a digit (0-9)\n"
invalid_len = . - invalid             # Thông báo lỗi nhập sai

.section .bss
    .lcomm num, 16                    # Bộ đệm đọc dữ liệu từ stdin
    .lcomm tmp, 1                     # Biến lưu giá trị lớn nhất hiện tại

.section .text
    .globl _start

_start:
    xorl %edi, %edi                   # Bộ đếm lượt nhập = 0
    movb $0, tmp                      # Giá trị lớn nhất ban đầu = 0
    jmp read_loop

# -----------------------------------------------
#  read_loop — xử lý 1 lần nhập từ bàn phím
# -----------------------------------------------
read_loop:
    # Gửi thông báo nhập
    movl $4, %eax                     # write syscall
    movl $1, %ebx                     # stdout
    movl $input, %ecx
    movl $input_len, %edx
    int $0x80

    # Đọc dòng nhập
    movl $3, %eax                     # read syscall
    xorl %ebx, %ebx                   # stdin
    movl $num, %ecx
    movl $16, %edx
    int $0x80
    testl %eax, %eax
    jle invalid_case                  # EOF / lỗi → xử lý sai

    # Nếu người dùng chỉ bấm Enter
    cmpl $1, %eax
    jne validate_input
    movb num, %al
    cmpb $'\n', %al
    je read_loop

# -----------------------------------------------
#  validate_input — xác định dữ liệu hợp lệ
# -----------------------------------------------
validate_input:
    leal num, %esi                    # %esi → đầu vùng num
    movb (%esi), %al                  # num[0]
    cmpb $'0', %al
    jl invalid_case
    cmpb $'9', %al
    jg invalid_case

    movb 1(%esi), %bl                 # num[1]
    cmpb $'\n', %bl
    jne invalid_case

# -----------------------------------------------
#  update_max — so sánh và cập nhật giá trị lớn nhất
# -----------------------------------------------
    subb $'0', %al                    # chuyển ký tự sang số 0–9
    movb tmp, %bl
    cmpb %bl, %al
    jle skip_update
    movb %al, tmp                     # ghi đè giá trị lớn nhất

skip_update:
    incl %edi                         # tăng bộ đếm lượt hợp lệ
    cmpl $5, %edi
    jne read_loop

# -----------------------------------------------
#  print_result — in giá trị lớn nhất sau 5 lượt
# -----------------------------------------------
    movb tmp, %al
    addb $'0', %al                    # đổi ngược thành ASCII
    movb %al, num                     # lưu để in

    # In tiêu đề
    movl $4, %eax
    movl $1, %ebx
    movl $output, %ecx
    movl $output_len, %edx
    int $0x80

    # In ký tự kết quả
    movl $4, %eax
    movl $1, %ebx
    movl $num, %ecx
    movl $1, %edx
    int $0x80

    # In xuống dòng
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $newline_len, %edx
    int $0x80

    # Kết thúc
    movl $1, %eax                     # exit(0)
    xorl %ebx, %ebx
    int $0x80

# -----------------------------------------------
#  invalid_case — xử lý khi nhập sai
# -----------------------------------------------
invalid_case:
    movl $4, %eax                     # write thông báo lỗi
    movl $1, %ebx
    movl $invalid, %ecx
    movl $invalid_len, %edx
    int $0x80
    jmp read_loop
