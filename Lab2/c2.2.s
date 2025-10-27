.section .data
	
	# Yeu cau nhap ma so sinh vien
	prompt: .string "Nhap MSSV (8 ky tu): "
	len_prompt = . - prompt

	newline: .string "\n"
	len_newline = . - newline

	# Tieu de truoc khi in so bao danh
	output_format: .string "SBD: "
	len_output_format = . - output_format

	# Nien khoa
	schoolYear_msg: .string "Nien khoa: 20"
	len_schoolYear_msg = . - schoolYear_msg

	# Nam hoc cua sinh vien
	studentYear_msg: .string ", Sinh vien nam: "
	len_studentYear_msg = . - studentYear_msg

.section .bss
	.lcomm input, 10		# Bo nho chua chuoi MSSV nhap vao
	.lcomm sbd, 9			# Bo nho chua SBD duoc tao
	.lcomm year, 4			
	.lcomm schY, 4			# Lua 2 chu so dau cua MSSV
	.lcomm result, 1		# Luu nam hoc cua sinh vien (1, 2, 3, 4)

.section .text
	.globl _start

_start:
	# Loi nhac "Nhap MSSV (8 ky tu): "
	movl $4, %eax
	movl $1, %ebx
	movl $prompt, %ecx
	movl $len_prompt, %edx
	int $0x80

	# Doc MSSV
	movl $3, %eax
	movl $0, %ebx
	movl $input, %ecx
	movl $10, %edx
	int $0x80

	# Tao SBD tu MSSV da nhap
	lea input, %esi
	lea sbd, %edi

	# Sao chep ky tu dau tien cua MSSV vao SBD
	movb 0(%esi), %al
	movb %al, 0(%edi)
	
	# Sao chep ky tu thu 2 cua MSSV vao SBD
	movb 1(%esi), %al
	movb %al, 1(%edi)
	
	# Lay 4 ky tu cuoi ghep vao de tao SBD
	movb 4(%esi), %al
	movb %al, 2(%edi)
	movb 5(%esi), %al
	movb %al, 3(%edi)
	movb 6(%esi), %al
	movb %al, 4(%edi)
	movb 7(%esi), %al
	movb %al, 5(%edi)
	
	# Them ky tu ket thuc chuoi "\0" vao cuoi SBD
	movb $0, 6(%edi)

	# In dong: "SBD: "
	movl $4, %eax
	movl $1, %ebx
	movl $output_format, %ecx
	movl $len_output_format, %edx
	int $0x80

	# In gia tri cua SBD
	movl $4, %eax
	movl $1, %ebx
	movl $sbd, %ecx
	movl $6, %edx
	int $0x80

	# Xuong dong
	movl $4, %eax
	movl $1, %ebx
	movl $newline, %ecx
	movl $len_newline, %edx
	int $0x80

	# In chuoi: "Nien khoa: 20"
	movl $4, %eax
	movl $1, %ebx
	movl $schoolYear_msg, %ecx
	movl $len_schoolYear_msg, %edx
	int $0x80

	# In 2 ky tu dau cua MSSV
	movl $4, %eax
	movl $1, %ebx
	movl $input, %ecx
	movl $2, %edx
	int $0x80

	# Luu 2 ky tu dau cua MSSv vao schY
	movl $input, %esi
	movzbl 0(%esi), %eax
	subl $48, %eax
	imull $10, %eax, %eax
	movzbl 1(%esi), %ebx
	subl $48, %ebx
	addl %ebx, %eax
	movl %eax, schY

	# Dat nam hien tai la 2025, tinh so nam hoc
	movl $25, %ecx
	subl schY, %ecx
	addl $1, %ecx
	
	# Neu nam hoc > 4 thi gioi han toi da la nam 4
	cmpl $4, %ecx
	jle year_ok
	movl $4, %ecx

year_ok:
	# Chuyen so nam hoc sang ASCII va luu vao result
	addl $48, %ecx
	movb %cl, result(%rip)

	# In ra chuoi: ", Sinh vien nam: "
	movl $4, %eax
	movl $1, %ebx
	movl $studentYear_msg, %ecx
	movl $len_studentYear_msg, %edx
	int $0x80

	# In nam hoc
	movl $4, %eax
	movl $1, %ebx
	leal result(%rip), %ecx
	movl $1, %edx
	int $0x80

	# Xuong dong
	movl $4, %eax
	movl $1, %ebx
	movl $newline, %ecx
	movl $len_newline, %edx
	int $0x80

	# Ket thuc chuong trinh
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80

