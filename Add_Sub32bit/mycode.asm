org 100h

.data
th1  dd 87654321h           
th2  dd 9ABCDEF0h           
kq   dd ?                   

.code
assume cs:code ds:data
main:
    mov ax, @data
    mov ds, ax              

    ; add 2 32bit
    mov ax, word ptr th1    
    mov bx, word ptr th2    
    add ax, bx              
    mov word ptr kq, ax     

    mov ax, word ptr th1+2  
    mov bx, word ptr th2+2 
    adc ax, bx              
    mov word ptr kq+2, ax   

    ; print result message "SUM" 
    mov ah, 09h
    mov dx, offset msg_sum
    int 21h

    ; print result 
    mov si, offset kq
    call print_bin32

    ;newline
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ; subtract 32 bit
    mov ax, word ptr th1    
    mov bx, word ptr th2    
    sub ax, bx              
    mov word ptr kq, ax     

    mov ax, word ptr th1+2  
    mov bx, word ptr th2+2  
    sbb ax, bx              
    mov word ptr kq+2, ax   

    ; Print "SUB: "
    mov ah, 09h
    mov dx, offset msg_sub
    int 21h

    ; print result in 32bit
    mov si, offset kq
    call print_bin32

    ;newline
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ; exit 
    mov ah, 4Ch
    int 21h

; SI points to the double word to print
print_bin32:
    push ax
    push bx
    push cx
    push dx
    push si

    mov cx, 16
    mov bx, 8000h           ; mask for the highest bit
    mov ax, [si+2]          ; print high word first
print_high_loop:
    test ax, bx
    jz print_high_zero
    mov dl, '1'
    jmp print_high_output
print_high_zero:
    mov dl, '0'
print_high_output:
    mov ah, 02h
    int 21h
    shr bx, 1
    loop print_high_loop

    mov cx, 16
    mov bx, 8000h           ; reset mask for low word
    mov ax, [si]            ; print low word next
print_low_loop:
    test ax, bx
    jz print_low_zero
    mov dl, '1'
    jmp print_low_output
print_low_zero:
    mov dl, '0'
print_low_output:
    mov ah, 02h
    int 21h
    shr bx, 1
    loop print_low_loop

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

msg_sum db 'SUM: $'
msg_sub db 'SUB: $'