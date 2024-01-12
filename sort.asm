;COMMENTS-----------------------------------------
;Sample code in a High Level Language (Python)
;def sort(x):
	;new_list = x

	;for i in range(len(new_list)-1,0,-1):
		;swapped = False

		;for j in range(0,i):
			;if new_list[j] > new_list[j+1]:
				;tmp = new_list[j]
				;new_list[j] = new_list[j+1]
				;new_list[j+1] = tmp
	;return new_list


;HL = High Level Language example above
;rcx = outerloop counter (i) in HL example
;rdx = innerloop counter (j) in HL example
;r8 = holds value of rdx+1 in the HL it equals j+1
;r9 = holds temp values. In HL (tmp = list[j])
;r12 = holds temp values


%include "lib.inc"

global _start

section .data
	list db 12,33,234,9,52,6,17,9,5,100
	len_list equ $-list				;length of list


section .text

	Sort:
		push r12					;push the callee-saved register r12 onto the stack
		.outerloop:
			dec rcx
			cmp rcx,0				;compare outer loop counter and 0
			je .end					;jmp to .end if outerloop counter == 0

			mov rdx,0				;set rdx to 0 which will be used for innerloop counting (0 to i) as in HL example

		.innerloop:
			cmp rdx,rcx				;check if innerloop counter == outerloop counter since we are counting from 0 to i(current rcx)-1 in innerloop
			je .outerloop

			mov r8,rdx				;copy current outerloop counter to r8
			inc r8					;increase r8 so it can represent rcx+1....list[j+1] in HL example

			mov r12b,[list+rdx]  			;copy contents of [list+rdx](in HL new_list[j+1]) into r12b
			cmp r12b,[list+r8]   			;similar to the conditional statement "if list[j] > list[j+1]" in the HL
			ja .greater_value_found			;jmp to .greater_value_found label
			jna .continue_inner_looping		;jmp to .continue_inner_looping label and continue running inner loop


		.greater_value_found:
			mov r9b,r12b					;mov r12b into r9b (in HL tmp = new_list[j]
			mov r12b, byte[list+r8]			;mov contents of byte[list+r8] (in HL new_list[j+1]) into r12b
			mov byte[list+rdx],r12b			;mov r12b into byte[list+rdx] (in HL new_list[j] = new_list[j+1])
			mov byte[list+r8],r9b			;mov r9b into byte[list+r8] (in HL new_list[j+1] = tmp)
			jmp .continue_inner_looping		;jmp to <label>

		.continue_inner_looping:
			inc rdx
			jmp .innerloop					;jmp back to innerloop


		.end:
			pop r12		;pop the r12 register that was pushed earlier on
			ret			;return to the caller routine



	_start:
		mov rcx,len_list
		call Sort
		mov rax,len_list-1
		mov rdi,[list]		;sends the least value in the list to the rdi register. This can be viewed after program execution by running ' echo $? ' on the terminal (without the quotes!)
		syscall

		call exit_func

