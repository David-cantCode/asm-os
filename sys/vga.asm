
; ARGS
; edi 
; esi 
; edx



section .text 

vga_addr db 0xB8000
vga_index_reg db 0x3d4
vga_data_reg db 0x3d5
vga_off_low db 0x0f
vga_off_high db 0x0e


max_rows db 45
max_cols db 80 
color db 0x0f

control_row db 0

control_line:

set_cursor:


get_cursor: 

get_offset:

set_char:


print:


scroll_screen:


clear_screen:
