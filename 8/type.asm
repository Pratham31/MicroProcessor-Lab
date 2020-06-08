%macro cmn 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro
 
%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro
 
%macro fopen 1
mov rax,2
mov rdi,%1
mov rsi,2
mov rdx,077o
syscall
%endmacro
 
%macro fread 3
mov rax,0
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro
 
%macro fwrite 3
mov rax,1
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro
 
%macro fclose 1
mov rax,3
mov rdi,%1
syscall
%endmacro
 
section .data
 
menu db "Menu :",0ah
     db "1.TYPE",0ah
     db "2.COPY",0ah
     db "3.DELETE",0ah
     db "4.EXIT",0ah
     db "Enter your choice:"
menulen equ $-menu
 
msg db "Command :"
msglen equ $-msg
 
cpysc db"File copied successfully!!",0ah
cpysclen equ $-cpysc
 
delsc db"File deleted successfully!!",0ah
delsclen equ $-delsc
 
err db "Error ....",0ah
errlen equ $-err
 
cpywr db "Command does not exist",0ah
cpywrlen equ $-cpywr
 
err_par db "Insufficient parameter",0ah
err_parlen equ $-err_par
 
section .bss
 
choice resb 2
buffer resb 50
name1 resb 15
name2 resb 15
cmdlen resb 1
filehandle1 resq 1
filehandle2 resq 2
abuf_len resq 1
dispnum resb 2
buf resb 4096
buf_len equ $-buf
 
section .text
global _start
_start:
again: cmn 1,1,menu,menulen
cmn 0,0,choice,2
 
mov al,byte[choice]
cmp al,31h
jbe op1
cmp al,32h
jbe op2
cmp al,33h
jbe op3
cmp al,34h
jbe exit
 
op1:
call tproc
jmp again
 
op2:
call cpproc
jmp again
 
op3:
call delproc
jmp again
 
;---------------------------------;
 
tproc:
cmn 1,1,msg,msglen
cmn 0,0,buffer,50
 
mov byte[cmdlen],al
dec byte[cmdlen]
 
mov rsi,buffer
mov al,[rsi]
cmp al,'t'
jne skipt
inc rsi
dec byte[cmdlen]
jz skipt
 
mov al,[rsi]
cmp al,'y'
jne skipt
inc rsi
dec byte[cmdlen]
jz skipt
 
mov al,[rsi]
cmp al,'p'
jne skipt
inc rsi
dec byte[cmdlen]
jz skipt
 
mov al,[rsi]
cmp al,'e'
jne skipt
inc rsi
dec byte[cmdlen]
jnz correctt
cmn 1,1,err_par,err_parlen
exit
 
skipt:
cmn 1,1,cpywr,cpywrlen
 
correctt:
mov rdi,name1
call find_name
 
fopen name1
cmp rax,-1h
jle error
mov [filehandle1],rax
 
xor rax,rax
fread [filehandle1],buf,buf_len
mov [abuf_len],rax
dec byte[abuf_len]
 
cmn 1,1,buf,abuf_len
 
ret
 
;------------------------------------;
 
cpproc:
cmn 1,1,msg,msglen
cmn 0,0,buffer,50
 
mov byte[cmdlen],al
dec byte[cmdlen]
 
mov rsi,buffer
mov al,[rsi]
cmp al,'c'
jne skip
inc rsi
dec byte[cmdlen]
jz skip
 
mov al,[rsi]
cmp al,'o'
jne skip
inc rsi
dec byte[cmdlen]
jz skip
 
mov al,[rsi]
cmp al,'p'
jne skip
inc rsi
dec byte[cmdlen]
jz skip
 
mov al,[rsi]
cmp al,'y'
jne skip
inc rsi
dec byte[cmdlen]
jnz correct
cmn 1,1,err_par,err_parlen
call exit
 
skip:
cmn 1,1,cpywr,cpywrlen
 
correct:
mov rdi,name1
call find_name
 
mov rdi,name2
call find_name
 
skip3:
fopen name1
cmp rax,-1h
jle error
mov [filehandle1],rax
 
fopen name2
cmp rax,-1h
jle error
mov [filehandle2],rax
 
xor rax,rax
fread [filehandle1],buf,buf_len
mov [abuf_len],rax
dec byte[abuf_len]
 
fwrite [filehandle2],buf,[abuf_len]
fclose[filehandle1]
fclose[filehandle2]
cmn 1,1,cpysc,cpysclen
jmp again
 
error:
cmn 1,1,err,errlen
ret
 
 
;---------------------------------------;
 
 
delproc:
cmn 1,1,msg,msglen
cmn 0,0,buffer,50
 
mov byte[cmdlen],al
dec byte[cmdlen]
 
mov rsi,buffer
mov al,[rsi]
cmp al,'d'
jne skipr
inc rsi
dec byte[cmdlen]
jz skipr
 
mov al,[rsi]
cmp al,'e'
jne skipr
inc rsi
dec byte[cmdlen]
jz skipr
 
mov al,[rsi]
cmp al,'l'
jne skipr
inc rsi
dec byte[cmdlen]
jnz correctr
cmn 1,1,cpywr,cpywrlen
 
 
skipr:
cmn 1,1,cpywr,cpywrlen
 
correctr:
mov rdi,name1
call find_name
mov rax,87
mov rdi,name1
syscall
 
cmp rax,-1h
jle errord
cmn 1,1,delsc,delsclen
jmp again
 
 
errord:
cmn 1,1,err,errlen
ret
 
;-----------------------------;
 
find_name:
inc rsi
dec byte[cmdlen]
 
cont1:
mov al,[rsi]
mov [rdi],al
inc rdi
inc rsi
mov al,[rsi]
cmp al,20h
je skip2
cmp al,0ah
je skip2
dec byte[cmdlen]
jnz cont1
cmn 1,1,err,errlen
 
skip2:
ret
 
Output:
 
student@student:~/Desktop$ cd MP
student@student:~/Desktop/MP$ nasm -f elf64 cmd.asm
student@student:~/Desktop/MP$ ld -o p cmd.o
student@student:~/Desktop/MP$ ./p
Menu :
1.TYPE
2.COPY
3.DELETE
4.EXIT
Enter your choice:1
Command :type f1.txt
hi..
hello..
 
Menu :
1.TYPE
2.COPY
3.DELETE
4.EXIT
Enter your choice:2
Command :copy f1.txt f2.txt
File copied successfully!!
Menu :
1.TYPE
2.COPY
3.DELETE
4.EXIT
Enter your choice:3
Command :del f2.txt
File deleted successfully!!
Menu :
1.TYPE
2.COPY
3.DELETE
4.EXIT
Enter your choice:4