
; ARGS
; edi 
; esi 
; edx



section .text 

vga_addr db 0xB8000
control_row db 0






.get_cursor: 
    xor eax 
    div edi, 2
    movi 


.screen_clear:
