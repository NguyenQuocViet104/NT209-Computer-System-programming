.section .data
    prompt:     .asciz "Nhap so (2 chu so): "
    even_msg:   .asciz " -> Ket qua: 1 (so chan)\n"
    odd_msg:    .asciz " -> Ket qua: 0 (so le)\n"
    next_msg:   .asciz "So vua nhap: "
    newline:    .asciz "\n"
    next_label: .asciz "So tiep theo: "
    numbuf:     .space 5
    resultbuf:  .space 5
    nextbuf:    .space 5

.section .text
    .globl _start

_start:
    # In thông báo yêu cầu nhập
    movl $4, %eax
    movl $1, %ebx
    movl $prompt, %ecx
    movl $22, %edx
    int $0x80

    # Đọc dữ liệu từ bàn phím
    movl $3, %eax
    movl $0, %ebx
    movl $numbuf, %ecx
    movl $5, %edx
    int $0x80
    # Ví dụ: nhập 60⏎ → ['6','0','\n',...]

    # Chuyển chuỗi sang số nguyên
    movzbl numbuf, %eax
    subl $'0', %eax
    imull $10, %eax
    movzbl numbuf+1, %ebx
    subl $'0', %ebx
    addl %ebx, %eax      # eax = x (số nhập vào)

    movl %eax, %esi      # lưu giá trị x để in sau

    # Kiểm tra chẵn/lẻ
    movl %eax, %ebx
    andl $1, %ebx
    cmp $0, %ebx
    je is_even
    jmp is_odd

is_even:
    movl $4, %eax
    movl $1, %ebx
    movl $even_msg, %ecx
    movl $26, %edx
    int $0x80
    jmp print_number

is_odd:
    movl $4, %eax
    movl $1, %ebx
    movl $odd_msg, %ecx
    movl $25, %edx
    int $0x80

print_number:
    # In "So vua nhap: "
    movl $4, %eax
    movl $1, %ebx
    movl $next_msg, %ecx
    movl $14, %edx
    int $0x80

    # In số vừa nhập
    movl %esi, %eax
    call int_to_string
    movl $4, %eax
    movl $1, %ebx
    movl $resultbuf, %ecx
    movl $2, %edx
    int $0x80

    # Xuống dòng
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $0x80

    # In "So tiep theo: "
    movl $4, %eax
    movl $1, %ebx
    movl $next_label, %ecx
    movl $15, %edx
    int $0x80

    # Tính x+1
    movl %esi, %eax
    addl $1, %eax
    call int_to_string
    movl $4, %eax
    movl $1, %ebx
    movl $resultbuf, %ecx
    movl $2, %edx
    int $0x80

    # Xuống dòng
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $0x80

exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

#----------------------------------------
# Hàm chuyển số nguyên nhỏ (0-99) sang chuỗi
#----------------------------------------
int_to_string:
    movl %eax, %ebx
    movl $10, %ecx
    xorl %edx, %edx
    divl %ecx            # eax = hàng chục, edx = hàng đơn vị
    addb $'0', %al
    addb $'0', %dl
    movb %al, resultbuf
    movb %dl, resultbuf+1
    ret
