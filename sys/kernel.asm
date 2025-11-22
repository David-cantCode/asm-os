
[BITS 32]

section .data
hello db "Hello world", 0
kernel_load db "Kernel was loaded", 0


section .text

extern set_char
extern printf
global _start 


_start:
    mov edi, 0xB8000 ;vga buff
    mov ecx, 80*25  ;rols*cols           
    mov ax, 0x0720 ;store' '


.clear_loop:
    stosw                    
    loop .clear_loop


.done:
    call print_hi

    jmp $


print_hi:
    mov edi, 0xB8000

    mov al, 'H'
    mov ah, 0x07
    mov [edi], ax


    add edi, 2
    mov al, 'I'
    mov ah, 0x07
    mov [edi], ax





    mov esi, hello
    call printf

    mov esi, kernel_load
    call printf




    ret

