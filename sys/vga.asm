
; ARGS
; edi 
; esi 
; edx



section .text 

vga_addr dd 0xB8000

vga_index_reg  equ 0x3D4
vga_data_reg   equ 0x3D5
vga_off_low    equ 0x0F
vga_off_high   equ 0x0E


max_rows db 45
max_cols db 80 
color db 0x0f

control_row db 0


control_line:
    mov control_row, edi

set_cursor:
    div edi, 2

    mov edi,vga_index_reg
    mov esi, vga_off_high
    call outb




get_cursor: 

get_offset:

set_char:


print:


scroll_screen:


clear_screen:
