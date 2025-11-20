


section .text


inb:


    xor edi, edi
    in  al, dx          
    mov edi, al   

    ret


outb: 

    mov dx, di ;port 
    mov al. sil  ;value

    out dx, al
    

    ret