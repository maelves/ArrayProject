.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem msvcrt.lib, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern gets: proc
extern strlen: proc
extern fopen: proc
extern fputs: proc
extern fprintf: proc
extern fclose: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
sir_A db 100 dup(0) 
sir_B db 100 dup(0) 
sir1 db 100 dup(0)
sir2 db 100 dup(0)
e db ?
op dd 0
buffer db 0
card dd 0
dump db 0
ok db 0
count dd 0
gasit_2 dd 0
of_file dd 0
card_A dd 0
card_B dd 0
var dd 0

meniu db "Introduceti o operatie cu multimi: ", 13, 10, 0
optiuni db " 1. Verificare", 13, 10, " 2. Apartenenta", 13, 10, " 3. Diferenta", 13, 10, " 4. Produs cartezian", 13, 10, 0
msg_mult db "Elementele multimii: ", 13, 10, 0
msg_multB db "Elementele multimii B: ", 13, 10, 0
msg_e db "e = ", 0
msg_diferenta db "Diferenta A-B este: ", 13, 10, 0
eroare_operatie db "Operatia nu exista!", 13, 10, 0
eroare_sir db "Multimea este vida", 13, 10, 0
avem_duplicate db "Avem dublicate in multime", 13, 10, 0
nu_avem_duplicate db "NU avem dublicate in multime", 13, 10, 0
diferenta_nula db "Nu exista elemente necomune in prima multime!", 13, 10, 0
element_gasit db "Elemetul apartine multimii", 13, 10, 0
element_negasit db "Elementul nu apartine multimii", 13, 10 ,0
fisier_rezultat db "Fisier rezultat: rezultat.txt", 13, 10, 0
produs_cartezian db "Produsul cartezian AxB este: ", 13, 10 , 0

format1 db "%d", 0
format_sir db "%s", 0
format_fisier db "w", 0
format_diferenta db "%c ", 0
linie_noua db 13, 10, 0
format_produs db "(%c, %c)", 13, 10, 0
out_sir db "%s",13,10,0

fisier db "rezultat.txt", 0
	
.code

citire macro sir

		push offset msg_mult ;mesaj pt a cere elementele multimii
		call printf
		add esp, 4

		push offset buffer ;
		call gets
		add esp, 4
		push offset sir ;citim de la tastatura multimea 
		call gets
		add esp, 4

endm

citire_b macro sir

		push offset msg_mult ;mesaj pt a cere elementele multimii
		call printf
		add esp, 4

		push offset sir ;citim de la tastatura multimea 
		call gets
		add esp, 4

endm

op_1 PROC
		push ebp
		mov ebp, esp
		
		citire sir_A
		
		;verificam daca exista dubluri
		mov eax, 0
		
		push offset sir_A ;vrem sa avem lungimea sirului
		call strlen
		add esp, 4
		
		cmp eax, 0 ;verificam sa nu fie goala multimea
		je err_sir
		cmp eax, 0
		jne not_err
		
		err_sir: ;mesaj de eroare in caz ca avem multimea vida
			push offset eroare_sir
			call printf
			add esp, 4
			jmp fin
		
		not_err:
			mov card, eax
			mov ecx, 0
		for1:
			
			cmp ecx, card ;ecx = card, verificam daca nu am ajuns la finalul sirului 
			jge exit_for1
			mov edi, 0 ;edi = 0, il folosim drept indice
			for2:
				cmp edi, count ;for2
				jge stopp ;conditie de stop pentru al doilea for
				
				mov ebx, 0 ;ne asiguram ca ebx e 0
				mov bl, sir_A[ecx] ;mutam elementul pentru a putea face comparatia
				cmp bl, sir1[edi] ; if(a[c]==b[d])
				je stopp_1
				
				add edi, 1 ;verificam urmatorul element, +1 deoarece avem byte
				
			jmp for2
			
			stopp_1:
			mov gasit_2,1;Vezi daca ai sau nu elemente duplicate
			
			stopp:
				add ecx, 1 ;incrementez ecx daca cumva count diferit de edi
				cmp count, edi ;if(d == count)
				jne for1 ;daca sunt diferite sarim la for1
				
				sub ecx, 1
				mov edx, 0
				mov dl, sir_A[ecx]
				mov esi, count
				mov sir1[esi], dl
				
				add ecx, 1
				add count, 1
				
		jmp for1
				
		exit_for1:		;ies din primul for
		;push offset sir1 ;afisez sirul rezultat pentru a ma verifica
		;push offset format_sir
		;call printf
		;add esp, 8
		
		push offset format_fisier ;deschidem fisierul
		push offset fisier
		call fopen
		add esp, 8
			
		mov esi, eax;trebuie pus in alt registru pentru ca dupa ce se fac instructiuni, valoarea lui eax se schimba
		
		cmp gasit_2, 0
		je nu_avem
		
		push offset avem_duplicate
		call printf
		add esp, 4
		
		push offset fisier_rezultat ;afisam mesajul de fisier
		call printf
		add esp, 4
		
		push offset avem_duplicate
		;push offset format_sir
		push esi ;scriem mesaj in fisier
		call fprintf
		add esp, 8
		
		push esi
		call fclose
		push 0
		jmp fin
			
		nu_avem:
			push offset nu_avem_duplicate
			call printf
			add esp, 4
			
			push offset nu_avem_duplicate
			;push offset format_sir
			push esi ;scriem mesaj in fisier
			call fprintf
			add esp, 8
			
			push offset fisier_rezultat ;afisam mesajul de fisier
			call printf
			add esp, 4
			
			push esi
			call fclose
			push 0
		
			jmp fin
			
		fin:
			
			mov esp, ebp
			pop ebp
		ret 
op_1 ENDP


op_1_fA PROC 
		push ebp
		mov ebp, esp
		
		
		;verificam daca exista dubluri
		mov eax, 0
		
		push offset sir_A ;vrem sa avem lungimea sirului
		call strlen
		add esp, 4
		
		cmp eax, 0 ;verificam sa nu fie goala multimea
		je err_sir
		cmp eax, 0
		jne not_err
		
		err_sir: ;mesaj de eroare in caz ca avem multimea vida
			push offset eroare_sir
			call printf
			add esp, 4
			jmp fin
		
		not_err:
			mov card, eax
			mov ecx, 0
			
		for1:
			
			cmp ecx, card ;ecx = card, verificam daca nu am ajuns la finalul sirului 
			jge exit_for1
			mov edi, 0 ;edi = 0, il folosim drept indice
			for2:
				cmp edi, count ;for2
				jge stopp ;conditie de stop pentru al doilea for
				
				mov ebx, 0 ;ne asiguram ca ebx e 0
				mov bl, sir_A[ecx] ;mutam elementul pentru a putea face comparatia
				cmp bl, sir1[edi] ; if(a[c]==b[d])
				je stopp
				
				add edi, 1 ;verificam urmatorul element, +1 deoarece avem byte
				
			jmp for2
			
			stopp:
				add ecx, 1 ;incrementez ecx daca cumva count diferit de edi
				cmp count, edi ;if(d == count)
				jne for1 ;daca sunt diferite sarim la for1
				
				sub ecx, 1
				mov edx, 0
				mov dl, sir_A[ecx]
				mov esi, count
				mov sir1[esi], dl
				add ecx, 1
				add count, 1
				
				
				
		jmp for1
				
		exit_for1: ;ies din primul for
			
		
		fin:
			mov esp, ebp
			pop ebp
		ret 
op_1_fA ENDP

op_1_fB PROC 
		push ebp
		mov ebp, esp
		
		
		;verificam daca exista dubluri
		mov eax, 0
		mov count, 0
		
		push offset sir_B ;vrem sa avem lungimea sirului
		call strlen
		add esp, 4
		
		cmp eax, 0 ;verificam sa nu fie goala multimea
		je err_sir
		cmp eax, 0
		jne not_err
		
		err_sir: ;mesaj de eroare in caz ca avem multimea vida
			push offset eroare_sir
			call printf
			add esp, 4
			jmp fin
		
		not_err:
			mov card, eax
			mov ecx, 0
			
		for1:
			
			cmp ecx, card ;ecx = card, verificam daca nu am ajuns la finalul sirului 
			jge exit_for1
			mov edi, 0 ;edi = 0, il folosim drept indice
			for2:
				cmp edi, count ;for2
				jge stopp ;conditie de stop pentru al doilea for
				
				mov ebx, 0 ;ne asiguram ca ebx e 0
				mov bl, sir_B[ecx] ;mutam elementul pentru a putea face comparatia
				cmp bl, sir2[edi] ; if(a[c]==b[d])
				je stopp
				
				add edi, 1 ;verificam urmatorul element, +1 deoarece avem byte
				
			jmp for2
			
			stopp:
				add ecx, 1 ;incrementez ecx daca cumva count diferit de edi
				cmp count, edi ;if(d == count)
				jne for1 ;daca sunt diferite sarim la for1
				
				sub ecx, 1
				mov edx, 0
				mov dl, sir_B[ecx]
				mov esi, count
				mov sir2[esi], dl
				add ecx, 1
				add count, 1
				
				
				
		jmp for1
				
		exit_for1: ;ies din primul for
			
		
		fin:
			mov esp, ebp
			pop ebp
		ret 
op_1_fB ENDP
	
	
op_2 PROC
		push ebp
		mov ebp, esp
		
		;citim multimea
		citire sir_A
		
		;facem verificare pentru dubluri si obtinem multimea
		push offset sir_A
		call op_1_fA 
		
		;cerem elementul
		push offset msg_e
		call printf
		add esp, 4
		
		push offset e
		call gets
		add esp, 4
		
		;verificam daca e apartine multimii
		push offset sir_A
		call strlen
		add esp, 4
		
		mov ecx, eax
		mov esi, 0
		mov al, e
		mov edx, 0
		
		
		lungime:
			cmp al, sir_A[esi]
			je gasit
			inc esi
		loop lungime
		
		;cmp edx, 0
		;ja negasit
		negasit:
			push offset element_negasit ;afisam mesajul de element negasit
			call printf
			add esp, 4
			
			push offset format_fisier ;deschidem fisierul
			push offset fisier
			call fopen
			add esp, 8
			
			mov esi, eax;trebuie pus in alt registru pentru ca dupa ce se fac instructiuni, valoarea lui eax se schimba
			
			push offset fisier_rezultat ;afisam mesajul de fisier
			call printf
			add esp, 4
			
			push offset element_negasit
			;push offset format_sir
			push esi ;scriem mesaj in fisier
			call fprintf
			add esp, 8
			
			push esi
			call fclose
			push 0
			
			jmp xit
			
		gasit:
			push offset element_gasit ;afisam mesajul de element gasit
			call printf
			add esp, 4
			
			push offset format_fisier ;deschidem fisierul
			push offset fisier
			call fopen
			add esp, 8
			
			mov esi, eax ;trebuie pus in alt registru pentru ca dupa ce se fac instructiuni, valoarea lui eax se schimba
			
			push offset fisier_rezultat ;afisam mesajul de fisier
			call printf
			add esp, 4
			
			push offset element_gasit
			;push offset format_sir
			push esi ;scriem mesaj in fisier
			call fprintf
			add esp, 8
			
			push esi  ;inchidem fisierul
			call fclose
			push 0
			
			
		xit:
		mov esp, ebp
		pop ebp
		ret 
op_2 ENDP

op_3 PROC
		push ebp
		mov ebp, esp
		
		;citim elementelor multimilor
		citire sir_A
		call op_1_fA 
		
		citire_b sir_B
		call op_1_fB
		
		;lungimile sirurilor
		push offset sir1
		call strlen
		add esp, 4
		
		mov card_A, eax ;salvam lungimea sirului A
		
		push offset sir2
		call strlen
		add esp, 4
		
		mov card_B, eax ;salvam lungimea sirului B in card_B
		
		
		push offset format_fisier ;deschidem fisierul
		push offset fisier
		call fopen
		add esp, 8
		
		mov of_file, eax
		
		push offset msg_diferenta
		call printf 
		add esp, 4
		
		push offset msg_diferenta
		push of_file ;scriem mesaj in fisier
		call fprintf
		add esp, 8
		
		mov ecx, card_A
		mov esi, 0 ;pornim de la indexul 0, index care va fi esi
		mov edi, 0
		for1:
			mov edx, 0 ;index pentru multimea B, care la fiecare ciclare/trecere la alt elemnt din A redevine 0
			push ecx
			mov ecx, card_B
			for2:
				;mov ecx, ebx
				mov eax, 0
				mov al, sir2[edi]
				
				cmp sir1[esi], al; comparam elementele multimilor ca sa vedem elementele necomune primei multimi
				je find ;daca sunt egale, trecem la urmatorul element
				
				mov ebx, 0
				mov bl, sir1[esi] ;luam elementul necomun celei de-a doua multime
				mov var, ebx
				
				jmp pas
				
				;push ebx
				;push offset format_diferenta
				;call printf
				;add esp, 8
				
				find: ;daca am gasit un element comun in gasit_2 pun 1
					jmp outta;ies din al doilea for daca am element comun
					mov gasit_2, 1
				
				pas:
					inc edx
					;dec eax
			loop for2
			
			outta:
				cmp gasit_2, 0
				jne finn
				
				add ok, 1
				
				push ebx
				push offset format_diferenta
				call printf
				add esp, 8
				
				mov ebx, var
				push ebx
				push offset format_diferenta
				push of_file
				call fprintf
				add esp, 12
				
			finn:
			pop ecx
			inc esi
		
		loop for1
		
		
		mov al, ok
		cmp al, 0
		jb fin
		
		diferenta_vida: ;afisam mesajele corespunzatoare unei diferente egale cu multimea vida
			push offset diferenta_nula
			call printf
			add esp, 4
			
			push offset diferenta_nula
			push of_file
			call fprintf
			add esp, 12
			
	
		fin:
		
			push offset linie_noua
			call printf
			add esp, 4
			
			push offset fisier_rezultat ;afisam mesajul de fisier
			call printf
			add esp, 4
			
			push of_file ;inchidem fisierul
			call fclose
			push 0
			
			mov esp, ebp
			pop ebp
			ret 
op_3 ENDP

op_4 PROC
		push ebp
		mov ebp, esp
		
		;citim elementelor multimilor
		citire sir_A
		call op_1_fA 
		
		citire_b sir_B
		call op_1_fB
		
		;lungimile sirurilor
		push offset sir1
		call strlen
		add esp, 4
		
		mov card_A, eax ;salvam lungimea sirului A
		mov ecx, eax

		
		push offset sir2
		call strlen
		add esp, 4
		
		mov card_B, eax ;salvam lungimea sirului B in card_b
		
		push offset format_fisier ;deschidem fisierul
		push offset fisier
		call fopen
		add esp, 8
		
		mov of_file, eax
		
		push offset produs_cartezian ;afisam pe ecran
		call printf 
		add esp, 4
		
		push offset produs_cartezian ;scriem in fisier
		push  of_file
		call fprintf
		add esp, 8
		
		mov esi, 0
		mov ecx, card_A
		for1:
			mov edi, 0
			mov edx, 0 ;index pentru multimea B, care la fiecare ciclare/trecere la alt elemnt din A redevine 0
			push ecx
			mov ecx, card_B
			for2:
				mov eax, 0
				mov al, sir2[edi]
	
				mov dl, sir1[esi]
				
				push ecx
				
				push eax
				push edx
				push offset format_produs
				call printf
				add esp, 12
				
				mov eax,0
				mov edx,0
				mov al, sir2[edi]
	
				mov dl, sir1[esi]
				push eax
				push edx
				push offset format_produs
				push  of_file
				call fprintf
				add esp, 16
				
				pop ecx
				
				
				pas:
					inc edi
			loop for2
			
			pop ecx
			inc esi
		
		loop for1
		
		push of_file ;inchidem fisierul
		call fclose
		push 0
		
		push offset fisier_rezultat ;afisam mesajul de fisier
		call printf
		add esp, 4
		
		mov esp, ebp
		pop ebp
		ret 
op_4 ENDP

start:

	; afisam meniul cu optiuni
	push offset meniu
	call printf       
	add esp, 4
	push offset optiuni
	call printf
	add esp, 4
	
	;preluam operatia de la utilizator si o stocam in op
	push offset op
	push offset format1
	call scanf
	add esp, 8
	
	;testam ca sa vedem ce operatie avem 
	cmp op, 1
	je mod_1 
	
	cmp op, 2
	je mod_2
	
	cmp op, 3
	je mod_3
	
	cmp op, 4
	je mod_4
	
	cmp op, 4
	je mod_4
	
	mod_1: 
		call op_1 ;mergem la procedura asociata operatiei 1
		jmp eexit 

	
	mod_2:
		call op_2 ;mergem la procedura asociata operatiei 2
		jmp eexit
	
	mod_3:
		call op_3 ;mergem la procedura asociata operatiei 3
		jmp eexit
			
	
	mod_4:
		call op_4 ;mergem la procedura asociata operatiei 4
		jmp eexit
		
	push offset eroare_operatie ;afisam mesaj de eroare in caz ca numarul introdus de utilizator nu este cuprins intre 1 si 4
	call printf
	add esp, 4
	 
	;apel functie exit
	eexit:
		push 0
		call exit
end start