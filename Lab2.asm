.model small
.stack 100h

.data

    originalStringMesssage db "Original string:", 0dh, 0ah, '$'
    newStringMessage db "Sorted string:", 0dh, 0ah, '$'
    newLine db 0dh, 0ah, '$'
    originalString db "dog beaver world$"
    flg dw 0
    
.code
    
    main PROC
        mov ax, @data
        mov ds, ax
        mov es, ax            
        
        mov dx, offset originalStringMesssage
        call outputString
        mov dx, offset originalString
        call outputString
        mov dx, offset newLine
        call outputString                 
                         
        mov si, offset originalString
        
        call sortString
        
        END_LABEL:
            mov dx, offset newStringMessage
            call outputString
	        mov dx, offset originalString				
	        call outputString						
	        mov ax, 4C00h
	        int 21h    
        
        ret
    endp main 
  
    outputString PROC
        mov ah, 9h
        int 21h
        ret
    endp outputString
    
    sortString PROC
        LABEL_1:
            call skipSpace  ; find beginning of the current word (si)
            mov di, si
            call skipLetter 
            dec di  ; find end of the current word (di)
            inc cx  ; length of the first word
            push cx
            push si  ; push beginning of the current word
            pop bx  ; now bx - beginning of the first word
            
            mov si, di         
            call skipSpace  ; find beginning of the next word (si) 
            mov di, si 
            call skipLetter 
            dec di  ; find end of the next word (di)            
                                   
            dec bx  ; dec bx for inc in the COMPARING                                      
            dec si  ; dec si for inc in the COMPARING 
        
            call compareWords
            
            WORD_WAS_FOUND:
                push cx  ; amount of offsetted letters after compairing
                call swapWords
                cmp flg, 1
                je END_LABEL
                jmp LABEL_1
          
        ret        
    endp sotrString

    skipSpace PROC  ; finding beginning of the word
        CHECK_SPACE:
            inc si
            cmp [si], ' '
            je CHECK_SPACE
                     
        ret                 
    endp skipSPace
    
    skipLetter PROC  ; finding end of the word 
        xor cx, cx
        CHECK_LETTER:
            inc di
            inc cx
            cmp [di], '$'
            je STOP
            cmp [di], ' '
            jne CHECK_LETTER
            jmp FINISH
            
        STOP:
            dec cx
            mov flg, 1            
            ret
            
        FINISH:
            ret
                             
    endp skipSPace
    
    compareWords PROC  ; words comparing
        xor cx, cx
        COMPARING:
            inc bx
            mov ax, [bx]  ; ax contains letter from the bx
            inc si  
            inc cx
            cmp ax, [si]
            je COMPARING  ; continue comparing if first letters of both words are the same
            cmp ax, [si]
            jg WORD_WAS_FOUND
            cmp ax, [si]
            jl LABEL_1
                   
        ret    
    endp compareWords
    
    swapWords PROC 
        mov bx, offset originalString 
        xor cx, cx
 
        PUSH_LETTERS:    
            cmp bx, di
            je PUT_LETTERS 
            push [bx] 
            inc bx
            inc cx 
            jmp PUSH_LETTERS
 
        PUT_LETTERS:
            push [di]
            inc cx    
            mov bx, offset originalString
 
            PUT_LOOP:                
                pop dx
                xor dh, dh
                mov [bx], dx 
                inc bx 
            loop PUT_LOOP
           
        pop cx
        pop cx
        sub si, cx
        sub di, si
        mov cx, di
        mov ax, cx 
        mov bx, offset originalString
        
        PUSH_LETTERS_OF_THE_LEFT_WORD:
            push [bx]
            inc bx
        loop PUSH_LETTERS_OF_THE_LEFT_WORD 
                      
        mov cx, ax
        mov bx, offset originalString
        xor dx, dx
        
        PUT_LETTERS_OF_THE_LEFT_WORD:
            pop dx
            xor dh, dh
            mov [bx], dx 
            inc bx
        loop PUT_LETTERS_OF_THE_LEFT_WORD 
        
        mov [bx], ' ' 
        pop cx
        pop cx
        mov ax, cx
        inc bx
        mov dx, bx
        
        PUSH_LETTERS_OF_THE_RIGHT_WORD:
            push [bx]
            inc bx
        loop PUSH_LETTERS_OF_THE_RIGHT_WORD
        
        mov cx, ax
        mov bx, dx
        
        PUT_LETTERS_OF_THE_RIGHT_WORD:
            pop dx
            xor dh, dh
            mov [bx], dx 
            inc bx
        loop PUT_LETTERS_OF_THE_RIGHT_WORD  
        
        
        jmp END_LABEL
        
        ret         
    endp swapWords
