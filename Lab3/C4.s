        .equ CURRENT_YEAR, 2025      
.section .data
prompt:         .ascii "Nhap nam sinh (YYYY): "
prompt_len = . - prompt

nl:             .ascii "\n"
nl_len      = . - nl

msg_young:      .ascii "Chua vao UIT\n"
msg_young_len = . - msg_young

msg_study:      .ascii "Dang hoc tai UIT\n"
msg_study_len = . - msg_study

msg_grad:       .ascii "Da tot nghiep\n"
msg_grad_len = . - msg_grad

msg_age:        .ascii "Tuoi hien tai: "
msg_age_len   = . - msg_age

msg_enter:      .ascii "Nam du kien vao UIT: "
msg_enter_len = . - msg_enter

msg_gradu:      .ascii "Nam tot nghiep: "
msg_gradu_len = . - msg_gradu

.section .bss
    .lcomm inbuf,   16      # buffer nhập (đủ chứa YYYY\n)
    .lcomm numbuf,  32      # buffer in số (tách biệt, tránh ghi đè)
    .lcomm year,     8      # năm sinh (int64)
    .lcomm age,      8      # tuổi hiện tại (int64)
    .lcomm calc,     8      # năm vào/tốt nghiệp (int64)

.section .text
    .globl _start

# ------------------------------------------------------------
# write_str — write(1, rsi, rdx)
# ------------------------------------------------------------
write_str:
    mov     $1, %rax
    mov     $1, %rdi
    syscall
    ret

# ------------------------------------------------------------
# print_num — in số không dấu trong RAX + '\n'
#   Sử dụng numbuf làm vùng đệm tạo chuỗi.
# ------------------------------------------------------------
print_num:
    mov     %rax, %r8
    lea     numbuf+31(%rip), %rdi    # rdi = end-1
    movb    $0, (%rdi)               # NUL (an toàn)
    mov     $10, %rcx
    test    %r8, %r8
    jnz     .conv

    # Trường hợp giá trị = 0
    dec     %rdi
    movb    $'0', (%rdi)
    jmp     .emit

.conv:
    mov     %r8, %rax
.conv_loop:
    xor     %rdx, %rdx
    div     %rcx                     # rax=quo, rdx=rem
    add     $'0', %dl
    dec     %rdi
    mov     %dl, (%rdi)
    test    %rax, %rax
    jnz     .conv_loop

.emit:
    lea     numbuf+32(%rip), %rsi    # end
    mov     %rsi, %rdx
    sub     %rdi, %rdx               # len = end - start
    mov     %rdi, %rsi               # rsi = start
    call    write_str

    lea     nl(%rip), %rsi
    mov     $nl_len, %rdx
    call    write_str
    ret

# ------------------------------------------------------------
# show_age — in "Tuoi hien tai: " + age
# ------------------------------------------------------------
show_age:
    lea     msg_age(%rip), %rsi
    mov     $msg_age_len, %rdx
    call    write_str

    mov     age(%rip), %rax
    call    print_num
    ret

# ------------------------------------------------------------
# _start — luồng chính
# ------------------------------------------------------------
_start:
    # Prompt
    lea     prompt(%rip), %rsi
    mov     $prompt_len, %rdx
    call    write_str

    # Đọc input (tối đa 8 byte: YYYY\n)
    mov     $0, %rax
    mov     $0, %rdi
    lea     inbuf(%rip), %rsi
    mov     $8, %rdx
    syscall

    # Chuyển "YYYY" → số (chỉ lấy 4 ký tự đầu)
    lea     inbuf(%rip), %rsi
    xor     %rax, %rax
    xor     %rbx, %rbx

    movzbq  0(%rsi), %rax
    sub     $'0', %al
    imul    $1000, %rax, %rax

    movzbq  1(%rsi), %rbx
    sub     $'0', %bl
    imul    $100, %rbx, %rbx
    add     %rbx, %rax

    movzbq  2(%rsi), %rbx
    sub     $'0', %bl
    imul    $10, %rbx, %rbx
    add     %rbx, %rax

    movzbq  3(%rsi), %rbx
    sub     $'0', %bl
    add     %rbx, %rax

    mov     %rax, year(%rip)

    # age = CURRENT_YEAR - year
    mov     $CURRENT_YEAR, %rcx
    sub     year(%rip), %rcx
    mov     %rcx, age(%rip)

    # Phân loại:
    #   age < 18        → .young
    #   18 ≤ age < 22   → .study
    #   age ≥ 22        → .grad
    cmp     $18, %rcx
    jl      .young
    cmp     $22, %rcx
    jl      .study
    jmp     .grad

# ------------------------------------------------------------
# Nhánh 1 — Chưa vào UIT (age < 18)
# ------------------------------------------------------------
.young:
    lea     msg_young(%rip), %rsi
    mov     $msg_young_len, %rdx
    call    write_str

    call    show_age

    # Năm dự kiến vào UIT = year + 18
    mov     year(%rip), %rax
    add     $18, %rax
    mov     %rax, calc(%rip)

    lea     msg_enter(%rip), %rsi
    mov     $msg_enter_len, %rdx
    call    write_str

    mov     calc(%rip), %rax
    call    print_num
    jmp     .exit

# ------------------------------------------------------------
# Nhánh 2 — Đang học tại UIT (18 ≤ age < 22)
# ------------------------------------------------------------
.study:
    lea     msg_study(%rip), %rsi
    mov     $msg_study_len, %rdx
    call    write_str

    call    show_age

    # Năm tốt nghiệp = year + 22
    mov     year(%rip), %rax
    add     $22, %rax
    mov     %rax, calc(%rip)

    lea     msg_gradu(%rip), %rsi
    mov     $msg_gradu_len, %rdx
    call    write_str

    mov     calc(%rip), %rax
    call    print_num
    jmp     .exit

# ------------------------------------------------------------
# Nhánh 3 — Đã tốt nghiệp (age ≥ 22)
# ------------------------------------------------------------
.grad:
    lea     msg_grad(%rip), %rsi
    mov     $msg_grad_len, %rdx
    call    write_str

    call    show_age

    # Năm tốt nghiệp = year + 22
    mov     year(%rip), %rax
    add     $22, %rax
    mov     %rax, calc(%rip)

    lea     msg_gradu(%rip), %rsi
    mov     $msg_gradu_len, %rdx
    call    write_str

    mov     calc(%rip), %rax
    call    print_num
    jmp     .exit

# ------------------------------------------------------------
# Thoát
# ------------------------------------------------------------
.exit:
    mov     $60, %rax
    xor     %rdi, %rdi
    syscall
