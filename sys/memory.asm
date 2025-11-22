
section .text

global memcpy
memcpy:
    ;3 args: edi source, esi dest, edx num bytes
    test edx, edx
    jz .done           ; nothing to copy

    xor ecx, ecx

.copy_loop:
    cmp ecx, edx
    jae .done

    mov al, [edi + ecx]
    mov [esi + ecx], al
    inc ecx
    jmp .copy_loop

.done:
    ret