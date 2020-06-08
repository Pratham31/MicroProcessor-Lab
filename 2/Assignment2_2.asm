section .data
	menumsg db 10,10,'##### Menu for Overlapped Block Transfer #####',10
		db 10,'1.Block Transfer without using string instructions'
		db 10,'2.Block Transfer with using string instructions'
		db 10,'3.Exit',10
	menumsg_len equ $-menumsg
	wrchmsg db 10,10,'Wrong Choice Entered....Please try again!!!',10,10
	wrchmsg_len equ $-wrchmsg

	blk_bfrmsg db 10,'Block contents before transfer'
	blk_bfrmsg_len equ $-blk_bfrmsg

	blk_afrmsg db 10,'Block contents after transfer'
	blk_afrmsg_len equ $-blk_afrmsg

	srcmsg db 10,'Source block contents::'
	srcmsg_len equ $-srcmsg

	dstmsg db 10,'Destination block contents::'
	dstmsg_len equ $-dstmsg

	srcblk db 01h,02h,03h,04h,05h
	dstblk times 3 db 0
	cnt equ 05

	spacechar db 20h
	lfmsg db 10,10

section .bss
	optionbuff resb 02
	dispbuff resb 02

%macro dispmsg 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro accept 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .text
	global _start
_start:
	dispmsg blk_bfrmsg,blk_bfrmsg_len

	call showblks

menu:	dispmsg menumsg,menumsg_len

	accept optionbuff,02

	cmp byte [optionbuff],'1'
	jne case2
	call blkxferwo_proc

	jmp exit1

case2:	cmp byte [optionbuff],'2'
	jne case3
	call blkxferw_proc
	jmp exit1

case3:	cmp byte [optionbuff],'3'
	je exit
	dispmsg wrchmsg,wrchmsg_len
	jmp menu
exit1:
	dispmsg blk_afrmsg,blk_afrmsg_len
	call showblks
	dispmsg lfmsg,2
exit:	
	

	mov rax,60	;Exit
	mov rdi,0
	syscall

dispblk_proc:
	mov rcx,cnt
rdisp:
	push rcx
        push rsi
	mov bl,[esi]		;Read ASCII value char by char
	call disp8_proc		;& Display 
			
	dispmsg spacechar,1	;Display space
	 pop rsi
         pop rcx
         inc esi	        ;Point to next char
	loop rdisp		;Decrement count
				;Repeat display process till actual count becomes zero
	ret

blkxferwo_proc:
	mov esi,srcblk+4
	mov edi,dstblk+2
	mov ecx,cnt
blkup1:
	mov al,[esi]
	mov [edi],al
	dec esi
	dec edi
	loop blkup1

	ret

blkxferw_proc:
	mov esi,srcblk+4
	mov edi,dstblk+2
	mov ecx,cnt

	std
	rep movsb

	ret

showblks:
	dispmsg srcmsg,srcmsg_len

	mov esi,srcblk
	call dispblk_proc

	dispmsg dstmsg,dstmsg_len

	mov esi,dstblk-2
	call dispblk_proc
	ret

disp8_proc:
	mov ecx,02
	mov edi,dispbuff
dup1:
	rol bl,4
	mov al,bl
	and al,0fh
	cmp al,09
	jbe dskip
	add al,07h
dskip:	add al,30h
	mov [edi],al
	inc edi
	loop dup1

	dispmsg dispbuff,03
	ret

;###### OUTPUT ######

;[mahendra@(none) MILALP]$ nasm -f elf64 MIL1202B.asm
;[mahendra@(none) MILALP]$ ld -o MIL1202B MIL1202B.o
;[mahendra@(none) MILALP]$ ./MIL1202B

;Block contents before transfer
;Source block contents::01 02 03 04 05 
;Destination block contents::04 05 00 00 00 

;##### Menu for Overlapped Block Transfer #####

;1.Block Transfer without using string instructions
;2.Block Transfer with using string instructions
;3.Exit
;1

;Block contents after transfer
;Source block contents::01 02 03 01 02 
;Destination block contents::01 02 03 04 05 

;[mahendra@(none) MILALP]$ ./MIL1202B

;Block contents before transfer
;Source block contents::01 02 03 04 05 
;Destination block contents::04 05 00 00 00 

;##### Menu for Overlapped Block Transfer #####

;1.Block Transfer without using string instructions
;2.Block Transfer with using string instructions
;3.Exit
;2

;Block contents after transfer
;Source block contents::01 02 03 01 02 
;Destination block contents::01 02 03 04 05 

;[mahendra@(none) MILALP]$ ./MIL1202B

;Block contents before transfer
;Source block contents::01 02 03 04 05 
;Destination block contents::04 05 00 00 00 

;##### Menu for Overlapped Block Transfer #####

;1.Block Transfer without using string instructions
;2.Block Transfer with using string instructions
;3.Exit
;4


;Wrong Choice Entered....Please try again!!!



;##### Menu for Overlapped Block Transfer #####

;1.Block Transfer without using string instructions
;2.Block Transfer with using string instructions
;3.Exit
;3
;[mahendra@(none) MILALP]$ 

