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
    message: db "Quel est ton nom ?"
    MESSAGE_LENGTH: equ $-message
    USERNAME_MAX_LENGTH: equ 12 ; 10 carac + 2 pour le retour à la ligne

section .bss
    written: resd 1 
    read: resd 1
    username: resb USERNAME_MAX_LENGTH

section .text
    global main
    main:
        sub rsp, SHADOWSPACE_SIZE
        ;------------------------

        ;demande de saisie
        mov rcx, STD_OUTPUT_HANDLE
        call GetStdHandle

        mov rcx, rax
        mov rdx, message
        mov r8, MESSAGE_LENGTH
        mov r9, written
        mov qword [rsp + SHADOWSPACE_SIZE], 0
        call WriteConsoleA

        ;lecture du clavier
        mov rcx, STD_INPUT_HANDLE
        call GetStdHandle

        mov rcx, rax
        mov rdx, username
        mov r8, USERNAME_MAX_LENGTH
        mov r9, read
        mov qword [rsp + SHADOWSPACE_SIZE], 0
        call ReadConsoleA


        ;Affichage de la saisie
        mov rcx, STD_OUTPUT_HANDLE
        call GetStdHandle

        mov rcx, rax
        mov rdx, username
        mov r8, USERNAME_MAX_LENGTH
        mov r9, written
        mov qword [rsp + SHADOWSPACE_SIZE], 0
        call WriteConsoleA

        ;------------------------
        add rsp, SHADOWSPACE_SIZE
        
        xor rcx, rcx
        call ExitProcess