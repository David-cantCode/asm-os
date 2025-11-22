


section .text

global inb
inb:
    in al, dx
    ret



global outb
outb:
    out dx, al
    ret