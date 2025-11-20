
[BITS 32]

global _start 


section .text

_start:
    mov edi, 0xB8000 ;vga buff
    mov ecx, 80*25  ;rols*cols           
    mov ax, 0x0720 ;store' '


.clear_loop:
    stosw                    
    loop .clear_loop


.done:

    mov 


    jmp .done