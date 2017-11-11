data segment
    CACA_PALAVRAS   DB  "ASDFKASJFLOASJCFLKJASKRUMEUCULFJKLSAJKDSVMNMSDPFKVLSADFDSARO"
                    DB  "KSAOJFLKASKFLKUSAJSDKFJSADKFJKSADJFLKSAJFKLJSALKFJLKASJCFKAA",0

    msgDigitePalavra db "Digite a palavra a ser procurada:",13,10,"$"
    msgExtouroVar db "Voce atingiu o tamanho maximo da palavra!"
    msgPalavraNaoEncontrada db "Nao foi possivel encontrar a palavra.",13,10,"Tente outra:",13,10,"$"

    quebraLinha DB 13,10,"$"
    linhaEmBranco DB 13,10,13,10,"$"

    palavraAtual DB "                    $";
    comparaPalavraEncontrouInicio DB 00h,0Ch,00h,00h ;00 - Coluna 00 - linha;
    comparaPalavraEncontrouFim    DB 00h,10h,00h,00h ;00 - Coluna 00 - linha;

    dsColuna DB "coluna $"
    dsLinha DB " linha $"
    dsInicio DB "Inicio em $"
    dsFim DB "Fim em $"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    lea si,CACA_PALAVRAS    ;si vai de 0 a 59
    mov di,0             ;di vai de 0 a 1140. exemplo: 0,60,120,180,240,300,360,...
    ;ADD YOUR CODE HERE




    ;jmp   fimPrograma

CicloPricipal:   
    call printaCacaPalavra
    call lerPalavra
    call buscaPalavraTodasDirecoes
    jmp CicloPricipal


                                                   
;-----------------------------------------------  
printaCacaPalavra:
    mov bx, 0                    
    mov si, 0
    printaCacaPalavraLoop:
        mov al,CACA_PALAVRAS[bx + si]
        cmp al, '$'
        je printaCacaPalavraFim
        cmp al, 0
        je printaCacaPalavraFim
        MOV DL, Al
        MOV AH, 2
        INT 21H
        inc bx
        cmp bx,60
        jne printaCacaPalavraLoop
            mov bx, 0
            add si, 60          
            
            lea dx, quebraLinha
            mov ah, 9
            int 21h
            jmp printaCacaPalavraLoop
        
        
        jmp printaCacaPalavra
    
    printaCacaPalavraFim:
        ret

;-----------------------------------------------
buscaPalavraTodasDirecoes:

    call buscaPalavraHorizontal
    mov al, comparaPalavraEncontrouFim[3]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    mov al, comparaPalavraEncontrouFim[1]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    call buscaPalavraVertical
    mov al, comparaPalavraEncontrouFim[3]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    mov al, comparaPalavraEncontrouFim[1]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    call buscaPalavraHorizontalOposto
    mov al, comparaPalavraEncontrouFim[3]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    mov al, comparaPalavraEncontrouFim[1]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    call buscaPalavraVerticalOposto
    mov al, comparaPalavraEncontrouFim[3]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    mov al, comparaPalavraEncontrouFim[1]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    call buscaPalavraDiagonalSupDirParaInfEsq
    mov al, comparaPalavraEncontrouFim[3]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    mov al, comparaPalavraEncontrouFim[1]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    call buscaPalavraDiagonalSupEsqParaInfDir
    mov al, comparaPalavraEncontrouFim[3]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    mov al, comparaPalavraEncontrouFim[1]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    call buscaPalavraDiagonalInfDirParaSupEsq
    mov al, comparaPalavraEncontrouFim[3]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    mov al, comparaPalavraEncontrouFim[1]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    call buscaPalavraDiagonalInfEsqParaSupDir
    mov al, comparaPalavraEncontrouFim[3]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    mov al, comparaPalavraEncontrouFim[1]
    cmp al, 00
    jne buscaPalavraTodasDirecoesAchou
    jmp buscaPalavraTodasDirecoesNaoAchou

    buscaPalavraTodasDirecoesAchou:
        call imprimeResultado
        jmp buscaPalavraTodasDirecoesFim
    buscaPalavraTodasDirecoesNaoAchou:
        lea dx, msgPalavraNaoEncontrada
        mov ah, 9
        int 21h
        jmp buscaPalavraTodasDirecoesFim  
    buscaPalavraTodasDirecoesFim:
        ret    


;-----------------------------------------------
imprimeResultado:
    mov bh, comparaPalavraEncontrouInicio[0]
    mov bl, comparaPalavraEncontrouInicio[1]
    mov ah, comparaPalavraEncontrouInicio[2]
    mov al, comparaPalavraEncontrouInicio[3]


    mov dh, comparaPalavraEncontrouFim[0]
    mov dl, comparaPalavraEncontrouFim[1]
    mov ch, comparaPalavraEncontrouFim[2]
    mov cl, comparaPalavraEncontrouFim[3]

    ;ax - linha inicio * 60
    ;bx - coluna inicio
    ;cx - linha fim * 60
    ;dx - coluna fim

    push dx
        push cx
            mov dx, 0
            mov cx, 60
            div cx
        pop cx
        push ax
            mov dx, 0
            mov ax, cx
            mov cx, 60
            div cx
            mov cx, ax
        pop ax
    pop dx

    ;ax - linha inicio em hex  [0..19]
    ;bx - coluna inicio em hex [0..59]
    ;cx - linha fim em hex     [0..19]
    ;dx - coluna fim em hex    [0..59]

    pusha
        lea dx, dsInicio
        mov ah, 09
        int 21h
        lea dx, dsColuna
        mov ah, 09
        int 21h
        mov ax, bx
        call imprimeAlNum
        lea dx, dsLinha
        mov ah, 09
        int 21h
    popa
    pusha                
        call imprimeAlNum
        lea dx, quebraLinha
        mov ah, 09
        int 21h
        lea dx, dsFim
        mov ah, 09
        int 21h
        lea dx, dsColuna
        mov ah, 09
        int 21h
    popa
    pusha
        mov ax, dx
        call imprimeAlNum
        lea dx, dsLinha
        mov ah, 09
        int 21h
    popa
    mov ax, cx        
    call imprimeAlNum
    lea dx, linhaEmBranco    
    mov ah, 09
    int 21h


    imprimeResultadoFim:
        ret

;-----------------------------------------------
imprimeAl:
   cmp Al, 19H; 19H = 00011001 = 25
   jg imprimeAlMaiorQue25
   call imprimeAlMenorQue26
   jmp imprimeAlFim

   imprimeAlMenorQue26:
       add Al, "A"
       MOV DL, Al
       MOV AH, 2
       INT 21H
       ret

   imprimeAlMaiorQue25:
       push dx
           push cx
               push bx
                   mov dx,0 ; clear dividend, high
                   mov ah,0
                   mov cx,26
                   div cx ; AX = divisao, DX = resto
                   dec al
                   mov bx, dx
                   call imprimeAl
                   mov ax, bx
                   call imprimeAl
               pop bx
           pop cx
       pop dx


   imprimeAlFim:
        ret

;-----------------------------------------------
imprimeAlNum:
   cmp Al, 09h; 09H = 00001001 = 9
   jg imprimeAlNumMaiorQue9
   call imprimeAlNumMenorQue10
   jmp imprimeAlNumFim

   imprimeAlNumMenorQue10:
       add Al, "0"
       MOV DL, Al
       MOV AH, 2
       INT 21H
       ret

   imprimeAlNumMaiorQue9:
       push dx
           push cx
               push bx
                   mov dx,0 ; clear dividend, high
                   mov ah,0
                   mov cx,10
                   div cx ; AX = divisao, DX = resto
                   mov bx, dx
                   call imprimeAlNum
                   mov ax, bx
                   call imprimeAlNum
               pop bx
           pop cx
       pop dx


   imprimeAlNumFim:
        ret

;-----------------------------------------------
buscaPalavraDiagonalSupDirParaInfEsq:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraDiagonalSupEsqParaInfDir:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraDiagonalInfDirParaSupEsq:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraDiagonalInfEsqParaSupDir:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraVerticalOposto:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraHorizontalOposto:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraVertical:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraHorizontal:
    ;reseta registradores usados
        mov cx, 0; indice da coluna da 'palavraAtual'
        mov dx, 0; indice da coluna do 'CACA_PALAVRAS' reset
        mov bx, 0; indice da coluna do 'CACA_PALAVRAS'
        mov di, 0; indice da linha do 'CACA_PALAVRAS'    
    
    ;reseta variaveis de controle
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h    


    buscaPalavraHorizontalComp:
        mov si, cx
        cmp palavraAtual[si], "$";verifica se e o fim da palavra pela qual se esta procurando.
        je buscaPalavraHorizontalAchou;move o fluxo para o rotulo que trata encontrar a palavra.
        mov si, di                         
        cmp CACA_PALAVRAS[bx + si], "$";verifica se e o fim da tabela em que se esta procurando
        je buscaPalavraHorizontalNaoAchou;move o fluxo para o rotulo que trata nao encontrar a palavra
        cmp CACA_PALAVRAS[bx + si], 0;verifica se e o fim da tabela em que se esta procurando
        je buscaPalavraHorizontalNaoAchou;move o fluxo para o rotulo que trata nao encontrar a palavra
        mov al, CACA_PALAVRAS[bx + si]
        mov si, cx
        cmp al, palavraAtual[si];compara as letras nos indices atuais nas duas variaveis
        je buscaPalavraHorizontalCompCaracterIgual;move fluxo para  desencontro de letras (palavras nao sao iguais)
        
        cmp al, 'a'
        js buscaPalavraHorizontalCompUpperCaseFim
        cmp al, 'z'  
        jg buscaPalavraHorizontalCompUpperCaseFim   
        sub al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraHorizontalCompCaracterIgual     
        buscaPalavraHorizontalCompUpperCaseFim: 
        
        cmp al, 'A'
        js buscaPalavraHorizontalCompLowerCaseFim
        cmp al, 'Z'  
        jg buscaPalavraHorizontalCompLowerCaseFim   
        add al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraHorizontalCompCaracterIgual     
        buscaPalavraHorizontalCompLowerCaseFim:
        
        jmp buscaPalavraHorizontalCompCaracterDif         
        
        buscaPalavraHorizontalCompCaracterIgual:
        
            inc cx;avanca os indices, para continuar comparacao
            inc bx;avanca os indices, para continuar comparacao
            cmp bx, 60;verifica se o indice da linha do 'CACA_PALAVRAS' e 60
            je  buscaPalavraHorizontalEstouro;trata nova linha;
            jmp buscaPalavraHorizontalComp;retorna para comparar proximos caracteres

    buscaPalavraHorizontalEstouro:
        mov dx, 59;emula valor 59 em dx, para reaproveitar funcionamento do tratamento de caracteres diferentes
        jmp buscaPalavraHorizontalCompCaracterDif

    buscaPalavraHorizontalCompCaracterDif:
        mov cx, 0; reseta indices
        inc dx
        cmp dx, 60
        jne buscaPalavraHorizontaLinhaOk; 
        mov dx, 0
        add di, 60                        ;trata o estouro da linha
        jmp buscaPalavraHorizontaLinhaOk

        buscaPalavraHorizontaLinhaOk:               
            ;grava o caracter de inicio como sendo a posicao atual
            mov bx, dx
            mov comparaPalavraEncontrouInicio[0], bh ;grava coluna
            mov comparaPalavraEncontrouInicio[1], bl
            mov ax, di
            mov comparaPalavraEncontrouInicio[2], ah;grava linha
            mov comparaPalavraEncontrouInicio[3], al
            jmp buscaPalavraHorizontalComp


    buscaPalavraHorizontalNaoAchou:    
        ;reseta variaveis de inicio e fim.
        mov comparaPalavraEncontrouFim[0], 0h
        mov comparaPalavraEncontrouFim[1], 0h    
        mov comparaPalavraEncontrouFim[2], 0h    
        mov comparaPalavraEncontrouFim[3], 0h    
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h
        jmp fimBuscaPalavraHorizontal
    buscaPalavraHorizontalAchou:   
        ;grava a posiacao fim.
        mov comparaPalavraEncontrouFim[0], bh
        mov comparaPalavraEncontrouFim[1], bl
        mov ax, di
        mov comparaPalavraEncontrouFim[2], ah
        mov comparaPalavraEncontrouFim[3], al
        
        buscaPalavraHorizontalAchouTrataCase:                
            dec bx
            dec cx     
            call trataCase   
            cmp cx, 0
            jne buscaPalavraHorizontalAchouTrataCase
        
        jmp fimBuscaPalavraHorizontal
    fimBuscaPalavraHorizontal:
        ret                                      

;-----------------------------------------------   
trataCase:
    pusha
        mov si, di  
        mov al, CACA_PALAVRAS[bx + si]
        cmp al, 'A'
        jl trataCaseFim: 
        cmp al, 'Z'
        jg trataCaseFim: 
        add al, 20h; diferenca entre 'A' e 'a'
        mov CACA_PALAVRAS[bx + si],al
    trataCaseFim:
        popa   
        ret

;-----------------------------------------------
;Ler palavra pega o input do usuario em letras (ate 20 letras) colocando-as dentro da variavel  'palavraAtual'
;Se forem inseridas 20 letras, retorna
;Se for inserido enter ou esc, retorna
lerPalavra:
    mov si, 0000h; inicia si em 0, para percorrer 'palavraAtual', comecando no primeiro caracter
    lea dx, msgDigitePalavra; insere posicao da mensagem 'msgDigitePalavra', nodx
    mov ah, 9; joga 9 para ah, preparando para imprimir mensagem
    int 21h; chama a interupcao 33 (21h)

    lerLetra:
        mov ah, 8; joga 8 para ah, preparando para receber letra
        int 21h ; chama a interupcao 33 (21h)
        cmp al, 27; compara o valor inserido pelo usuario com a tecla ESC
        je fimPrograma; Finaliza programa
        cmp al, 13; Compara o valor inserido pelo usuario com a tecla ENTER
        je fimLerPalavra; Finaliza leitura
        mov palavraAtual[si], al; Insere o valor informado pelo usuario em 'palavraAtual', indexado por si (que comeca zerdo)
        inc si; incrementa si, para apontar para a proxima casa de 'palavraAtual'
        MOV DL, al; move o valor inserido pelo usuario para dl, para imprimi-lo
        MOV AH, 2; joga 2 para ah, preparando para imprimir letra
        INT 21H; chama a interupcao 33 (21h)
        cmp si, 14H; compara si com 20(14h) para verificar se foram digitadas 20 letras
        je estouroVar; joga o fluxo para o fim da execuacao por estrouro de variavel
        jmp lerLetra; retorna para o inicio do processo de ler a letra, para ler a proxima

    estouroVar:
        lea dx, linhaEmBranco; joga a posicao de 'linhaEmBranco' para dx, preparando-se para imprimi-lo
        mov ah, 9; joga 9 para ah, preparando para imprimir mensagem
        int 21h; chama a interupcao 33 (21h)
        lea dx, msgExtouroVar;
        mov ah, 9; joga 9 para ah, preparando para imprimir mensagem
        int 21h; chama a interupcao 33 (21h)
        jmp fimLerPalavra; finaliza leitura

    fimLerPalavra:
        mov palavraAtual[si], "$"; inclui marcador de final
        lea dx, linhaEmBranco; joga a posicao de 'linhaEmBranco' para dx, preparando-se para imprimi-lo
        mov ah, 9; joga 9 para ah, preparando para imprimir mensagem
        int 21h; chama a interupcao 33 (21h)
    ret; retorna o fluxo para posicao de chamada

;-----------------------------------------------
fimPrograma:
    mov ax, 4c00h ; exit to operating system.
    int 21h
    jmp fimPrograma

ends

end start ; set entry point and stop the assembler.
