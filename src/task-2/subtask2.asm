%include "../include/io.mac"

; declare your structs here
section .bss
	struc event
		name: resb 31
		valid: resb 1
		day: resb 1
		month: resb 1
		year: resw 1
	endstruc

section .text
    global sort_events
	global comparison_function
    extern printf

sort_events:
    ;; DO NOT MODIFY
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]      ; events
    mov ecx, [ebp + 12]     ; length
    ;; DO NOT MODIFY

	; preparing stack for sort_function call (CDECL standard)
	push ecx
	push ebx

	; calling sort_function (respecting CDECL standard)
	call sort_function

	; deallocating stack
	add esp, 8

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY



sort_function:
	push ebp
	mov ebp, esp

	push ebx
	push esi ; callee-saved regiser (CDECL standard)
	push edi

	xor ecx, ecx ; element counter
	mov edi, [ebp + 12] ; array element count
	dec edi ; excluding last item to avoid sorting one element

sort_function_loop: ; SELECTION SORT
	cmp ecx, edi
	jz sort_function_end

	mov eax, ecx
	imul eax, event_size ; element size
	add eax, [ebp + 8] ; address of current array position for sort
	mov edx, ecx ; edx is the counter for the selection loop
	inc edx ; selecting from next element

	mov ebx, eax ; eax is the selected element
	mov esi, eax ; esi is eax backup
	add ebx, event_size ; ebx is the address of the next element

sort_function_selection_loop:
	cmp edx, [ebp + 12]
	jz sort_function_selection_loop_end

	push eax
	push ecx ; caller-saved registers (CDECL standard)
	push edx

	push ebx ; RHS (possible selection) element
	push eax ; LHS (current selection) element
	call comparison_function
	add esp, 8 ; deallocating stack space for params

	cmp eax, 0 ; checking result
	jz sort_function_selection_loop_regrestore ; do not interchange

	; interchange
	pop edx ; caller-saved registers (CDECL standard)
	pop ecx
	mov eax, ebx ; selected element is ebx
	add esp, 4 ; deallocating stack space for eax
	jmp sort_function_selection_loop_continue

sort_function_selection_loop_regrestore:
	pop edx
	pop ecx ; caller-saved registers (CDECL standard)
	pop eax

sort_function_selection_loop_continue:
	inc edx
	add ebx, event_size ; next element
	jmp sort_function_selection_loop

sort_function_selection_loop_end:
	push ecx ; caller-saved registers (CDECL standard)
	push eax
	push esi ; function params (CDECL standard)

	call swap_function ; swapping selected element with current position

	add esp, 8 ; deallocating stack space for params
	pop ecx ; caller-saved register (CDECL standard)

	inc ecx
	jmp sort_function_loop

sort_function_end:
	pop edi
	pop esi ; callee-saved register (CDECL standard)
	pop ebx
	leave
	ret



swap_function:
	push ebp
	mov ebp, esp

	push ebx ; callee-saved register (CDECL standard)
	push edi

swap_function_setup:
	mov eax, [ebp + 8] ; LHS element address
	mov ebx, [ebp + 12] ; RHS element address
	mov ecx, 0 ; byte counter
	; edx is swap register

swap_function_loop:
	cmp ecx, event_size
	jz swap_function_end

	mov edx, [eax]
	mov edi, [ebx] ; swapping 4 bytes at a time
	mov [eax], edi
	mov [ebx], edx

	add ecx, 4 ; next byte
	add eax, 4 ; incrementing addresses
	add ebx, 4
	jmp swap_function_loop

swap_function_end:
	pop edi ; callee-saved register (CDECL standard)
	pop ebx

	leave
	ret



comparison_function:
	push ebp
	mov ebp, esp
	push ebx ; callee-saved register (CDECL standard)

	mov eax, [ebp + 8] ; pointer to LHS element
	mov ebx, [ebp + 12] ; pointer to RHS element

	; comparing by validity
	mov ecx, eax
	mov edx, ebx

	add ecx, valid ; name skipped
	add edx, valid
	mov ecx, [ecx]
	mov edx, [edx]
	cmp cl, dl ; checking if validity is equal

	; RHS is invalid
	jg comparison_function_ret0

	; LHS is invalid
	jl comparison_function_ret1

	; LHS and RHS have the same validity
	; comparing by date
	mov ecx, eax
	mov edx, ebx

	; check year
	add ecx, year ; name, valid, day and month skipped
	add edx, year
	mov ecx, [ecx]
	mov edx, [edx]
	cmp cx, dx

	; LHS year is later
	jg comparison_function_ret1

	; RHS year is later
	jl comparison_function_ret0

	; same year, check month
	mov ecx, eax
	mov edx, ebx

	add ecx, month ; name, valid and day skipped
	add edx, month
	mov ecx, [ecx]
	mov edx, [edx]
	cmp cl, dl

	; LHS month is later
	jg comparison_function_ret1

	; RHS month is later
	jl comparison_function_ret0

	; same month, check day
	mov ecx, eax
	mov edx, ebx

	add ecx, day ; name and valid skipped
	add edx, day
	mov ecx, [ecx]
	mov edx, [edx]
	cmp cl, dl

	; LHS day is later
	jg comparison_function_ret1

	; RHS day is later
	jl comparison_function_ret0

	; LHS and RHS have the same date; comparing
	; by name using strcmp_function
	; preparing stack for strcmp call (using CDECL standard)

	push ebx
	push eax

	call strcmp_function ; calling strcmp

	add esp, 8 ; deallocating stack
	cmp eax, 0

	; return val <= 0
	; second name should come first
	jle comparison_function_ret0

	; otherwise, first name should come first

comparison_function_ret1:
	mov eax, 1
	jmp comparison_function_ret

comparison_function_ret0:
	mov eax, 0

comparison_function_ret:
	pop ebx ; callee-saved register (CDECL standard)
	leave
	ret



strcmp_function:
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8] ; LHS string pointer
	mov ecx, [ebp + 12] ; RHS string pointer

strcmp_function_loop:
	cmp dword[eax], 0 ; checking if eax != 0
	jz strcmp_function_assess

	cmp dword[ecx], 0 ; checking if ebx != 0
	jz strcmp_function_ret_true

	mov edx, [ecx]
	cmp [eax], edx
	jg strcmp_function_ret_false
	jl strcmp_function_ret_true

	inc eax
	inc ecx
	jmp strcmp_function_loop

strcmp_function_assess: ; eax string has ended
	cmp dword[ecx], 0
	jnz strcmp_function_ret_false ; ebx string has ended

strcmp_function_ret_true:
	mov eax, 1
	leave
	ret

strcmp_function_ret_false:
	mov eax, 0
	leave
	ret
