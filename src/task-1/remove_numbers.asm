%include "../include/io.mac"

extern printf
global remove_numbers

section .data
	fmt db "%d", 10, 0

section .text

; function signature:
; void remove_numbers(int *a, int n, int *target, int *ptr_len);

remove_numbers:
	;; DO NOT MODIFY
	push    ebp
	mov     ebp, esp
	pusha

	mov     esi, [ebp + 8] ; source array
	mov     ebx, [ebp + 12] ; n
	mov     edi, [ebp + 16] ; dest array
	mov     edx, [ebp + 20] ; pointer to dest length

	;; DO NOT MODIFY

	xor ebx, ebx ; ebx represents element counter
	mov dword[edx], 0

remover:
	mov ecx, [ebp + 12]
	cmp ebx, ecx
	jae exit

	; loading number from index count ebx
	lea eax, [esi + 4 * ebx]
	mov eax, [eax]
	; recycling the number for easy recall later
	push eax
	; checking if odd
	and eax, 1
	cmp eax, 1
	pop eax ; pop does not change EFLAGS
	je incrementor

	; checking if the number is a power of two
	mov ecx, eax
	sub ecx, 1
	and ecx, eax
	cmp ecx, 0
	je incrementor
	; if the number is a power of two, then by subtracting one the
	; initial bit will be deactivated and from the AND operator will result 0

	; retrieving results array length and updating vector with latest value
	mov ecx, [edx]
	lea ecx, [edi + 4 * ecx]
	mov [ecx], eax
	; incrementing results index
	add dword[edx], 1

incrementor:
	inc ebx
	jmp remover

exit:
	;; DO NOT MODIFY

	xor eax, eax
	popa
	leave
	ret

	;; DO NOT MODIFY
