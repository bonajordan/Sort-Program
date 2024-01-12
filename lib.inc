SYS_READ equ 0
SYS_WRITE equ 1
STDIN equ 0
STDOUT equ 1

section .data:
	newline db 10

section .text:
	print_newline:
		call display_func
		mov rsi, newline
		mov rdx,1
		syscall
		ret

	display_func:
		mov rax,SYS_WRITE
		mov rdi,STDOUT
		ret

	input_func:
		mov rax,SYS_READ
		mov rdi,STDIN
		ret

	exit_func:
		mov rax,60
		syscall
