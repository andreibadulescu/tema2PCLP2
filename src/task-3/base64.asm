%include "../include/io.mac"

extern printf
global base64

section .data
	alphabet db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
	fmt db "%d", 10, 0

section .text

base64:
	;; DO NOT MODIFY

    push ebp
    mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; source array
	mov ebx, [ebp + 12] ; n
	mov edi, [ebp + 16] ; dest array
	mov edx, [ebp + 20] ; pointer to dest length

	;; DO NOT MODIFY

	; ecx will be dest length
	mov ecx, 0

loop:
	; checking if there are bytes
	; left to process
	cmp ebx, 0
	jbe loop_exit

	; creating first 6 bit group
	mov eax, [esi]
	shr al, 2 ; removing last 2 bits and aligning
	and eax, 63 ; saving last 6 bits from AL
	; obtaining the corresponding character
	mov edx, alphabet
	add edx, eax
	mov edx, [edx]
	; moving char in dest array
	mov eax, edi
	add eax, ecx
	mov [eax], edx
	add ecx, 1

	; creating second 6 bit group
	mov eax, [esi]
	and al, 3 ; keeping only last 2 bits of 1st byte
	shl al, 4 ; moving bits for alignment
	shr ah, 4 ; removing last 4 bits and aligning
	or al, ah
	and eax, 63 ; saving last 6 bits from AL
	; obtaining the corresponding character
	mov edx, alphabet
	add edx, eax
	mov edx, [edx]
	; moving char in dest array
	mov eax, edi
	add eax, ecx
	mov [eax], edx
	add ecx, 1

	; creating third 6 bit group
	mov eax, [esi]
	mov edx, eax
	and ah, 15 ; keeping last 4 bits of 2nd byte
	shl ah, 2 ; moving bits for alignment
	shr edx, 16 ; moving first 16 bits inside DX
	shr dl, 6 ; removing last 6 bits and aligning
	or ah, dl
	xor edx, edx
	mov dl, ah
	; obtaining the corresponding character
	mov eax, alphabet
	add eax, edx
	mov eax, [eax]
	; moving char in dest array
	mov edx, edi
	add edx, ecx
	mov [edx], eax
	add ecx, 1

	; creating fourth 6 bit group
	mov eax, [esi]
	shr eax, 16 ; moving first 16 bits inside AX
	and eax, 63 ; saving last 6 bits from AL
	; obtaining the corresponding character
	mov edx, alphabet
	add edx, eax
	mov edx, [edx]
	; moving char in dest array
	mov eax, edi
	add eax, ecx
	mov [eax], edx
	add ecx, 1

	; incrementing counter by 3 bytes
	add esi, 3
	sub ebx, 3
	jmp loop

loop_exit:
	; saving dest array length
	mov eax, [ebp + 20]
	mov [eax], ecx
	;; DO NOT MODIFY

	popa
	leave
	ret

	;; DO NOT MODIFY