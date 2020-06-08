section .data
 
msg db 10,'Enter two digit Number::'
msg_len equ $-msg

res db 10,'Multiplication of elements is::'
res_len equ $-res

choice db 10,13,'Enter your Choice:'
       db 10,13,'1.Successive Addition'
       db 10,13,'2.Add and Shift method'
       db 10,13,'3.Exit'

choice_len equ $-choice
 num   db 03
num1  db 01
n db 00

%macro write 2
    mov rax,1
    mov rdi,1
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro
 
%macro read 2
    mov rax,0
    mov rdi,0
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

%macro exit 0
  mov rax,60 
  mov rdi,0
  syscall
%endmacro
 
section .bss

result resb 04
cho resb 2
 
 
section .text
 
global _start
_start:
 
   mov rbx,00
   mov rcx,00
    mov rax,00
     mov rdx,00
    
    mov byte[result],0
   
 
    write choice,choice_len
    read  cho,2
 
    cmp byte[cho],31h
        je a
 
    cmp byte[cho],32h
         je b
     
        jmp exit
 
    a:  call Succe_addition
 
         jmp _start
 
    b:  call Add_shift
 
        jmp _start
  
exit
   

 
dispproc:
    mov rcx,4
    mov rdi,result
    dup1:
    rol bx,4
    mov al,bl
    and al,0fh
     add al,30h
    cmp al,39h
    jbe skip
     add al,07h
 skip: mov [rdi],al
    inc rdi
    loop dup1
 
    write result,4
ret
 
 
Succe_addition:
 
    mov esi,num
    mov edi,n
 
   mov bl,[esi]
    mov [edi],bl
    inc esi 
    inc edi
    xor rcx,rcx
    xor rax,rax
    mov rax,[num1]
     
    repet:
    add rcx,rax
    dec byte[n]
    jnz repet
 
    mov [result],rcx
    write res,res_len
    mov rbx,[result]
 
    call dispproc
ret
 
 
 
Add_shift:
      
 
 
    xor rbx,rbx
    xor rcx,rcx
    xor rdx,rdx
    xor rax,rax
    mov dl,08
    mov al,[num1]
    mov bl,[num]
 
  p11:shr bx,01
      jnc p
      add cx,ax
  p :shl ax,01
      dec dl
      jnz p11
 
    mov [result],rcx
    write res,res_len
 
    mov rbx,[result]
    call dispproc
 
ret
 
