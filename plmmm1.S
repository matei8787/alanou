.data
mat: .space 1605
cmat: .space 1605
mesaj: .space 1605
mesb: .space 1605
doi: .long 2
n: .space 4
m: .space 4
nm: .space 4
cerinta: .space 4
lfin: .space 4
lmesb: .space 4
lmesaj: .space 4
mp1: .space 4 ;// m plus 1
mp2: .space 4 ;// m plus 2
p: .space 4
k: .space 4
x: .space 4
y: .space 4
dx: .long -1, -1, 0, 1, 1, 1, 0, -1
dy: .long 0, 1, 1, 1, 0, -1, -1, -1
sCitire: .asciz "%ld%ld%ld"
sCitireCelula: .asciz "%ld%ld"
sCitireK: .asciz "%ld"
sAfisElem: .asciz "%ld"
sCitireSir: .asciz "%s"
sHexa: .asciz "0x"
endl: .asciz "\n"
.text
alocare_mat:
    push %ebp
    mov %esp, %ebp

    mov $20, %ecx
    xor %eax, %eax
    mov 8(%ebp), %edi

et_loop_linie:
    cmp %ecx, %eax
    jge et_ret
    mov $0, %ebx

et_loop_coloane:
    cmp %ecx, %ebx
    jge et_inc_i
    push %eax
    mov $0, %edx
    ;// %eax = %eax * n + %ebx
    mull %ecx
    ;// %eax = %eax * n
    add %ebx, %eax
    movl $0, (%edi, %eax, 4)
    pop %eax
    add $1, %ebx
    jmp et_loop_coloane

et_inc_i:
    add $1, %eax
    jmp et_loop_linie

et_ret:
    pop %ebp
    ret


citiresys:
    pushl $p
    pushl $m
    pushl $n
    pushl $sCitire
    call scanf
    pop %eax
    pop %eax
    pop %eax
    pop %eax

    movl m, %eax
    add $1, %eax
    movl %eax, mp1
    add $1, %eax
    movl %eax, mp2
   
    lea mat, %edi
    xor %ecx, %ecx
et_loop:
    cmp p, %ecx
    jge et_dupa

et_prev_scan:
    push %ecx
    pushl $y
    pushl $x
    pushl $sCitireCelula
    call scanf
    pop %eax
    pop %eax
    pop %eax
et_dupa_scan:
    pop %ecx
et_dupa_pop:

    mov x, %eax
    add $1, %eax
    mull mp2
    addl y, %eax
    add $1, %eax
    movl $1, (%edi, %eax, 4)

    add $1, %ecx
    jmp et_loop


et_dupa:
    pushl $k
    pushl $sCitireK
    call scanf
    pop %eax
    pop %eax

    pushl $cerinta
    pushl $sCitireK
    call scanf
    pop %eax
    pop %eax

    pushl $mesaj
    pushl $sCitireSir
    call scanf
    pop %eax
    pop %eax

    ret


afisare_mat:
    push %ebp
    mov %esp, %ebp

    mov $1, %eax
    mov 8(%ebp), %edi
    mov n, %ecx
    mov m, %edx

et_loop_liniea:
    cmp n, %eax
    jg et_reta
    mov $1, %ebx

et_loop_coloanea:
    cmp m, %ebx
    jg et_inc_ia

    push %eax
    push %edx

    mov $0, %edx
    ;// %eax = %eax * (m + 1) + %ebx
    mull mp2
    ;// %eax = %eax * m
    add %ebx, %eax

    mov (%edi, %eax, 4), %edx
    pushl %edx
    pushl $sAfisElem
    call printf
    popl %edx
    popl %edx

    pushl $0
    call fflush
    popl %edx


    pop %edx
    pop %eax
    add $1, %ebx
    jmp et_loop_coloanea

et_inc_ia:

    push %eax
    push $endl
    call printf
    popl %eax

    pop %eax
    add $1, %eax
    jmp et_loop_liniea

et_reta:
    pop %ebp
    ret

copoazam1m2:  ;//din m1 in m2
    push %ebp
    mov %esp, %ebp

    ;//%eax = i, %ebx = j, %ecx = m1, %edi = m2
    mov 8(%ebp), %ecx
    mov 12(%ebp), %edi
    mov $0, %eax

et_start_loop_i:
    cmp n, %eax
    jg et_retu
    mov $1, %ebx

et_start_loop_j:
    cmp m, %ebx
    jg et_fin_loop_i
    push %eax
    push %ebx
    ;// nr = (i + 1) * m + j = (%eax + 1) * m + %ebx
    xor %edx, %edx
    mull mp2
    add %ebx, %eax
    mov (%ecx, %eax, 4), %ebx
    mov %ebx, (%edi, %eax, 4)


et_fin_loop_j:
    pop %ebx
    pop %eax
    add $1, %ebx
    jmp et_start_loop_j


et_fin_loop_i:
    add $1, %eax
    jmp et_start_loop_i

et_retu:
    pop %ebp
    ret

da_pozxy: ;//%eax = adresa lui mat[x][y]

    push %ebp
    mov %esp, %ebp

    mov  8(%ebp), %eax
    mov 12(%ebp), %ebx
luatxy:
    ;// %eax = ( %eax + 1 ) * n + %ebx
    xor %edx, %edx
    mull mp2
    add %ebx, %eax

et_ret_poz:
    pop %ebp
    ret


genereaza_pas:
    ;// eax = i, ebx = j


    mov $1, %eax

et_start_i:
    cmp n, %eax
    jg et_retgen
    mov $1, %ebx

et_start_j:
    cmp m, %ebx
    jg et_stop_i

    push %eax
    push %ebx
    xor %edx, %edx
    mull mp2
    add %ebx, %eax
    lea cmat, %edi
    lea mat, %esi
    mov (%edi, %eax, 4), %ebx
et_pre_moare:
    cmp $2, %ebx
    jge nu_subpop

et_moare:
    xor %ebx, %ebx
    mov %ebx, (%esi, %eax, 4)
    push %eax
et_eax:
    mov (%esi, %eax, 4), %eax
    pop %eax
    jmp et_stop_j


nu_subpop:
    cmp $3, %ebx
    jg nu_continua
    jmp decide_soarta

decide_soarta:
    cmp $3, %ebx
    jne et_stop_j

egal3:
    mov (%esi, %eax, 4), %edx
    cmp $1, %edx
    je et_stop_j
    mov $1, %edx
    mov %edx, (%esi, %eax, 4)
    jmp et_stop_j

nu_continua:
    xor %edx, %edx
    mov %edx, (%esi, %eax, 4)
    jmp et_stop_j

et_stop_j:
    pop %ebx
    pop %eax
    add $1, %ebx
    jmp et_start_j

et_stop_i:
    add $1, %eax
    jmp et_start_i

et_retgen:
    ret

determina_nrvec_xy:
    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %eax
    mov 12(%ebp), %ebx
    lea mat, %edi
    xor %edx, %edx
    mull mp2
    add %ebx, %eax
    ;// aici eax este cat trebuie sa adaug
et_cat_sa_adaug:
    xor %ecx, %ecx
    push %esi
    xor %esi, %esi

et_for_dir:
    cmp $8, %ecx
    jge et_bf_ret_det
et_dupa_jmp:
    push %eax
    push %ebx
    push %ecx
    push %edx
    push %ebp
    mov %eax, %ebx
    lea dx, %ebp
    mov (%ebp, %ecx, 4), %eax
    xor %edx, %edx
    imull mp2
    lea dy, %ebp
    add (%ebp, %ecx, 4), %eax
et_dupa_calcule:
    add %eax, %ebx
    mov %ebx, %eax
    mov (%edi, %eax, 4), %ebx
    cmp $1, %ebx
    jne et_stop_for_dir
    add $1, %esi

et_stop_for_dir:
    pop %ebp
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    add $1, %ecx
    jmp et_for_dir    

et_bf_ret_det:
    mov %esi, %eax
    pop %esi


et_ret_det:
    pop %ebp
    ret

simuleaza_unpas:

    pushl $cmat
    call alocare_mat
    popl %eax
    
    mov $1, %eax

et_for_i:
    cmp n, %eax
    jg et_ret_sim

    mov $1, %ebx
et_for_j:
    cmp m, %ebx
    jg et_fin_for_i
    push %eax
    push %ebx
    push %ebx
    push %eax
    call determina_nrvec_xy
    pop %ebx
    pop %ebx
    mov %eax, %ecx
    pop %ebx
    pop %eax

dupa_dete:
    push %eax
    push %ebx
    push %ecx

    push %ebx
    push %eax
    call da_pozxy
    pop %ebx
    pop %ebx

    pop %ecx
    pop %ebx
    
copiere:
    lea cmat, %edi
    mov %ecx, (%edi, %eax, 4)

et_inc_j:
    pop %eax
    add $1, %ebx
    jmp et_for_j

et_fin_for_i:
    add $1, %eax
    jmp et_for_i

et_ret_sim:
    call genereaza_pas
    ret


simuleaza:

    mov $1, %eax
et_final_loop:
    cmp k, %eax
    jg et_final_simulare
    push %eax
    call simuleaza_unpas
    pop %eax
    add $1, %eax
    jmp et_final_loop

et_final_simulare:
    ret
    
afisare_vec: ;// sz, v[sz]

    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %eax
    mov 12(%ebp), %edi

    xor %ecx, %ecx

et_start_for_afv:
    cmp %eax, %ecx
    jge et_ret_afv

    push %eax
    push %ecx

    mov (%edi, %ecx, 4), %eax
    pushl %eax
    pushl $sAfisElem
    call printf
    pop %eax
    pop %eax

    pushl $0
    call fflush
    pop %eax

    pop %ecx
    pop %eax
    add $1, %ecx
    jmp et_start_for_afv


et_ret_afv:
    pop %ebp
    ret

punecar: ;//poz, car

    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %eax
    mov 12(%ebp), %ebx
dupa_luat:
    mov %eax, %ecx
    add $7, %ecx
    lea mesb, %edi

et_start_for_puncar:
    cmp %eax, %ecx
    jl et_stop_puncar

inainte_calcule_puncar:

    push %eax

    mov %ebx, %eax

    xor %edx, %edx
    divl doi
    movl %edx, (%edi, %ecx, 4)
    mov %eax, %ebx

    pop %eax
dupa_calcule_puncar:

    sub $1, %ecx
    jmp et_start_for_puncar


et_stop_puncar:
    pop %ebp
    ret

mesajbit:

    xor %eax, %eax ;//poz mesaj
    xor %ecx, %ecx ;//poz mesajbit

et_for_mbit:
    cmp lmesaj, %eax
    jge et_ret_mesajbit

    lea mesaj, %edi
    pushl %eax
    pushl %ecx

et_inainte_car:

    xor %ebx, %ebx
    movb (%edi, %eax, 1), %bl

et_dupa_car:
    push %ebx
    push %ecx
    call punecar
    pop %ecx
    pop %ebx

    pop %ecx
    pop %eax

    add $1, %eax
    add $8, %ecx
    jmp et_for_mbit


et_ret_mesajbit:
    ret


prelungeste: ;// v[], from, to

    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %edi
    mov 12(%ebp), %eax
    mov 16(%ebp), %ebx
    xor %ecx, %ecx

et_start_forp:
    cmp %ebx, %eax
    jge et_stop_prel

    mov (%edi, %ecx, 4), %edx
    mov %edx, (%edi, %eax, 4)

    add $1, %eax
    add $1, %ecx
    jmp et_start_forp

et_stop_prel:
    pop %ebp
    ret

pregateste_datele:

    mov nm, %eax
    cmp %eax, lmesb
    jl caz_cheie_mare

caz_mesaj_mare:
    pushl lmesb
    pushl nm
    pushl $mat
    call prelungeste
    pop %eax
    pop %eax
    pop %eax
inainte_gasit:
    mov lmesb, %eax
    mov %eax, lfin
    jmp gata_pregatite

caz_cheie_mare:
    pushl nm
    pushl lmesb
    pushl $mesb
    call prelungeste
    pop %eax
    pop %eax
    pop %eax
    mov nm, %eax
    mov %eax, lfin

gata_pregatite:
    ret

xoreaza:

    xor %eax, %eax

et_start_for_xor:
    cmp lfin, %eax
    jge stop_xor
    
iau_cheie:
    lea mat, %edi
    mov (%edi, %eax, 4), %ebx
iau_mesaj:
    lea mesb, %edi
    mov (%edi, %eax, 4), %ecx
    xor %ebx, %ecx
gata_xor:
    lea cmat, %edi
    mov %ecx, (%edi, %eax, 4)
am_pus:

    add $1, %eax
    jmp et_start_for_xor

stop_xor:
    ret

da_numar: ;//poz
    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %ebx
    add $3, %ebx

    xor %eax, %eax
    xor %edx, %edx
    xor %ecx, %ecx
    lea cmat, %edi

    mov (%edi, %ebx, 4), %eax
    sub $1, %ebx
    add %eax, %ecx

    mov (%edi, %ebx, 4), %eax
    mull doi
    sub $1, %ebx
    add %eax, %ecx

    mov (%edi, %ebx, 4), %eax
    mull doi
    mull doi
    sub $1, %ebx
    add %eax, %ecx

    mov (%edi, %ebx, 4), %eax
    mull doi
    mull doi
    mull doi
    sub $1, %ebx
    add %eax, %ecx

    mov %ecx, %eax

    pop %ebp
    ret

b10_16: ;//nr
    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %eax

    cmp $10, %eax
    jge nu_cif

    add $48, %eax
    jmp gata_b16

nu_cif:
    sub $10, %eax
    add $65, %eax

gata_b16:
    pop %ebp
    ret

afis_cript:

    pushl $sHexa
    call printf
    pop %ecx

    xor %ecx, %ecx


et_for_afis_cript:
    cmp lfin, %ecx
    jge gata_cript

    pushl %ecx

start_for:

    pushl %ecx
    call da_numar
    pop %ecx

am_b10:

    pushl %eax
    call b10_16
    pop %ecx

am_car:

    pushl %eax
    call putchar
    pop %eax


gata_car:

    pop %ecx

restituit:
    
    add $4, %ecx
    jmp et_for_afis_cript

gata_cript:
    pushl $0
    call fflush
    pop %eax
    ret



pune_nr: ;//poz, nr
    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %eax
    mov 12(%ebp), %ebx





.global main
main:
citire:
    pushl $mat
    call alocare_mat
    popl %eax
    call citiresys

    mov n, %eax
    add $2, %eax
    xor %edx, %edx
    mull mp2
    mov %eax, nm


    pushl $mesaj
    call strlen
    pop %ecx
    mov %eax, lmesaj


    mull doi
    mull doi
    mull doi
    mov %eax, lmesb


rez:
    
    call simuleaza
    mov cerinta, %eax
    cmp $1, %eax
    je decripteaza

cripteaza:
    call mesajbit
    call pregateste_datele
    call xoreaza

    call afis_cript
    jmp et_exit

decripteaza:




afisare:



et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80