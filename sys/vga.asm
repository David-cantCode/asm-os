
; ARGS
; edi 
; esi 
; edx



section .text 

%define max_cols 45
%define max_rows 80


vga_addr dd 0xB8000

vga_index_reg  equ 0x3D4
vga_data_reg   equ 0x3D5
vga_off_low    equ 0x0F
vga_off_high   equ 0x0E


color db 0x0f

control_row db 0


control_line:
    ;1 arg, row

    mov control_row, edi

set_cursor:
    ;1 arg offset


    ;div offset 2
    shr edi, 1
    mov ebx, edi


    mov edi, vga_index_reg    
    mov al, vga_off_high        
    call outb


    mov edi, vga_data_reg       
    mov al, bh ;high byte off
    call outb


    mov edi, vga_index_reg
    mov al, vga_off_low         
    call outb

  
    mov edi, vga_data_reg
    mov al, bl ;low byte off
    call outb

    ret



get_cursor: 
    ;ret offset eax
    
    xor esi, esi

    mov edi, vga_index_reg    
    mov al, vga_off_high        
    call outb


    push dword vga_data_reg
    call inb
    pop edx  
    shl eax, 8 ;high byte
    mov ebx, eax


    mov edi, vga_index_reg
    mov al, vga_off_low
    call outb


    push dword vga_data_reg
    call inb
    pop edx  
    add ebx, eax 

    shl ebx, 1 ;*2
    mov eax, ebx   



get_offset:
    ;2 args col, row

    mov eax, [esp+8] ;row
    imul eax, max_cols
    add eax, [esp+4] ;+= col
    shl eax, 1
    ret



set_char:
    ;2 args
    ;store char in al
    ;store offset in edi

    mov ebx, vga_addr
    add ebx, edi ;move to offset 
    mov [ebx], al ;char
    mov byte [ebx+1], 0x07; attr


scroll_screen:
    ;1 arg mem_offset



print:
    ;1 arg str

    



clear_screen:
