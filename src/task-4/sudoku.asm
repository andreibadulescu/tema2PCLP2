%include "../include/io.mac"

extern printf
global check_row
global check_column
global check_box
; you can declare any helper variables in .data or .bss

section .text


; int check_row(char* sudoku, int row);
check_row:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov edx, [ebp + 12]  ; int row
    ;; DO NOT MODIFY

    ;; Freestyle starts here

	mov eax, edx
	xor edx, edx
	imul eax, 9
	lea esi, [esi + eax] ; address of first element on given row
	mov edx, 0 ; column counter
	mov ebx, 511 ; bit mask
	not ebx ; i-th bit = 1 -> value i has been used or is invalid
	mov eax, 1 ; result value

loop_check_row:
	cmp edx, 9
	jae	end_check_row

	; enabling the corresponding bit
	; for the value on the bit mask
	mov ecx, [esi]
	and ecx, 15 ; current value is stored on last 4 bits
	sub ecx, 1
	mov edi, 1
	shl edi, cl ; representative bit for value of current element
	test ebx, edi ; checking for incorrect values
	jz continue_loop_check_row

	mov eax, 2
	jmp end_check_row

continue_loop_check_row:
	or ebx, edi
	add edx, 1
	add esi, 1 ; moving to next column
	jmp loop_check_row
    ;; MAKE SURE TO LEAVE YOUR RESULT IN EAX BY THE END OF THE FUNCTION
    ;; Remember: OK = 1, NOT_OKAY = 2
    ;; ex. if this row is okay, by this point eax should contain the value 1

    ;; Freestyle ends here
end_check_row:
    ;; DO NOT MODIFY

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret

    ;; DO NOT MODIFY

; int check_column(char* sudoku, int column);
check_column:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov     esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov     edx, [ebp + 12]  ; int column
    ;; DO NOT MODIFY

    ;; Freestyle starts here

	lea esi, [esi + edx]  ; address of first element on given row
	mov edx, 0 ; row counter
	mov ebx, 511 ; bit mask
	not ebx ; i-th bit = 1 -> value i has been used or is invalid
	mov eax, 1 ; result value

loop_check_column:
	cmp edx, 9
	jae	end_check_column

	; enabling the corresponding bit
	; for the value on the bit mask
	mov ecx, [esi]
	and ecx, 15  ; current value is stored on last 4 bits
	sub ecx, 1
	mov edi, 1
	shl edi, cl ; representative bit for value of current element
	test ebx, edi ; checking for incorrect values
	jz continue_loop_check_column

	mov eax, 2
	jmp end_check_column

continue_loop_check_column:
	or ebx, edi
	add esi, 9 ; moving to next column
	add edx, 1
	jmp loop_check_column


    ;; MAKE SURE TO LEAVE YOUR RESULT IN EAX BY THE END OF THE FUNCTION
    ;; Remember: OK = 1, NOT_OKAY = 2
    ;; ex. if this column is okay, by this point eax should contain the value 1

    ;; Freestyle ends here
end_check_column:
    ;; DO NOT MODIFY

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret

    ;; DO NOT MODIFY


; int check_box(char* sudoku, int box);
check_box:
    ;; DO NOT MODIFY
    push ebp
    mov	ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov edx, [ebp + 12]  ; int box
    ;; DO NOT MODIFY

    ;; Freestyle starts here

	mov eax, edx
	mov edi, 3
	xor edx, edx ; the quotient is the number of the box from top to bottom
	div edi ; the remainder is the number of the box from left to right
	mov edi, edx ; edx contains the "column" of the selected box
	imul eax, 27 ; eax contains the "row" of the selected box
	mov ecx, eax
	mov eax, edi
	imul eax, 3
	mov edx, ecx

	add edx, eax
	lea esi, [esi + edx] ; address of top left element

	mov ebx, 511 ; bit mask
	not ebx ; i-th bit = 1 -> value i has been used or is invalid
	mov ecx, 0 ; element in box count

	; EAX contains the return value

loop_check_box:
	cmp ecx, 9
	mov eax, 1
	jae	end_check_box

	; extracting current element
	mov eax, ecx
	mov edi, 3
	xor edx, edx
	div edi
	mov edi, edx ; edx is the current column inside the box
	xor edx, edx ; eax is the current row inside the box
	imul eax, 9
	add eax, edi
	lea edi, [esi + eax] ; computing value of current element
	mov edi, [edi]
	and edi, 15 ; current value is stored on last 4 bits

	; checking the element
	mov edx, 1
	push ecx
	sub edi, 1
	mov ecx, edi
	shl edx, cl ; representative bit for value of current element
	pop ecx
	test ebx, edx ; checking for incorrect values
	jz continue_loop_check_box

	mov eax, 2 ; the box contains invalid entries
	jmp end_check_box

continue_loop_check_box:
	or ebx, edx ; updating the bit mask
	add ecx, 1 ; iterating to the next element inside the box
	jmp loop_check_box

    ;; MAKE SURE TO LEAVE YOUR RESULT IN EAX BY THE END OF THE FUNCTION
    ;; Remember: OK = 1, NOT_OKAY = 2
    ;; ex. if this box is okay, by this point eax should contain the value 1

    ;; Freestyle ends here
end_check_box:
    ;; DO NOT MODIFY

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret

    ;; DO NOT MODIFY
