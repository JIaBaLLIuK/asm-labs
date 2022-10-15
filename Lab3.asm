.model small

.stack 100h

.data
    buf db 13 dup("$")
    arr dw 31 dup(0)
    n dw 0
    m dw 0
    counter dw 1
    size dw 0
    sum dw 0 
    avgResult dw 0
    avgReminder dw 0
    amountMessage db "Enter amount of elements of array: $"
    numberMessage db "Enter number $"
    resultMessage db "Average result is $"
    doubleDot db ": $"
    dot db ".$"
    newLine db 0ah, 0dh, "$"

print MACRO outString
    mov ah,9
    mov dx, offset outString
    int 21h
endm

.code
main PROC
    mov ax, data
    mov ds, ax
    mov es, ax
    
    print amountMessage    
    call inputNumber
    mov size, ax
    mov cx, size
    print newLine
    
    call inputArray
    
    call findSum
    
    call findAvg
           
    print resultMessage
    mov ax, avgResult
    call intToString
    mov ah, 09h
    int 21h
    
    call getNumberAfterDecimalPoint
    push ax    
    
    print dot
    
    pop ax
    call intToString
    mov ah, 09h
    int 21h
    
    print dot
    
    mov ax, 4c00h
    int 21h
main endp

inputNumber PROC
    push dx
    push di
    push si
    
    mov ah, 0ah
    mov dx, offset buf
    int 21h
    
    mov di, offset buf + 1
    mov al, [di]
    xor ah, ah
    inc di
    mov si, di
    add di, ax
    mov [di], byte ptr 0
    call stringToInt
    
    pop si
    pop di
    pop dx
    ret
inputNumber endp

stringToInt PROC
    push dx
    push bx
    push bp
    push cx
    
    xor dx, dx
    xor bx, bx
    xor bp, bp
    
    cycle:
        xor ax, ax
        lodsb    
        test al, al
        jz exitWithSign
        cmp al, '-'
        jnz digit
        mov bx, 1
        jmp cycle
        
    digit:
        cmp al, '0'
        jb cycle
        cmp al, '9'
        ja cycle
        sub ax, '0'
        mov cx, 09h
        mov bp, dx
        
        umn:
            add dx,bp            
        loop umn
        
        add dx, ax
        jmp cycle
        
    exitWithSign:
        test bx, bx
        jz exit
        neg dx
        jmp exit
        
    exit:
        mov ax, dx
        pop cx
        pop bp
        pop bx
        pop dx
        ret                 
stringToInt endp

inputArray PROC
    push ax
    push bx
    
    xor bx, bx
    
    repeat:
        print numberMessage
        mov ax, counter
        call intToString
        mov ah, 09h
        int 21h
        print doubleDot      
        call inputNumber
        mov bx, ax
        print newLine
        mov ax, bx
        mov arr[si], ax
        add si, 2
        inc counter
    loop repeat
    
    pop bx
    pop ax    
inputArray endp

intToString proc
    push ax 
    push bx
    push cx
    push di
    
    mov di, 2
    xor cx, cx
    mov bx, 10
    
    divider:
        xor dx, dx
        div bx
        add dl, '0'
        push dx
        inc cx
        test ax, ax
        jnz divider
        
    string:
        pop dx
        mov buf[di], dl
        add di, 1
    loop string
    
    mov buf[di], '$'
    mov dx, offset buf + 2 
    
    pop di
    pop cx
    pop bx
    pop ax
    ret
intToString endp

findSum PROC
    push si
    push cx
    push ax
    push dx
     
    mov cx, size
    xor si, si
    xor ax, ax
    
    findSumLoop:
        mov ax, arr[si]
        add sum, ax
        add si, 2
    loop findSumLoop   
    
    pop dx 
    pop ax
    pop cx
    pop si    
    ret
findSum endp

findAvg PROC
    xor dx, dx
    
    mov ax, sum
    mov cx, size
    
    div cx
    
    mov avgResult, ax
    mov avgReminder, dx
    
    ret
findAvg endp

getNumberAfterDecimalPoint proc
    mov ax, avgReminder
    mov bx, 10
    mul bx
    xor dx, dx
    div size
    ret
getNumberAfterDecimalPoint endp
         