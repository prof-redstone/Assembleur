bits 64
;vectorcall

extern GetStdHandle ; gestionnaire de péripherique
extern WriteConsoleA ; ecriture en mode console
extern ReadConsoleA ; pour lire sur la console
extern ExitProcess ; arret du processus


STD_OUTPUT_HANDLE: equ -11
STD_INPUT_HANDLE: equ -10
SHADOWSPACE_SIZE: equ 32+8

section .data
    n1: dq 5
    n2: dq 5
    message_equals: db "n1 est egal a n2", 10
    message_not_equals: db "n1 est different de n2", 10
    ;MESSAGE_EQUALS_LEN: equ $-message_equals
    ;MESSAGE_NOT_EQUALS_LEN: equ $-message_not_equals

section .bss
    written: resd 1 

section .text
    global main
    main:
        sub rsp, SHADOWSPACE_SIZE

        mov rax, [n1]
        mov rbx, [n2]
        cmp rax, rbx
        je equals
        jmp not_equals

        equals:
            ;affichage de message
            mov rcx, STD_OUTPUT_HANDLE
            call GetStdHandle

            mov rcx, rax
            mov rdx, message_equals
            mov r8, 17
            mov r9, written
            mov qword [rsp + SHADOWSPACE_SIZE], 0
            call WriteConsoleA 
            jmp exit

        not_equals:
            ;affichage de message
            mov rcx, STD_OUTPUT_HANDLE
            call GetStdHandle

            mov rcx, rax
            mov rdx, message_not_equals
            mov r8, 23
            mov r9, written
            mov qword [rsp + SHADOWSPACE_SIZE], 0
            call WriteConsoleA 
            jmp exit


        exit:
            ;quitter le programme
            add rsp, SHADOWSPACE_SIZE
            xor rcx, rcx
            call ExitProcess