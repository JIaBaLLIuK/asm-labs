.model tiny  
.code

org 100h 

start:
mov     ah, 9h 
mov     dx, offset message  
int 21h 

ret    

message db "Hello, World!$"

end start 
