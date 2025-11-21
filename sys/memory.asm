
memcpy:
    ;3 args: edi source, esi dest, edx num bytes
    xor ecx, ecx

.copy_loop:
    cmp ecx, edx
    jae .done

    ;mov byte src[ecx] -> detst[esx]
    mov al, [edi + ecx]
    mov [esi + ecx], al     

    inc ecx
    jmp .copy_loop

.done:
    ret
   