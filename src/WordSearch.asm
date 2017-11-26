data segment
    CACA_PALAVRAS   DB    "ASDFKASJFLKASJDFLKJASKRUEIJDSLFJKLSAJKDSVMNMSDPFKVLSADFDSART" 
                    DB    "KSAOJFLKASJFLKASAJSDKFJSADKFJKSADJFLKSAJFKLJSALKFJLKASJCFKAA" 
                    DB    "ASJDFKSADKFJSKAREJADSREWUUTJBKNBDKGFPTHHFKSJRKDAJDKSHHAASDBB" 
                    DB    "JDSAKFJESIURVMLNFSKTYRSIUOVHKLSDFGREUIFSLKGHROIGJFKSDNKLSUAA" 
                    DB    "RUQLIOEUROIQEWURIODSMSADFJKSDJVXCMJASDKFVSALKFJKLSADNFLKSDUU" 
                    DB    "ASKCFJKALSDJFLKASDJFLKSAJDFLKASJDKLFJSALIKFJLSDKAJKESASLKAHH" 
                    DB    "RQWEIRUQWEISDFJHSADJFHSAUIFUIWQUERIUEWASDDJSATKLFJRDOKJFSSEE" 
                    DB    "ASDTFPOASIDFOPSAIDFOPAISDOPFIASOPFISAPODEIOPASDIFOPSAIFOOFHH" 
                    DB    "ASDFASDKFLSADKFLASKDFCLSAIDOFRIEJJVDFSAIOOSADIFOSDIOPFISDODD" 
                    DB    "ASPDFIASPOAFIPAOSDFIPACOMPUTADORFOPSADIFOPSDIFOPSDAOPFDSATAA" 
                    DB    "ASDFIEWOPRIEWOIREWOPQIROQWEIROPEWQIRPOWQEIOPRIWQORIWQEPOIREE" 
                    DB    "ASDFASDJRKASDJFKLASDJFLKDSAJFLKSDAJFASLKCDJFLKCSADFDSKSLADEE" 
                    DB    "ASDFASDOISADFISOADIFASDFISAODIFOSADIFSAODPIFPOSADIFOPDSIISAA" 
                    DB    "ASDOPFSADFINVNCXJDFSIFDSNFLSDAFUSADFUSDAIFUISADUFIODSAUISDDD" 
                    DB    "QWERUSIOWERUIOQWEURIOWEQUIRWEQUIORUQWOEIUSNVDMSADFKLSJDALKBB" 
                    DB    "LSKDEPOWELNVMXNCFDSLKLSEYEFMDSHVAFDJNFSYFDSNFSDAYUEQSDSAAACC" 
                    DB    "ALSRKLASDKLCASDLIURIWEURIEWQURIOQEWURIOFDSHFJSADHFJKSDADDDDD" 
                    DB    "VXPMZXESUOMXZNCVMIEOIOPDSIFOSDIOFISDAOFIOSADIFODSIFOSDAIODDD" 
                    DB    "QMIERUQIWERUIQWEURIOQWEURIQWUERIUQWEIRUQWIOERUIQWEURIEWUUQAA" 
                    DB    "IWERQUWIRUQWEIORUQIWOERUOIQWEUROIQWUEROIUQWOIEWRUIWSDVFSDHQQ",0 

    msgDigitePalavra db "Digite a palavra a ser procurada:",13,10,"$"
    msgExtouroVar db "Voce atingiu o tamanho maximo da palavra!"
    msgPalavraNaoEncontrada db "Nao foi possivel encontrar a palavra.",13,10,"Tente outra:",13,10,"$"

    quebraLinha DB 13,10,"$"
    linhaEmBranco DB 13,10,13,10,"$"
    
    palavraAtual DB "                    $";
    comparaPalavraEncontrouInicio DB 00h,0Ch,00h,00h ;00 - Coluna 00 - linha;
    comparaPalavraEncontrouFim    DB 00h,00h,00h,00h ;00 - Coluna 00 - linha;
    
    comparaPalavraEncontrouInicioDiagonal DW 0h,0h ;0 - Coluna 0 - linha;
    comparaPalavraEncontrouFimDiagonal DW 0h,0h ;0 - Coluna 0 - linha;
    
    dsColuna DB "coluna $"
    dsLinha DB " linha $"
    dsInicio DB "Inicio em $"
    dsFim DB "Fim em $" 
    
	validacaoPocisaoDiagonalAux dw ? ;Usado para validar se a poc da diagonal e valida
    acabouBuscaDiagonal dw 0 ;Usado para validar se a palavra do usuario foi encontrada na diagonal
    pocisaoAtualBuscaDiagonal dw ?
    posicaoDaPalavraAtual dw ?
    arrayDeComparacaoDiagonaDireita  dw 59,119,179,239,299,359,419,479,539,599,659,719,779,839,899,959,1019,1079,1139,1199 ;usado para validar diagonal que avanca para esquerda
	arrayDeComparacaoDiagonaEsquerda dw  0, 60,120,180,240,300,360,420,480,540,600,660,720,780,840,900, 960,1020,1080,1140 ;usado para validar diagonal que avanca para direita
	comparacaoLinhaMaior dw 1140 ;usado para valida se a diagonal esta na ultima linha
	comparacaoLinhaMenor dw 59 ;usado para valida se a diagonal esta na linha 0
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
    
    ;-------------------Busca Horizontal---------------------
            call buscaPalavraHorizontal
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
    
    ;--------------Busca Vertical---------------------
            call buscaPalavraVertical
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
    
    ;-------------------Busca Diagonal---------------------
            ;---Diagonal Superior----------------------
                    ;call buscaPalavraDiagonalSuperiorDireita
                    ;mov al, comparaPalavraEncontrouFim[3]
                    ;cmp al, 00
                    ;jne buscaPalavraTodasDirecoesAchou
                    ;mov al, comparaPalavraEncontrouFim[1]
                    ;cmp al, 00
                    ;jne buscaPalavraTodasDirecoesAchou
                    ;call buscaPalavraDiagonalSuperiorEsquerda
                    ;mov al, comparaPalavraEncontrouFim[3]
                    ;cmp al, 00
                    ;jne buscaPalavraTodasDirecoesAchou
                    ;mov al, comparaPalavraEncontrouFim[1]
                    ;cmp al, 00
                    ;jne buscaPalavraTodasDirecoesAchou
            ;---Diagonal Inferior----------------------
                    ;call buscaPalavraDiagonalInferiorDireita
                    ;mov ax, comparaPalavraEncontrouFimDiagonal
                    ;cmp ax, 00
                    ;jne buscaPalavraTodasDirecoesAchouDiagonal
                    ; falta coisas
                    ;call buscaPalavraDiagonalSupDirParaInfEsq
                    ;mov al, comparaPalavraEncontrouFim[3]
                    ;cmp al, 00
                    ;jne buscaPalavraTodasDirecoesAchou
                    ;mov al, comparaPalavraEncontrouFim[1]
                    ;cmp al, 00
                    ;jne buscaPalavraTodasDirecoesAchou
    
    jmp buscaPalavraTodasDirecoesNaoAchou  
    
    buscaPalavraTodasDirecoesAchouDiagonal:
        call imprimeResultadoDiagonal
        jmp buscaPalavraTodasDirecoesFim
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
imprimeResultadoDiagonal:
    mov bx, comparaPalavraEncontrouInicioDiagonal[0] 
    mov ax, comparaPalavraEncontrouInicioDiagonal[2]


    mov dx, comparaPalavraEncontrouFimDiagonal[0]
    mov cx, comparaPalavraEncontrouFimDiagonal[2]
    push dx
    push ax
    push cx
        ;Printa Inicio
            lea dx, dsInicio
            mov ah, 09
            int 21h
            lea dx, dsColuna
            mov ah, 09
            int 21h
            ;Printa coluna
                mov  ax,bx 
                aam
                add  ax, "00"
                xchg al, ah
                mov  dx, ax
                mov  ah, 02h
                int  21h
                mov  dl, dh
                int  21h 
            ;Quebra linha
            lea dx, dsLinha
            mov ah, 09
            int 21h
            ;Printa linha
                pop ax
                aam
                add  ax, "00"
                xchg al, ah
                mov  dx, ax
                mov  ah, 02h
                int  21h
                mov  dl, dh
                int  21h      
    lea dx, quebraLinha
    mov ah, 09
    int 21h             
    ;Printa Fim
            lea dx, dsFim
            mov ah, 09
            int 21h
            lea dx, dsColuna
            mov ah, 09
            int 21h
            ;Printa coluna
                pop dx
                mov ax,dx 
                aam
                add  ax, "00"
                xchg al, ah
                mov  dx, ax
                mov  ah, 02h
                int  21h
                mov  dl, dh
                int  21h 
            lea dx, dsLinha
            mov ah, 09
            int 21h
            ;Printa linha
                pop cx
                mov ax,cx
                aam
                add  ax, "00"
                xchg al, ah
                mov  dx, ax
                mov  ah, 02h
                int  21h
                mov  dl, dh
                int  21h      
    ;Quebra linha
    lea dx, dsLinha
    mov ah, 09
    int 21h
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
buscaPalavraDiagonalSuperiorDireita:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraDiagonalSuperiorEsquerda:
    ret;nao implementado

;-----------------------------------------------
buscaPalavraDiagonalInferiorDireita:
    
    ;reseta registradores usados
        mov di,0; indice da linha do 'CACA_PALAVRAS'
        lea si,CACA_PALAVRAS; indice da coluna do 'CACA_PALAVRAS'
        
    ;reseta variaveis de controle
        mov pocisaoAtualBuscaDiagonal,0
        mov posicaoDaPalavraAtual,0
        mov comparaPalavraEncontrouInicioDiagonal[0], 0h
        mov comparaPalavraEncontrouInicioDiagonal[2], 0h
    
        percorreCacaPalavraBuscaPalavraDiagonalInferiorDireita:
             mov comparaPalavraEncontrouInicioDiagonal[0], si
             mov comparaPalavraEncontrouInicioDiagonal[2], di
             mov ax,si
             add ax,di 
             mov pocisaoAtualBuscaDiagonal,ax
             loopBuscaPalavraDiagonalInferiorDireita:
                 
                 ;printa letra sendo buscada diagonal
                 lea bx,CACA_PALAVRAS
                 add bx,[pocisaoAtualBuscaDiagonal]
                 mov dx, [bx]
                 mov ah, 2
                 int 21h 
                 
                 ;------------Valida se pocisao é valida;  bx = Poc do cacaPalavra; dx = Array para comparar
                 ;lea bx,CACA_PALAVRAS
                 ;add bx,[pocisaoAtualBuscaDiagonal]
				 ;lea dx,arrayDeComparacaoDiagonaDireita
                 ;call comparaArray
                 ;cmp validacaoPocisaoDiagonalAux,0 ; se for 0 pocisao é invalida
                 ;je buscaPalavraDiagonalInferiorDireitaNaoAchou
                 
                 ;-------------------------------------------------------------aqui fazer tratamento de maiusculo/minusculo
                 ;------------Carrega em dl o caractere do cacaPalavras
                 lea ax,CACA_PALAVRAS
                 add ax,pocisaoAtualBuscaDiagonal
                 mov bx,ax
                 mov dl,[bx]
                 
                 ;------------Carrega em dh palavra do usuario e compara
                 lea ax,palavraAtual
                 add ax,posicaoDaPalavraAtual
                 mov bx,ax
                 mov dh,[bx]
                 cmp dh,dl  ;Se nao sao iguais vai para prox carac do cacaPalavras
                 jne avancaParaProximoCaracBuscaDiagonalInferiorDireita
                  
                 
                ;------------Incrementa poc da palavra 
                mov ax,[posicaoDaPalavraAtual]
                inc ax 
                mov posicaoDaPalavraAtual,ax
                ;------------Compara se poc da palavra atual == $
                lea ax,palavraAtual
                add ax,posicaoDaPalavraAtual
                mov bx,ax
                cmp [bx],"$"
                je buscaPalavraDiagonalInferiorDireitaAchou 
                
                ;----------Incrementa poc da busca da diagonal
                mov ax,[pocisaoAtualBuscaDiagonal]
                add ax,61 
                mov pocisaoAtualBuscaDiagonal,ax
            jmp loopBuscaPalavraDiagonalInferiorDireita 
            
            avancaParaProximoCaracBuscaDiagonalInferiorDireita:;Vai para proximo caractere do cacaPalavra
                ;reset das variaveis
                    mov pocisaoAtualBuscaDiagonal,0
                    mov posicaoDaPalavraAtual,0
                call vaiParaProximaLetra
                cmp acabouBuscaDiagonal,1  ;compara se chegou ao fim do cacaPalavra
                je buscaPalavraDiagonalInferiorDireitaNaoAchou
        
        jmp percorreCacaPalavraBuscaPalavraDiagonalInferiorDireita
            
                        
    buscaPalavraDiagonalInferiorDireitaNaoAchou:    
        ;reseta variaveis de inicio e fim.
        mov comparaPalavraEncontrouFim[0], 0h
        mov comparaPalavraEncontrouFim[1], 0h    
        mov comparaPalavraEncontrouFim[2], 0h    
        mov comparaPalavraEncontrouFim[3], 0h    
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h
        jmp fimBuscaPalavraDiagonalInferiorDireita
    buscaPalavraDiagonalInferiorDireitaAchou:   
        ;grava a posiacao fim.
        mov ax,[pocisaoAtualBuscaDiagonal]
        call trataPocisaoFinalDiagonal
        
fimBuscaPalavraDiagonalInferiorDireita:
ret        

;-----------------------------------------------   ;buscaPalavraDiagonalInferiorEsquerda
buscaPalavraDiagonalSupDirParaInfEsq:
    ;reseta registradores usados
        mov cx, 0; indice da coluna da 'palavraAtual'
        mov dx, 0; indice da coluna do 'CACA_PALAVRAS'
        mov di, 0; indice da diagonal do 'CACA_PALAVRAS'    
    
    ;reseta variaveis de controle
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h    


    buscaPalavraDiagonalSupDirParaInfEsqComp:
        mov si, cx
        cmp palavraAtual[si], "$";verifica se e o fim da palavra pela qual se esta procurando.
        je buscaPalavraDiagonalSupDirParaInfEsqAchou;move o fluxo para o rotulo que trata encontrar a palavra.
        mov si, di                         
        cmp CACA_PALAVRAS[di], "$";verifica se e o fim da tabela em que se esta procurando
        je buscaPalavraDiagonalSupDirParaInfEsqNaoAchou;move o fluxo para o rotulo que trata nao encontrar a palavra
        cmp CACA_PALAVRAS[di], 0;verifica se e o fim da tabela em que se esta procurando
        je buscaPalavraDiagonalSupDirParaInfEsqNaoAchou;move o fluxo para o rotulo que trata nao encontrar a palavra
        mov al, CACA_PALAVRAS[di]
        mov si, cx
        cmp al, palavraAtual[si];compara as letras nos indices atuais nas duas variaveis
        je buscaPalavraDiagonalSupDirParaInfEsqCompCaracterIgual;move fluxo para  desencontro de letras (palavras nao sao iguais)
        
        cmp al, 'a'
        js buscaPalavraDiagonalSupDirParaInfEsqCompUpperCaseFim
        cmp al, 'z'  
        jg buscaPalavraDiagonalSupDirParaInfEsqCompUpperCaseFim   
        sub al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraDiagonalSupDirParaInfEsqCompCaracterIgual     
        buscaPalavraDiagonalSupDirParaInfEsqCompUpperCaseFim: 
        
        cmp al, 'A'
        js buscaPalavraDiagonalSupDirParaInfEsqCompLowerCaseFim
        cmp al, 'Z'  
        jg buscaPalavraDiagonalSupDirParaInfEsqCompLowerCaseFim   
        add al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraDiagonalSupDirParaInfEsqCompCaracterIgual     
        buscaPalavraDiagonalSupDirParaInfEsqCompLowerCaseFim:
        
        jmp buscaPalavraDiagonalSupDirParaInfEsqCompCaracterDif         
        
        buscaPalavraDiagonalSupDirParaInfEsqCompCaracterIgual:

            inc cx;avanca os indices, para continuar comparacao
            add di, 59;avanca os indices, para continuar comparacao            
            pusha
                mov ax, di
                mov dx, 0
                mov cx, 60
                div cx
                mov bx, dx 
                sub di, 59
                mov cx, 60 
                mov dx, 0
                mov ax, di
                div cx
                cmp dx, bx
                je  buscaPalavraDiagonalSupDirParaInfEsqEstouro;trata nova linha;
            popa        
            jmp buscaPalavraDiagonalSupDirParaInfEsqComp;retorna para comparar proximos caracteres

    buscaPalavraDiagonalSupDirParaInfEsqEstouro:
        popa            
        jmp buscaPalavraDiagonalSupDirParaInfEsqCompCaracterDif

    buscaPalavraDiagonalSupDirParaInfEsqCompCaracterDif:
        mov cx, 0; reseta indices
        inc dx
        mov di, dx              
        ;grava o caracter de inicio como sendo a posicao atual
        mov bx, dx        
        pusha                                   
            mov ax, di
            mov dx, 0
            mov cx, 60
            div cx  
            mov comparaPalavraEncontrouInicio[0], dh ;grava coluna
            mov comparaPalavraEncontrouInicio[1], dl
            mov dx, 0
            mul cx
            mov comparaPalavraEncontrouInicio[2], ah;grava linha
            mov comparaPalavraEncontrouInicio[3], al
        popa
        jmp buscaPalavraDiagonalSupDirParaInfEsqComp


    buscaPalavraDiagonalSupDirParaInfEsqNaoAchou:    
        ;reseta variaveis de inicio e fim.
        mov comparaPalavraEncontrouFim[0], 0h
        mov comparaPalavraEncontrouFim[1], 0h    
        mov comparaPalavraEncontrouFim[2], 0h    
        mov comparaPalavraEncontrouFim[3], 0h    
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h
        jmp fimBuscaPalavraDiagonalSupDirParaInfEsq
    buscaPalavraDiagonalSupDirParaInfEsqAchou:   
        ;grava a posiacao fim.    
        pusha                                   
            mov ax, di
            mov dx, 0
            mov cx, 60
            div cx  
            mov comparaPalavraEncontrouFim[0], dh ;grava coluna
            mov comparaPalavraEncontrouFim[1], dl
            mov dx, 0
            mul cx
            mov comparaPalavraEncontrouFim[2], ah;grava linha
            mov comparaPalavraEncontrouFim[3], al
        popa
                                                           
        mov bx, 0
        buscaPalavraDiagonalSupDirParaInfEsqAchouTrataCase:
            sub di, 59
            dec cx     
            call trataCase   
            cmp cx, 0
            jne buscaPalavraDiagonalSupDirParaInfEsqAchouTrataCase
        
        jmp fimBuscaPalavraDiagonalSupDirParaInfEsq
    fimBuscaPalavraDiagonalSupDirParaInfEsq:
        ret                                      


;-----------------------------------------------
buscaPalavraVerticalOposto:
    ;reseta registradores usados
        mov cx, 0; indice da coluna da 'palavraAtual'
        mov dx, 59; indice da coluna do 'CACA_PALAVRAS' reset
        mov bx, 59; indice da coluna do 'CACA_PALAVRAS'
        mov di, 1140; indice da linha do 'CACA_PALAVRAS'    
    
    ;reseta variaveis de controle      
            mov comparaPalavraEncontrouInicio[0], bh ;grava coluna
            mov comparaPalavraEncontrouInicio[1], bl
            mov ax, di
            mov comparaPalavraEncontrouInicio[2], ah;grava linha
            mov comparaPalavraEncontrouInicio[3], al


    buscaPalavraVerticalOpostoComp:
        mov si, cx
        cmp palavraAtual[si], "$";verifica se e o fim da palavra pela qual se esta procurando.
        je buscaPalavraVerticalOpostoAchou;move o fluxo para o rotulo que trata encontrar a palavra.
        mov si, di                         
        mov ax, si
        add ax, bx
        cmp ax, -1;
        je buscaPalavraVerticalOpostoNaoAchou;move o fluxo para o rotulo que trata nao encontrar a palavra
        mov al, CACA_PALAVRAS[bx + si]
        mov si, cx
        cmp al, palavraAtual[si];compara as letras nos indices atuais nas duas variaveis
        je buscaPalavraVerticalOpostoCompCaracterIgual;move fluxo para  desencontro de letras (palavras nao sao iguais)
        
        cmp al, 'a'
        js buscaPalavraVerticalOpostoCompUpperCaseFim
        cmp al, 'z'  
        jg buscaPalavraVerticalOpostoCompUpperCaseFim   
        sub al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraVerticalOpostoCompCaracterIgual     
        buscaPalavraVerticalOpostoCompUpperCaseFim: 
        
        cmp al, 'A'
        js buscaPalavraVerticalOpostoCompLowerCaseFim
        cmp al, 'Z'  
        jg buscaPalavraVerticalOpostoCompLowerCaseFim   
        add al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraVerticalOpostoCompCaracterIgual     
        buscaPalavraVerticalOpostoCompLowerCaseFim:
        
        jmp buscaPalavraVerticalOpostoCompCaracterDif         
        
        buscaPalavraVerticalOpostoCompCaracterIgual:
        
            inc cx;avanca os indices, para continuar comparacao
            sub di, 60
            cmp di, 0;verifica se o indice da linha do 'CACA_PALAVRAS' e 60
            je  buscaPalavraVerticalOpostoEstouro;trata nova linha;
            jmp buscaPalavraVerticalOpostoComp;retorna para comparar proximos caracteres

    buscaPalavraVerticalOpostoEstouro:
        mov dx, 0;emula valor 59 em dx, para reaproveitar funcionamento do tratamento de caracteres diferentes
        jmp buscaPalavraVerticalOpostoCompCaracterDif

    buscaPalavraVerticalOpostoCompCaracterDif:
        mov cx, 0; reseta indices
        sub di, 60
        jnc buscaPalavraVerticalOpostoLinhaOk; 
        mov di, 1140     
        dec dx               ;trata o estouro da linha
        jmp buscaPalavraVerticalOpostoLinhaOk

        buscaPalavraVerticalOpostoLinhaOk:               
            ;grava o caracter de inicio como sendo a posicao atual
            mov bx, dx
            mov comparaPalavraEncontrouInicio[0], bh ;grava coluna
            mov comparaPalavraEncontrouInicio[1], bl
            mov ax, di
            mov comparaPalavraEncontrouInicio[2], ah;grava linha
            mov comparaPalavraEncontrouInicio[3], al
            jmp buscaPalavraVerticalOpostoComp


    buscaPalavraVerticalOpostoNaoAchou:    
        ;reseta variaveis de inicio e fim.
        mov comparaPalavraEncontrouFim[0], 0h
        mov comparaPalavraEncontrouFim[1], 0h    
        mov comparaPalavraEncontrouFim[2], 0h    
        mov comparaPalavraEncontrouFim[3], 0h    
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h
        jmp fimBuscaPalavraVerticalOposto
    buscaPalavraVerticalOpostoAchou:   
        ;grava a posiacao fim.
        mov comparaPalavraEncontrouFim[0], bh
        mov comparaPalavraEncontrouFim[1], bl
        mov ax, di
        mov comparaPalavraEncontrouFim[2], ah
        mov comparaPalavraEncontrouFim[3], al
        
        buscaPalavraVerticalOpostoAchouTrataCase:                
            dec cx
            add di, 60     
            call trataCase   
            cmp cx, 0
            jne buscaPalavraVerticalOpostoAchouTrataCase
        
        jmp fimBuscaPalavraVerticalOposto
    fimBuscaPalavraVerticalOposto:
        ret                                      



;-----------------------------------------------
buscaPalavraHorizontalOposto:
    ;reseta registradores usados
        mov cx, 0; indice da coluna da 'palavraAtual'
        mov dx, 59; indice da coluna do 'CACA_PALAVRAS' reset
        mov bx, 59; indice da coluna do 'CACA_PALAVRAS'
        mov di, 1140; indice da linha do 'CACA_PALAVRAS'    
    
    ;reseta variaveis de controle      
        mov comparaPalavraEncontrouInicio[0], bh ;grava coluna
        mov comparaPalavraEncontrouInicio[1], bl
        mov ax, di
        mov comparaPalavraEncontrouInicio[2], ah;grava linha
        mov comparaPalavraEncontrouInicio[3], al 


    buscaPalavraHorizontalOpostoComp:
        mov si, cx
        cmp palavraAtual[si], "$";verifica se e o fim da palavra pela qual se esta procurando.
        je buscaPalavraHorizontalOpostoAchou;move o fluxo para o rotulo que trata encontrar a palavra.
        mov si, di                         
        mov ax, di
        add ax, bx
        cmp ax, -1
        je buscaPalavraHorizontalOpostoNaoAchou;move o fluxo para o rotulo que trata nao encontrar a palavra
        mov al, CACA_PALAVRAS[bx + si]
        mov si, cx
        cmp al, palavraAtual[si];compara as letras nos indices atuais nas duas variaveis
        je buscaPalavraHorizontalOpostoCompCaracterIgual;move fluxo para  desencontro de letras (palavras nao sao iguais)
        
        cmp al, 'a'
        js buscaPalavraHorizontalOpostoCompUpperCaseFim
        cmp al, 'z'  
        jg buscaPalavraHorizontalOpostoCompUpperCaseFim   
        sub al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraHorizontalOpostoCompCaracterIgual     
        buscaPalavraHorizontalOpostoCompUpperCaseFim: 
        
        cmp al, 'A'
        js buscaPalavraHorizontalOpostoCompLowerCaseFim
        cmp al, 'Z'  
        jg buscaPalavraHorizontalOpostoCompLowerCaseFim   
        add al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraHorizontalOpostoCompCaracterIgual     
        buscaPalavraHorizontalOpostoCompLowerCaseFim:
        
        jmp buscaPalavraHorizontalOpostoCompCaracterDif         
        
        buscaPalavraHorizontalOpostoCompCaracterIgual:
        
            inc cx;avanca os indices, para continuar comparacao
            dec bx;avanca os indices, para continuar comparacao
            jc  buscaPalavraHorizontalOpostoEstouro;trata nova linha;
            jmp buscaPalavraHorizontalOpostoComp;retorna para comparar proximos caracteres

    buscaPalavraHorizontalOpostoEstouro:
        mov dx, 0;emula valor 59 em dx, para reaproveitar funcionamento do tratamento de caracteres diferentes
        jmp buscaPalavraHorizontalOpostoCompCaracterDif

    buscaPalavraHorizontalOpostoCompCaracterDif:
        mov cx, 0; reseta indices
        dec dx
        jnc buscaPalavraHorizontalOpostoLinhaOk; 
        mov dx, 59
        sub di, 60                        ;trata o estouro da linha
        jmp buscaPalavraHorizontalOpostoLinhaOk

        buscaPalavraHorizontalOpostoLinhaOk:               
            ;grava o caracter de inicio como sendo a posicao atual
            mov bx, dx
            mov comparaPalavraEncontrouInicio[0], bh ;grava coluna
            mov comparaPalavraEncontrouInicio[1], bl
            mov ax, di
            mov comparaPalavraEncontrouInicio[2], ah;grava linha
            mov comparaPalavraEncontrouInicio[3], al
            jmp buscaPalavraHorizontalOpostoComp


    buscaPalavraHorizontalOpostoNaoAchou:    
        ;reseta variaveis de inicio e fim.
        mov comparaPalavraEncontrouFim[0], 0h
        mov comparaPalavraEncontrouFim[1], 0h    
        mov comparaPalavraEncontrouFim[2], 0h    
        mov comparaPalavraEncontrouFim[3], 0h    
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h
        jmp fimBuscaPalavraHorizontalOposto
    buscaPalavraHorizontalOpostoAchou:   
        ;grava a posiacao fim.
        mov comparaPalavraEncontrouFim[0], bh
        mov comparaPalavraEncontrouFim[1], bl
        mov ax, di
        mov comparaPalavraEncontrouFim[2], ah
        mov comparaPalavraEncontrouFim[3], al
        
        buscaPalavraHorizontalOpostoAchouTrataCase:                
            inc bx
            dec cx     
            call trataCase   
            cmp cx, 0
            jne buscaPalavraHorizontalOpostoAchouTrataCase
        
        jmp fimBuscaPalavraHorizontalOposto
    fimBuscaPalavraHorizontalOposto:
        ret

;-----------------------------------------------
buscaPalavraVertical:
    ;reseta registradores usados
        mov cx, 0; indice da coluna da 'palavraAtual'
        mov dx, 0; indice da linha do 'CACA_PALAVRAS' reset
        mov bx, 0; indice da coluna do 'CACA_PALAVRAS'
        mov di, 0; indice da linha do 'CACA_PALAVRAS'    
    
    ;reseta variaveis de controle
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h    


    buscaPalavraVerticalComp:
        mov si, cx
        cmp palavraAtual[si], "$";verifica se e o fim da palavra pela qual se esta procurando.
        je buscaPalavraVerticalAchou;move o fluxo para o rotulo que trata encontrar a palavra.
        mov si, di                           
        cmp CACA_PALAVRAS[bx + si], "$";verifica se e o fim da tabela em que se esta procurando
        je buscaPalavraVerticalNaoAchou;move o fluxo para o rotulo que trata nao encontrar a palavra
        cmp CACA_PALAVRAS[bx + si], 0;verifica se e o fim da tabela em que se esta procurando
        je buscaPalavraVerticalNaoAchou;move o fluxo para o rotulo que trata nao encontrar a palavra                                                            
        mov al, CACA_PALAVRAS[bx + si]
        mov si, cx
        cmp al, palavraAtual[si];compara as letras nos indices atuais nas duas variaveis
        je buscaPalavraVerticalCompCaracterIgual;move fluxo para  desencontro de letras (palavras nao sao iguais)
        
        cmp al, 'a'
        js buscaPalavraVerticalCompUpperCaseFim
        cmp al, 'z'  
        jg buscaPalavraVerticalCompUpperCaseFim   
        sub al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraVerticalCompCaracterIgual     
        buscaPalavraVerticalCompUpperCaseFim: 
        
        cmp al, 'A'
        js buscaPalavraVerticalCompLowerCaseFim
        cmp al, 'Z'  
        jg buscaPalavraVerticalCompLowerCaseFim   
        add al, 20h
        cmp al, palavraAtual[si]  
        je buscaPalavraVerticalCompCaracterIgual     
        buscaPalavraVerticalCompLowerCaseFim:
        
        jmp buscaPalavraVerticalCompCaracterDif         
        
        buscaPalavraVerticalCompCaracterIgual:
        
            inc cx;avanca os indices, para continuar comparacao
            add di, 60
            cmp di, 1260;verifica se o indice da linha do 'CACA_PALAVRAS' e 60
            je  buscaPalavraVerticalEstouro;trata nova linha;
            jmp buscaPalavraVerticalComp;retorna para comparar proximos caracteres

    buscaPalavraVerticalEstouro:
        mov dx, 1140;emula valor 59 em dx, para reaproveitar funcionamento do tratamento de caracteres diferentes
        jmp buscaPalavraVerticalCompCaracterDif

    buscaPalavraVerticalCompCaracterDif:
        mov cx, 0; reseta indices
        add dx, 60    
        cmp dx, 1200
        jne buscaPalavraVerticalLinhaOk; 
        mov dx, 0
        inc bx
        jmp buscaPalavraVerticalLinhaOk

        buscaPalavraVerticalLinhaOk:               
            ;grava o caracter de inicio como sendo a posicao atual
            mov comparaPalavraEncontrouInicio[0], bh ;grava coluna
            mov comparaPalavraEncontrouInicio[1], bl                                            
            mov di, dx
            mov comparaPalavraEncontrouInicio[2], dh;grava linha
            mov comparaPalavraEncontrouInicio[3], dl
            jmp buscaPalavraVerticalComp


    buscaPalavraVerticalNaoAchou:    
        ;reseta variaveis de inicio e fim.
        mov comparaPalavraEncontrouFim[0], 0h
        mov comparaPalavraEncontrouFim[1], 0h    
        mov comparaPalavraEncontrouFim[2], 0h    
        mov comparaPalavraEncontrouFim[3], 0h    
        mov comparaPalavraEncontrouInicio[0], 0h
        mov comparaPalavraEncontrouInicio[1], 0h
        mov comparaPalavraEncontrouInicio[2], 0h
        mov comparaPalavraEncontrouInicio[3], 0h
        jmp fimBuscaPalavraVertical
    buscaPalavraVerticalAchou:   
        ;grava a posiacao fim.
        mov comparaPalavraEncontrouFim[0], bh
        mov comparaPalavraEncontrouFim[1], bl
        mov ax, di
        mov comparaPalavraEncontrouFim[2], ah
        mov comparaPalavraEncontrouFim[3], al
        
        buscaPalavraVerticalAchouTrataCase:                
            dec cx
            sub di, 60     
            call trataCase   
            cmp cx, 0
            jne buscaPalavraVerticalAchouTrataCase
        
        jmp fimBuscaPalavraVertical
    fimBuscaPalavraVertical:
        ret                                      


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
            cmp bx, 61;verifica se o indice da linha do 'CACA_PALAVRAS' e 60
            je  buscaPalavraHorizontalEstouro;trata nova linha;
            jmp buscaPalavraHorizontalComp;retorna para comparar proximos caracteres

    buscaPalavraHorizontalEstouro:
        mov dx, 60;emula valor 59 em dx, para reaproveitar funcionamento do tratamento de caracteres diferentes
        jmp buscaPalavraHorizontalCompCaracterDif

    buscaPalavraHorizontalCompCaracterDif:
        mov cx, 0; reseta indices
        inc dx
        cmp dx, 61
        jne buscaPalavraHorizontalLinhaOk; 
        mov dx, 0
        add di, 60                        ;trata o estouro da linha
        jmp buscaPalavraHorizontalLinhaOk

        buscaPalavraHorizontalLinhaOk:               
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
    mov dx,01; usado para validar se alguma letra foi digitada
    
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
    
    exibirMensagemdeveDigitarAlgumaLetra: 
        mov dx,01; usado para validar se alguma letra foi digitada
        jmp lerLetra        

    fimLerPalavra:
        cmp dx,01
        je exibirMensagemdeveDigitarAlgumaLetra;   
        mov palavraAtual[si], "$"; inclui marcador de final
        lea dx, linhaEmBranco; joga a posicao de 'linhaEmBranco' para dx, preparando-se para imprimi-lo
        mov ah, 9; joga 9 para ah, preparando para imprimir mensagem
        int 21h; chama a interupcao 33 (21h)
    ret; retorna o fluxo para posicao de chamada

;----------------------------------------------- Usado para validacoes das diagonais
comparaArray:  ;a posicao do array deve estar em dx ;a posicao do cacaPalavra deve estar em bx
	push bx ; salva a posicao do cacaPalavra
	mov cx,0    
    mov validacaoPocisaoDiagonalAux,1 ;o resultado da validacao e armazenado em validacaoPocisaoDiagonalAux temporariamente
    mov ax,bx ;salva a pocisao do cacaPalavra para poder alterar bx
	push dx ;salva a pocisao do array temporariamente
	loopComparaArray:
		;incrementa pocisao do vetor
		add dx,cx
        mov bx,dx
		;seta a letra do array em dl
		mov dl,[bx]
		;seta a letra do cacaPalavra em dh
		mov bx,ax
		mov dh,[bx]
        cmp dl,dl
        je comparacaoArrayFalse 
        inc cx
        ;verifica se ja chegou ao fim do array de comparacao
        cmp cx,19
        je fimComparaArray
		;compara se pocisaoAtualBuscaDiagonal > 1140
		mov bx,ax
		cmp bx,1140
		jge comparacaoArrayFalse
		
    jmp loopComparaArray
        
		
fimComparaArray:  ; o resultado da comparacao é retornado em validacaoPocisaoDiagonalAux
pop bx ;restaura a pocisao do cacaPalavra
mov dx,0 
mov cx,0

ret

comparacaoArrayFalse:
    mov validacaoPocisaoDiagonalAux,0
    jmp fimComparaArray

;-----------------------------------------------Comparacoes diagonal linha 0 ou ultima linha
                                                ;O resultado e retornado em ax
    ;---------------------Compara se esta na linha 0
        comparaDiagonalLinhaMenor:
    
        ;cmp ax,comparacaoLinhaMenor 
        ;jge retornaFalseComparacao
        
        ret
    
    ;---------------------Compara se esta na ultima linha    
        
        comparaDiagonalLinhaMaior:
        
            ;comp ax,comparacaoLinhaMaior  
            ;jge retornaFalseComparacao
        
        ret
    
    
    retornaFalseComparacao:
        ;mov ax,0   
        
    ret 
                                 
;-----------------------------------------------Pula para proxima letra
    vaiParaProximaLetra: 
        mov acabouBuscaDiagonal,0
    
        cmp si,59
        je resetaSi
        jmp incrementaSi       
        fimVaiParaProximaLetra:
        ret                           
    
            incrementaSi:
                inc si
                jmp fimVaiParaProximaLetra ;fim                              
            
            resetaSi:
                call pulaParaProximaLinha;
                mov si,0          
                jmp fimVaiParaProximaLetra ;fim
    ;-------------------------             Pula para proxima linha, e valida se chegou ao final do caca palavra
    pulaParaProximaLinha:
       add di,60
       lea dx, quebraLinha
       mov ah, 9
       int 21h
       cmp di,1200
       je chegouAoFinalCacaPalavra
    fimPulaParaProximaLinha:   
    ret
    chegouAoFinalCacaPalavra:
       mov acabouBuscaDiagonal,1
       jmp fimPulaParaProximaLinha
;-----------------------------------------------
trataPocisaoFinalDiagonal:
    mov dx,0 
    mov bx,60
    div bx
    mov comparaPalavraEncontrouFimDiagonal[0], dx
    mov comparaPalavraEncontrouFimDiagonal[2], ax
ret    

;-----------------------------------------------
fimPrograma:
    mov ax, 4c00h ; exit to operating system.
    int 21h
    jmp fimPrograma

ends

end start ; set entry point and stop the assembler.