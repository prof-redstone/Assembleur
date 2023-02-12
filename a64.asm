bits 64
;vectorcall
;%define hello 'Hello World !';macro qui estremplacé avant assemblage
;%define message_length 13;macro de la longueur de la chaine

extern GetStdHandle ; gestionnaire de péripherique
extern WriteConsoleA ; ecriture en mode console
extern ReadConsoleA ; pour lire sur la console
extern ExitProcess ; arret du processus


STD_OUTPUT_HANDLE: equ -11
STD_INPUT_HANDLE: equ -10
SHADOWSPACE_SIZE: equ 32+8

section .data
    message db "Bonjour tout le monde !", 10 ; 10 -> retour a la ligne
    message_length equ $-message


section .bss
    written resq 1 ;reserve un qword *1
    mydata: resb 64; octet*64

section .text
    global main
    main:
        mov rcx, STD_OUTPUT_HANDLE ;premier argument -11 pour la sortie standar, 
        call GetStdHandle

        sub rsp, SHADOWSPACE_SIZE

        mov rcx, rax
        mov rdx, message
        mov r8, message_length; longueur de la chaine 
        mov r9, written
        mov qword [rsp+32], 0
        call WriteConsoleA

        add rsp, SHADOWSPACE_SIZE
        
        xor rcx, rcx
        call ExitProcess