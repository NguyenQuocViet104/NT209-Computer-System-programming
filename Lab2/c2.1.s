.section .data
msg: .string "NT209UIT"           # Khai báo một chuỗi ký tự "NT209UIT"
msg_len = . - msg

.section .bss
    .lcomm test, 1               # Khai báo biến test 1 byte

.section .text
    .globl _start

_start:
    movl $0, %esi                # Gán giá trị trong thanh ghi esi bằng 0
    addl $48, %esi               # Giá trị trong thanh ghi esi được cộng thêm 48 (chuyển đổi từ số sang kí tự dạng ascii)
    addl $msg_len, %esi          # Giá trị trong thanh ghi esi được cộng thêm giá trị của biến msg_len (độ dài của chuỗi msg)
    subl $1, %esi                # Giá trị trong thanh ghi esi bị trừ đi 1 (vì trong chuỗi được lưu kí tự null ở cuối chuỗi)
    movl %esi, (test)            # Lưu giá trị trong thanh ghi esi vào địa chỉ bộ nhớ được lưu trong biến test

    # Xuất số ra
    movl $4, %eax                # Gọi hệ thống (system call) write
    movl $1, %ebx                # Đối số thứ nhất cho write, quy định ghi ra màn hình
    movl $test, %ecx             # Địa chỉ của biến test cần in
    movl $1, %edx                # Độ dài của biến cần in
    int $0x80                    # Thực hiện gọi hệ thống để in chuỗi

_Exit:
    # Kết thúc chương trình
    movl $1, %eax                # Gọi hệ thống exit để kết thúc chương trình (mã 1)
    int $0x80                    # Thực hiện gọi hệ thống để thoát
