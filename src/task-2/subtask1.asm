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
	struc date
	endstruc

section .data

section .text
    global check_events
    extern printf

check_events:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov ebx, [ebp + 8]      ; events
    mov ecx, [ebp + 12]     ; length
    ;; DO NOT MODIFY

	mov ecx, 0 ; counter for events array

checker:
	cmp ecx, [ebp + 12]
	jae end

	; aligning eax to date by skipping
	; name and valid
	mov ebx, [ebp + 8]
	xor eax, eax
	add eax, event_size
	mul ecx ; skipping ecx events
	add eax, ebx

	; dl represents the day
	mov dl, [eax + day]
	; dh represents the month
	mov dh, [eax + month]

	; checking validity of day and month
	push eax
	push ecx
	call f1
	mov dl, al
	pop ecx
	pop eax
	; day / month are correct - $dl = 1
	; day / month are false - $dl = 0

	; checking year
	mov bx, [eax + year]
	cmp bx, 1990
	jb fail_year
	cmp bx, 2030
	ja fail_year

	; date is correct - $bx = 1
	mov bx, 1
	jmp result_entry

fail_year:
	; date is correct - $bx = 0
	mov bx, 0

result_entry:
	and dl, bl
	; setting the value of valid to true or false
	mov byte[eax + valid], dl

incrementor:
	inc ecx
	jmp checker

end:
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY



; FUNCTION 1
f1:
	push ebp
	mov ebp, esp

	; al is the day
	mov al, dl
	; ah is the month
	mov ah, dh

	cmp ah, 1
	jb fail_f1

	cmp ah, 12
	ja fail_f1

	; month is valid; checking day
	cmp al, 1
	jb fail_f1

	cmp ah, 2
	jne normal_month_f1

	; month is february, checking special case
	cmp al, 28
	ja fail_f1 ; day is invalid
	jmp success_f1 ; day is valid

normal_month_f1:
	; computing the last day by
	; checking each month individually

	; these four months have 30 days
	cmp ah, 4
	je month_30days_f1

	cmp ah, 6
	je month_30days_f1

	cmp ah, 9
	je month_30days_f1

	cmp ah, 11
	je month_30days_f1

	; the month has 31 days
	mov ah, 31
	jmp check_day_f1

month_30days_f1:
	; the month has 31 days
	mov ah, 30

check_day_f1:
	cmp al, ah
	ja fail_f1

success_f1:
	mov eax, 1
	jmp end_f1

fail_f1:
	mov eax, 0

end_f1:
	leave
	ret