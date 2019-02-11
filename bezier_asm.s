global drawBezier

section .text

drawBezier:
	  push rbp
	  mov rbp, rsp

	  mov QWORD [rbp-40], rdi	; mouseX
	  mov QWORD [rbp-48], rsi	; mouseY
	  mov QWORD [rbp-56], rdx	; pixels

	  pxor xmm0, xmm0
	  movss DWORD [rbp-8], xmm0	; bX 
	  movss DWORD [rbp-12], xmm0 ; bY 
	  movss DWORD [rbp-16], xmm0 ; tmp 
	  movss DWORD [rbp-4], xmm0 ; t 

	  mov eax, 1					; wrzucam do eax = 1
	  cvtsi2ss xmm6, eax			; konwertuje 1 w xmm6 na floata		; xmm6=1

	  mov ebx, 500
	  movss xmm7, xmm6				; 1 do xmm7
	  cvtsi2ss xmm2, ebx			; to co w ebx na floata i do xmm2
	  divss xmm7, xmm2				; w xmm7 wartosc o ile podnosze t

.loop:
	  ;ucomiss xmm6, DWORD [rbp-4]	; sprawdzanie czy t<1
	  ;jb .finish					; jesli t > 1 to koncze

	  pxor xmm0, xmm0
	  movss DWORD [rbp-12], xmm0	; zerowanie bY
	  movss DWORD [rbp-8], xmm0		; zerowanie bX

	  movss xmm0, DWORD [rbp-4]		; pobranie do xmm0 t

	  movss xmm5, xmm6
	  subss xmm5, xmm0				; przypisanie do xmm5 = (1-t)

	  mulss xmm0, DWORD [rbp-4]		; t*t
	  mulss xmm0, DWORD [rbp-4]		; t*t*t
	  mulss xmm0, DWORD [rbp-4]		; t*t*t*t
	  movss DWORD [rbp-16], xmm0	; odlozenie t^4 do tmp
	  mov rax, QWORD [rbp-40]		
	  mov eax, DWORD [rax]			; mouseX[0] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseX[0] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseX[0] * t^4
	  movss xmm1, DWORD [rbp-8]		; xmm1 = bX
	  addss xmm0, xmm1				; xmm0 = xmm0 + bX
	  movss DWORD [rbp-8], xmm0		; odkladam zaktualizowane bX
	  mov rax, QWORD [rbp-48]
	  mov eax, DWORD [rax]			; mouseY[0] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseY[0] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseY[0] * t^4(tmp)
	  movss xmm1, DWORD [rbp-12]	; xmm1 = bY
	  addss xmm0, xmm1				; xmm0 = xmm0 + bY
	  movss DWORD [rbp-12], xmm0	; odkladam zaktualizowane bY

	  movss xmm0, DWORD [rbp-4]		; xmm0 = t
	  mulss xmm0, DWORD [rbp-4]		; t*t
	  mulss xmm0, DWORD [rbp-4]		; t*t*t
	  mulss xmm0, xmm5				; xmm0 = t*t*t*(1-t)
	  mov eax, 4
	  cvtsi2ss xmm1, eax
	  mulss xmm0, xmm1				; xmm0 = 4*t^3*(1-t)
	  movss DWORD [rbp-16], xmm0	; odlozenie 4*t^3*(1-t) do tmp
	  
	  mov rax, QWORD [rbp-40]
	  add rax, 4					; mouseX[1]
	  mov eax, DWORD [rax]			; mouseX[1] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseX[1] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseX[1] * 4*t^3*(1-t)(tmp)
	  movss xmm1, DWORD [rbp-8]		; xmm1 = bX
	  addss xmm0, xmm1				; xmm0 = xmm0 + bX
	  movss DWORD [rbp-8], xmm0		; odkladam zaktualizowane bX
	  mov rax, QWORD [rbp-48]
	  add rax, 4					; mouseY[1]
	  mov eax, DWORD [rax]			; mouseY[1] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseY[1] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseY[1] * 4*t^3*(1-t)(tmp)
	  movss xmm1, DWORD [rbp-12]	; xmm1 = bY
	  addss xmm0, xmm1				; xmm0 = xmm0 + bY
	  movss DWORD [rbp-12], xmm0	; odkladam zaktualizowane bY

	  movss xmm0, DWORD [rbp-4]		; xmm0 = t
	  mulss xmm0, DWORD [rbp-4]		; t*t
	  mulss xmm0, xmm5				; t*t*(1-t)
	  mulss xmm0, xmm5				; t*t*(1-t)*(1-t)
	  mov eax, 6
	  cvtsi2ss xmm1, eax
	  mulss xmm0, xmm1				; 6*t^2*(1-t)^2
	  movss DWORD [rbp-16], xmm0	; odkladam 6*t^2*(1-t)^2 do tmp

	  mov rax, QWORD [rbp-40]
	  add rax, 8					; mouseX[2]
	  mov eax, DWORD [rax]			; mouseX[2] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseX[2] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseX[2] * 6*t^2*(1-t)^2(tmp)
	  movss xmm1, DWORD [rbp-8]		; xmm1 = bX
	  addss xmm0, xmm1				; xmm0 = xmm0 + bX
	  movss DWORD [rbp-8], xmm0		; odkladam zaktualizowane bX
	  mov rax, QWORD [rbp-48]
	  add rax, 8					; mouseY[2]
	  mov eax, DWORD [rax]			; mouseY[2] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseY[2] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseY[2] * 6*t^2*(1-t)^2(tmp)
	  movss xmm1, DWORD [rbp-12]	; xmm1 = bY
	  addss xmm0, xmm1				; xmm0 = xmm0 + bY
	  movss DWORD [rbp-12], xmm0	; odkladam zaktualizowane bY

	  movss xmm0, DWORD [rbp-4]		; xmm0 = t
	  mulss xmm0, xmm5				; t*(1-t)
	  mulss xmm0, xmm5				; t*(1-t)*(1-t)
	  mulss xmm0, xmm5				; t*(1-t)*(1-t)*(1-t)
	  mov eax, 4
	  cvtsi2ss xmm1, eax
	  mulss xmm0, xmm1				; 4*t*(1-t)*(1-t)*(1-t)
	  movss DWORD [rbp-16], xmm0	; odkladam 4*t*(1-t)^3 do tmp

	  mov rax, QWORD [rbp-40]
	  add rax, 12					; mouseX[3]
	  mov eax, DWORD [rax]			; mouseX[3] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseX[3] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseX[3] * 4*t*(1-t)^3(tmp)
	  movss xmm1, DWORD [rbp-8]		; xmm1 = bX
	  addss xmm0, xmm1				; xmm0 = xmm0 + bX
	  movss DWORD [rbp-8], xmm0		; odkladam zaktualizowane bX
	  mov rax, QWORD [rbp-48]
	  add rax, 12					; mouseY[3]
	  mov eax, DWORD [rax]			; mouseY[3] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseY[3] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseY[3] * 4*t*(1-t)^3(tmp)
	  movss xmm1, DWORD [rbp-12]	; xmm1 = bY
	  addss xmm0, xmm1				; xmm0 = xmm0 + bY
	  movss DWORD [rbp-12], xmm0	; odkladam zaktualizowane bY

	  movss xmm0, xmm5				; xmm0 = (1-t)
	  mulss xmm0, xmm5				; (1-t)^2
	  mulss xmm0, xmm5				; (1-t)^3
	  mulss xmm0, xmm5				; (1-t)^4
	  movss DWORD [rbp-16], xmm0	; odkladam (1-t)^4 do tmp

	  mov rax, QWORD [rbp-40]	
	  add rax, 16					; mouseX[4]
	  mov eax, DWORD [rax]			; mouseX[4] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseX[4] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseX[4] * (1-t)^4(tmp)
	  movss xmm1, DWORD [rbp-8]		; xmm1 = bX
	  addss xmm0, xmm1				; xmm0 = xmm0 + bX
	  movss DWORD [rbp-8], xmm0		; odkladam zaktualizowane bX
	  mov rax, QWORD [rbp-48]
	  add rax, 16					; mouseY[4]
	  mov eax, DWORD [rax]			; mouseY[4] do eax
	  cvtsi2ss xmm0, eax			; konwertuje mouseY[4] na floata i do xmm0
	  mulss xmm0, DWORD [rbp-16]	; xmm0 = mouseY[4] * (1-t)^4(tmp)
	  movss xmm1, DWORD [rbp-12]	; xmm1 = bY
	  addss xmm0, xmm1				; xmm0 = xmm0 + bY
	  movss DWORD [rbp-12], xmm0	; odkladam zaktualizowane bY

	  movss xmm0, DWORD [rbp-12]	; xmm0 = bY
	  cvttss2si eax, xmm0			; konwetuje bY do inta i daje do eax
	  mov DWORD [rbp-20], eax		; odkladam y

	  movss xmm0, DWORD [rbp-8]		; xmm0 = bX
	  cvttss2si eax, xmm0			; konwetuje bX do inta i daje do eax
	  mov DWORD [rbp-24], eax		; odkladam x

	  mov edx, DWORD [rbp-20]		; edx = y
	  mov eax, edx					; eax = y
	  sal eax, 2					; eax = 4y	
	  add eax, edx					; eax = 4y + y
	  sal eax, 7					; eax = 5y *128 = 640y
	  mov edx, eax					; edx = 640y
	  mov eax, DWORD [rbp-24]		; eax = x
	  add eax, edx					; eax = 640y +x
	  cdqe
	  lea rdx, [0+rax*4]
	  mov rax, QWORD [rbp-56]
	  add rax, rdx
	  mov DWORD [rax], 0

	  movss xmm0, DWORD [rbp-4]		; t do xmm0 
	  addss xmm0, xmm7				; dodanie do t wartosci	z rejestru xmm7, czyli co ile skacze t
	  movss DWORD [rbp-4], xmm0 	; odlozenie t
	  
	  ;jmp .loop
	  ucomiss xmm6, DWORD [rbp-4]	; sprawdzanie czy t<1
	  ja .loop						; jesli t < 1 to petla

.finish:
	  pop rbp
	  ret
