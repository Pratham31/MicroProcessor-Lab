section .data
        arr dq 123456789ABCDDFh,123444400000000Ah,-123444400000000Ah, 7FFFFFFFFFFFFFFFh
        n equ 4

        pmsg db "The Count of Positive No: ",10
        plen equ $-pmsg

        nmsg db "The Count of Negative No: ",10
        nlen equ $-nmsg

        nwline db 10

%macro write 2
        mov rax,1
        mov rdi,1 
        mov rsi,%1
        mov rdx,%2
        syscall
%endmacro

%macro exit 0
mov rax,60
mov rbx,0
syscall
%endmacro

    
section .bss

        pcnt resq 1
        ncnt resq 1
        dispbuff resb 16
    
section .text
        global _start
        _start:
                mov rsi,arr
                mov rdi,n
                mov rbx,0
                mov rcx,0
        
        up:    mov rax,[rsi]
               cmp rax,0000000000000000h
               js negative
    
        positive:    inc rbx
                     jmp next
        negative:    inc rcx
    
        next:    add rsi,8
                 dec rdi
                 jnz up   
                 mov [pcnt],rbx
                 mov [ncnt],rcx
                 write pmsg,plen
                 mov rax,[pcnt]

                 call dispproc

                write nwline,1

                write nmsg,nlen
                 mov rax,[ncnt]
                 call dispproc

                write nwline,1 

                 
      exit  
        
;display procedure for 64bit 

       
dispproc:
        mov rsi,dispbuff
        mov rcx,16

        cnt:    rol rax,4
                mov dl,al
                and dl,0FH
                cmp dl,09h
                jbe add30
                add dl,07h
        add30:  add dl,30h
                mov [rsi],dl
                inc rsi
                loop cnt
               
        write dispbuff,16
             ret
