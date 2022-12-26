.model tiny
.code
.186
org 100h

ClearString MACRO string
    push di
          
    mov   di, offset String
    mov   cx, 100
    mov   al, 0           
    rep   stosb  ; move al to di    
    
    pop di
endm

start:  

    call OpenFile
    
    mov sp, programLength + 100h + 200h  ; move stack for 200h bytes    
    mov ah, 4Ah  ; clear memory after program and stack
    stackShift = programLength + 100h + 200h
    
    push bx  ; push file identifier
    
    mov bx, stackShift shr 4 + 1
	int 21h
	
	pop bx  ; pop file identifier 
    
    mov	ax, cs
	mov word ptr EPB + 4, ax
	mov word ptr EPB + 8, ax
	mov word ptr EPB + 0Ch, ax 
	
	
	call ReadFileLine
	
	mov ax, 4B00h  
    mov dx, offset lineFromFile 
    
    push bx
    mov bx, offset EPB 
    pop bx
    
    int 21h 
    
    
        
    call CloseFile

OpenFile PROC
    mov dx, offset pathToFile
    mov ah, 3Dh
    mov al, 00h 
    int 21h
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
je STOP

cmp [si], 00h  ; end of file
je STOP

inc dx
jmp READ_SYMBOL

STOP:


LINE_END:

ret

CloseFile PROC
    mov ah,3Eh
    int 21h 
    ret   
CloseFile endp                                                                                                  

programLength equ $ - start 
pathtoFile db "file.txt", 0 
lineFromFile db 100 dup(0) 

EPB dw 0000
    dw offset commandline, 0
    dw 005Ch, 0,006Ch, 0 
    
commandline db 125
            db " /?"

end start