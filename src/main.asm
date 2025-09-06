global _start

; calc output must be 0-9
; example uses addition with 4 + 3

section .data
    output db 0, 10 ; space for 1 char and a newline char
    length equ $ - output

section .text
_print:
    add r8,      '0'
    mov byte [output],   r8b
    mov byte [output+1], 10
    mov rax,             1              ; syscall: write
    mov rdi,             1              ; stdout
    lea rsi,             [rel output]   ; output address
    mov rdx,             length         ; output length
    syscall
    ret ; return control

_start:
    mov r12, 4  ; num1
    mov r13, 3  ; num2
    mov r14, 1  ; mode (1:add, 2:sub, 3:mul, 4:div)

    mov rdx, 0  ; div remainder

    mov r8,  0  ; to print results



    cmp r14, 1
    je l_add ; addition

    cmp r14, 2
    je l_sub ; subtraction

    cmp r14, 3
    je l_mul ; multiplication

    cmp r14, 4
    je l_div ; division



l_add:
    add r12, r13      ; add and store in r12
    mov r8,  r12      ; store in r8 to print
    call     _print   ; call print function
    jmp      l_end    ; end program

l_sub:
    sub r12, r13 ; sub and store in r12
    mov r8,  r12 ; store in r8 to print
    call _print ; call print function
    jmp l_end
l_mul:
    imul r12, r13 ; imul and store in r12
    mov r8,  r12  ; store in r8 to print
    call _print
    jmp l_end
l_div:
    cmp r13, 0   ; check if the divident is 0
    je l_error
    xor rdx, rdx ; clear remainder
    mov rax, r12
    div r13      ; rax = r12 (rax) / r13, rdx = r12 % r13
    mov r12, rax ; store back in r12
    mov r8, r12  ; store in al to print
    call _print
    jmp l_end
l_end:
    ; clear registers
    xor r12, r12
    xor r13, r13
    xor rdx, rdx
    xor r8,  r8
    xor rsi, rsi
    xor r14, r14

    mov rax, 60   ; exit program
    xor rdi, rdi  ; code 0
    syscall
l_error:
    mov rax, 60   ; exit program
    mov rdi, 1    ; code 1 (error)
    syscall