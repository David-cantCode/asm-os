


section .data

%define max_cols 45
%define max_rows 80


vga_addr equ 0xB8000

vga_index_reg  equ 0x3D4
vga_data_reg   equ 0x3D5
vga_off_low    equ 0x0F
vga_off_high   equ 0x0E


color db 0x0f

control_row dd 4

section .text 

extern memcpy
extern outb
extern inb 


set_cursor:
    ;arg1 offset in edi
    pusha

    ;div offset 2
    mov ebx, edi
    shr ebx, 1 

    ;set high    
    mov edx, vga_index_reg  
    mov al, vga_off_high        
    call outb

    mov edx, vga_data_reg    
    mov al, bh              
    call outb

    ;set low
    mov edx, vga_index_reg 
    mov al, vga_off_low         
    call outb
  
    mov edx, vga_data_reg    
    mov al, bl  
    call outb

    popa
    ret


get_cursor: 
    ;ret: eax offset
    

    push edx
    push ebx

    ;get high byte
    mov dx, vga_index_reg
    mov al, vga_off_high
    call outb

    mov dx, vga_data_reg
    call inb
    mov ah, al         

    ;low byte
    mov dx, vga_index_reg
    mov al, vga_off_low
    call outb

    mov dx, vga_data_reg
    call inb
    

    and eax, 0xFFFF ;clear upper
    shl eax, 1         

    pop edx
    pop ebx
    ret

get_offset:
    ;arg1 col edi
    ;arg2 row esi
  
    mov eax, esi          
    imul eax, max_cols    
    add eax, edi          
    shl eax, 1           

    ret

global set_char
set_char:
    ;arg1 offset edi
    ;arg2 char al

    pusha 

    mov ebx, vga_addr
    add ebx, edi ;move to offset 
    mov [ebx], al ;char
    mov byte [ebx+1], 0x07; attr

    popa

    ret

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
    mov edx, 4           
    call memcpy


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
    call set_char

    inc ecx
    jmp .clear_last


.clear_fin:

    mov eax, ebx                 
    sub eax, 2*max_cols
    ret


global printf
printf:
    ;arg1 str

    pusha 
    call get_cursor
    mov edi, eax 
    
    xor ecx, ecx

.print_loop:
    mov al, [esi + ecx] 
    cmp al, 0
    je .print_done


    cmp al, 10 ; '\n'
    je .handle_newline


    call set_char
    add edi, 2
    
    cmp edi, max_rows * max_cols * 2
    jb .next_char
    
    call scroll_screen
    mov edi, eax
    jmp .next_char

.handle_newline:
    mov eax, edi
    mov ebx, max_cols * 2
    xor edx, edx
    div ebx            
    
    inc eax             
    mul ebx             
    mov edi, eax        

.next_char:
    inc ecx              
    jmp .print_loop

.print_done:
    call set_cursor

    popa
    ret