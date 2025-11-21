
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
    ;1 arg, row edi

    mov control_row, edi

set_cursor:
    ;1 arg offset edi


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
    ;arg1 col edi
    ;arg2 row esi

    mov eax, esi          
    imul eax, max_cols    
    add eax, edi          
    shl eax, 1           
    ret


set_char:
    ;arg1 offset edi
    ;arg2 char al

    mov ebx, vga_addr
    add ebx, edi ;move to offset 
    mov [ebx], al ;char
    mov byte [ebx+1], 0x07; attr


scroll_screen:
    ;arg1 mem_offset edi
    ;ret memory_offset - 2*MAX_COLS eax

    mov ebx, edi


    ;memcpy src

    mov edi, 0            
    ;row = cntrol_rol ++
    mov esi, [control_row]
    inc esi               
    call get_offset       
    add eax, vga_addr
    mov ebp, eax       
    

    ;memcpy dest

    mov edi, 0
    mov esi, [control_row]
    call get_offset        
    add eax, vga_addr
    mov edi, eax         

    ;memcpy #bytes
    mov ecx, max_rows
    sub ecx, [control_row]
    dec ecx             
    imul ecx, max_cols       
    shl ecx, 1                 

  
    mov esi, edi               
    mov edi, ebp  
    mov edx, ecx              
    call memory_copy


    ;clear last row
    mov ecx, 0 


.clear_last:
    cmp ecx, max_cols
    jge .clear_fin


    mov edi, ecx                
    mov esi, max_rows-1        
    call get_offset          

    mov al, ' '                 
    mov edi, eax                 
    call set_char_at_video_memory

    inc ecx
    jmp .clear_last


.clear_fin:

    mov eax, ebx                 
    sub eax, 2*max_cols
    ret


print:
    ;arg1 str
    call get_cursor
    mov edi, eax 
    
    xor ecx, ecx

.print_loop:

