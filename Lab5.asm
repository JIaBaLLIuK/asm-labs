.model small

.stack 100h

.data
    buf db 13 dup("$")  
    inputSymbolMessage db "Input symbols:$"
    symbols db 22 dup("$")
    pathToFile db "file.txt", 0   
    endLine db 0Ah, 0Dh, "$"  
    lineFromFile db 100 dup ("$")
    symbolsStringSize EQU 200
    linesAmountMessage db "The number of lines from file with this symbols is:$" 
    
    amountOfUsersSymbolInLine db 0
    stringAmount dw 0 
    
print MACRO outString
    mov ah, 09h
    mov dx, offset outString
    int 21h
endm
 
input MACRO buf
    mov ah, 0Ah
    mov dx, offset buf
    int 21h
endm

ClearString MACRO string
    push di
          
    mov   di, offset String
    mov   cx, 100
    mov   al, "$"           
    rep   stosb  ; move al to di    
    
    pop di
endm
     
.code 
main PROC
    mov ax, data
    mov ds, ax
    mov es, ax 
    
    print inputSymbolMessage
    print endLine
         
    input symbols
    mov symbols[0], symbolsStringSize
    
    print endLine
    
    call OpenFile
    
    call ReadFileLine 
        
    EXIT:
    print linesAmountMessage
    print endLine
    
    mov ax, stringAmount
    call IntToString
    mov ah, 09h
    int 21h
    
    call CloseFile            
    mov ax, 4C00h
    int 21h
main endp 

OpenFile PROC
    mov dx, offset pathToFile
    mov ah, 3Dh
    mov al, 00h 
    int 21h
     
    jc EXIT  ; error occured 
       
    mov bx, ax 
    ret   
OpenFile endp 

ReadFileLine PROC
    mov dx, offset lineFromFile
    
    READ_SYMBOL:
    mov cx, 1       
    mov ah, 3Fh  ; read 1 symbol
    int 21h
    
    mov si, dx                                                                            
                                                                                                                                                                                         
    cmp [si], 0Ah  ; end of line in file
    je stop
      
    cmp [si], 00h  ; end of file
    je stop
              
    inc dx
    jmp READ_SYMBOL
    
    STOP:
        call FindInputtedSymbols
        
    ret                                                                  

FindInputtedSymbols PROC
    push si
    push cx
    push bx
    push dx
    
    mov si, offset symbols[1]
    
    xor cx, cx
    xor bx, bx
    
    mov cl, symbols[1]  ; cl - amount of user symbols
    
    TAKE_NEXT_SYMBOL:
    inc si
    mov bx, [si]  ; bx - symbol from user input
    mov di, offset lineFromFile
    dec di
    
        CMP_SYMBOL_AND_LINE: 
        inc di
        mov dx, [di]  ; dx - symbol from line
        cmp dl, bl  ; cmp symbol from line and bl
        je EQUAL
        
        jmp NOT_EQUAL
                                        
        EQUAL:
        inc amountOfUsersSymbolInLine 
        dec cl
        cmp cl, 0  ; end of user symbols line
        je STOP_CMP               
        jmp TAKE_NEXT_SYMBOL
        
        NOT_EQUAL:
        cmp [di], "$"  ; end of line
        je STOP_CMP
        jmp CMP_SYMBOL_AND_LINE
    
    STOP_CMP:        
    mov cl, symbols[1]
    cmp amountOfUsersSymbolInLine, cl  ; cmp length of the user symbols and amount of symbols from line
    jne RETURN
    
    inc stringAmount
    
    RETURN:
     
    pop dx
    pop bx
    pop cx
    pop si
    
    cmp [si], 00h  ; end of file
    je EXIT
    
    mov amountOfUsersSymbolInLine, 0
    
    ClearString lineFromFile    
    call ReadFileLine
     
    ret
FindInputtedSymbols endp

IntToString PROC
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
IntToString endp

CloseFile PROC
    mov ah,3Eh
    int 21h 
    ret   
CloseFile endp
