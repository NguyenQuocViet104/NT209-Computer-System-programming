.section .data
	msg: .string "Enter a string (5 char): "	# Thong bao de yeu cau nguoi dung nhap chuoi
	len_msg = . - msg				# Tinh do dai cua thong bao (tu msg den vi tri hien tai)

.section .bss
	.lcomm input, 5					# Cap phat 5 byte bo nho de luu chuoi nguoi dung nhap

.section .text
	.globl _start					# Khai bao nhan _start la diem bat dau cho chuong trinh

_start:
	# In thong bao yeu cau nhap chuoi
	movl $4, %eax					# system call (sys_write)
	movl $1, %ebx					# file descriptor (stdout)
	movl $msg, %ecx					# dia chi cua msg
	movl $len_msg, %edx				# do dai chuoi msg
	int $0x80					# goi ngat he thong de in ra man hinh

	# Nhap chuoi tu ban phim
	movl $3, %eax					# system call (sys_read)
	movl $0, %ebx					# file descriptor (stdin)
	movl $input, %ecx				# dia chi vung nho de luu du lieu dau vao
	movl $6, %edx					# so byte can doc (5 ky tu + 1 ky tu newline)
	int $0x80					# goi ngat he thong de doc du lieu

	# Dao chuoi
	movl $input, %eax				# nap dia chi chuoi input va thanh ghi %eax
	
	# Hoan doi ky tu dau va ky tu cuoi
	movb 0(%eax), %bl				# %bl = input[0]
	movb 4(%eax), %cl				# %cl = input[4]
	movb %cl, 0(%eax)				# input[0] = ky tu cuoi
	movb %bl, 4(%eax)				# input[4] = ky tu dau
	
	# Hoan don ky tu 1 voi ky tu 3
	movb 1(%eax), %bl				# %bl = input[1]
	movb 3(%eax), %cl				# %cl = input[3]
	movb %cl, 1(%eax)				# input[1] = input[3]
	movb %bl, 3(%eax)				# input[3] = input[1]

	# In chuoi ra man hinh
	movl $4, %eax					# system call (sys_write)
	movl $1, %ebx					# file descriptor (stdout)
	movl $input, %ecx				# dia chi chuoi can in
	movl $5, %edx					# so byte can in (5 ky tu)
	int $0x80					#call kernel

.Exit:
	# Ket thuc chuong trinh
	movl $1, %eax					# sys_exit
	int $0x80					# thoat chuong trinh
