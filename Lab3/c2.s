.section .data
	prompt:         .string "Enter a string (maximum 255 chars): "
	len_prompt =    . - prompt						# Do dai chuoi prompt

	result_msg:     .string "Number of words: "
	len_result =    . - result_msg						# Do dai chuoi result_msg

	newline:        .string "\n"
	len_newline =   . - newline						# Do dai ky tu '\n'

.section .bss
    	.lcomm input, 256								# Cap 256 byte cho input (255 ky tu + '\n')
    	.lcomm word_count, 4							# Bien de dem so tu (int)
    	.lcomm i, 4									# Bien chi so vong lap (int)
    	.lcomm in_word, 4								# Bien trang thai (0: khong trong 1 tu, 1: dang trong 1 tu)
    	.lcomm num_buffer, 16     # bộ đệm tạm để luu số (chuyen word_count sang chuoi)

.section .text
	.globl _start

_start:

    	# In chuoi: "Enter a string: "
    	movl $4, %eax								# system call: sys_write
    	movl $1, %ebx								# stdout
    	movl $prompt, %ecx							# Dia chi chuoi prompt
    	movl $len_prompt, %edx							# Do dai chuoi prompt
    	int $0x80								# Thuc hien system call

    	# Doc du lieu input
    	movl $3, %eax								# system call: sys_read
    	movl $0, %ebx								# stdin
    	movl $input, %ecx							# Dia chi vung nho de luu du lieu input
    	movl $255, %edx								# So byte toi da can doc
    	int $0x80								# Thuc hien system call
    	movl %eax, %esi            						# %esi = số ký tự đọc được

    	# Khoi tao bien dem
    	movl $0, word_count								# word_count = 0
    	movl $0, i									# i = 0
    	movl $0, in_word								# in_word = 0

# Vong lap duyet chuoi tung ky tu
count_loop:
    	movl i, %ebx								# %ebx = i
    	cmpl %esi, %ebx								# So sanh i voi do dai chuoi doc duoc
    	jge end_count								# Neu i >= do dai chuoi doc duoc thi thoat vong lap

    	movl $input, %edi								# %edi = dia chi dau chuoi input
    	addl %ebx, %edi								# %edi = input + 1
    	movb (%edi), %al								# %al = ky tu hien tai

	# Neu gap '\n' thi dung vong lap
    	cmpb $10, %al								
    	je end_count

	# Neu gap khoang trang thi nhay den is_space
    	cmpb $32, %al
    	je is_space

	# Neu la ky tu thuong
    	movl in_word, %edx
    	cmpl $0, %edx
    	jne still_in_word							# Neu dang trong 1 tu thi bo qua

	# Neu vua bat dau 1 tu moi
    	incl word_count            						# Tang bien dem word_count
    	movl $1, in_word							# Dat in_word = 1
    	jmp next_char								# Nhay den next_char

is_space:
    	movl $0, in_word							# Dat in_word = 0

still_in_word:
next_char:
    	incl i									# Tang i them 1 (i++)
    	jmp count_loop								# Lap lai vong lap

end_count:
    	movl word_count, %eax      						# %eax = so tu can in
    	leal num_buffer + 15, %edi 						# tro den cuoi buffer
    	movb $0, (%edi)            						# Them '\0'
    	decl %edi								# Lui lai 1 byte de ghi chu so dau tien tu cuoi

convert_loop:
    	movl $0, %edx								# Xoa phan du
    	movl $10, %ebx								#
    	divl %ebx                  						# Chia %eax cho 10
    	addb $48, %dl              						# Chuyen phan du (0-9) sang ASCII
    	movb %dl, (%edi)							# Ghi tu ky so vao buffer
    	decl %edi								# Lui lai 1 o (ghi tu phai sang trai)
    	testl %eax, %eax							# Neu eax = 0 thi xong
    	jnz convert_loop							
    	incl %edi                  						# Di chuyen con tro toi chu so dau tien cua chuoi

    	# In "Number of words: "
    	movl $4, %eax								# system call: sys_write
    	movl $1, %ebx								# stdout
    	movl $result_msg, %ecx							# Dia chi chuoi result_msg
    	movl $len_result, %edx							# Do dai chuoi result_msg
    	int $0x80								# Thuc hien system call

    	# In word_count
    	movl $4, %eax								# system call: sys_write
    	movl $1, %ebx								# stdout
    	movl %edi, %ecx            						# Con tro toi chuoi so
    	leal num_buffer + 16, %edx						# Dia chi cuoi buffer
    	subl %edi, %edx            						# Do dai chuoi so
    	decl %edx                  						# Loai bo byte null
    	int $0x80								# Thuc hien system call

    	# In '\n'
    	movl $4, %eax								# system call: sys_write
    	movl $1, %ebx								# stdout
    	movl $newline, %ecx							# Dia chi ky tu '\n'
    	movl $len_newline, %edx							# Do dai ky tu '\n'
    	int $0x80								# Thuc hien system call

    	# EXIT
    	movl $1, %eax								# system call: sys_exit
    	xorl %ebx, %ebx								# exit code = 0
    	int $0x80								# Thuc hien system call
