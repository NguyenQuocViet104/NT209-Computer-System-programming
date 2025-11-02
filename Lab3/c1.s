.section .data
	prompt: .string "Enter a number (5 digits): "
	len = . - prompt					# Do dai chuoi prompt

	msg_symmetric: .string "Doi xung"
	symmetric_len = . - msg_symmetric			# Do dai chuoi msg_symmetric

	msg_asymmetric: .string "Khong doi xung"
	asymmetric_len= . - msg_asymmetric			# Do dai chuoi msg_asymmetric

.section .bss
	.lcomm input, 6						# Cap 6 byte bo nho cho input

.section .text
	.globl _start

_start:
	# In prompt
	movl $4, %eax						# system call: sys_write
	movl $1, %ebx						# stdout
	movl $prompt, %ecx					# Dia chi chuoi prompt
	movl $len, %edx						# Do dai chuoi prompt
	int $0x80						# Thuc hien system call (In chuoi prompt ra man hinh)

	# Doc du lieu input
	movl $3, %eax						# system call: sys_read
	movl $0, %ebx						# stdin
	movl $input, %ecx					# Dia chi vung nho de luu du lieu input
	movl $6, %edx						# So byte toi da can doc
	int $0x80						# Thuc hien system call (Doc du lieu input tu nguoi dung)

	movl $input, %eax					# Nap dia chi input vao thanh ghi %eax

	# Kiem tra doi xung giua input[0] va input[4]
	mov 0(%eax), %bl					# Di chuyen ky tu input[0] vao thanh ghi %bl
	mov 4(%eax), %cl					# Di chuyen ky tu input[4] vao thanh ghi %cl
	cmp %bl, %cl						# So sanh input[0] va input[4]
	jne ifSymmetric						# Neu input[0] != input[4] thi nhay toi IfSymmetric

	# Kiem tra doi xung giua input[1] va input[3]
	mov 1(%eax), %bl					# Di chuyen ky tu input[1] vao thanh ghi %bl
	mov 3(%eax), %cl					# Di chuyen ky tu input[3] vao thanh ghi %cl
	cmp %bl, %cl						# So sanh input[1] va input[3]
	jne ifSymmetric						# Neu input[1] != input[3], nhay toi IfSymmetric

	# In thong bao "Doi xung"
	movl $4, %eax						# system call: sys_write
	movl $1, %ebx						# stdout
	movl $msg_symmetric, %ecx				# Dia chi chuoi msg_symmetric
	movl $symmetric_len, %edx				# Do dai chuoi msg_symmetric
	int $0x80						# Thuc hien system call (In thong bao "Doi xung")

	jmp EXIT						# Nhay toi EXIT

ifSymmetric:
	# In thong bao "Khong doi xung"
	movl $4, %eax						# system call: sys_write
	movl $1, %ebx						# stdout
	movl $msg_asymmetric, %ecx				# Dia chi chuoi msg_asymmetric
	movl $asymmetric_len, %edx				# Do dai chuoi msg_asymmetric
	int $0x80						# Thuc hien system call (In thong bao "Khong doi xung")

EXIT:
	movl $1, %eax						# system call: sys_exit
	int $0x80						# Thuc hien system call (thoat khoi chuong trinh)
