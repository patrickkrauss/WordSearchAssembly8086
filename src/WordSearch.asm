data segment
    CACA_PALAVRAS 	DB	"ASDFKASJFLKASJDFLKJASKRUEIJDSLFJKLSAJKDSVMNMSDPFKVLSADFDSART"
				DB	"KSAOJFLKASJFLKASAJSDKFJSADKFJKSADJFLKSAJFKLJSALKFJLKASJCFKAA"
				DB	"ASJDFKSADKFJSKAREJADSREWUUTJBKNBDKGFPTHHFKSJRKDAJDKSHHAASDBB"
				DB	"JDSAKFJESIURVMLNFSKTYRSIUOVHKLSDFGREUIFSLKGHROIGJFKSDNKLSUAA"
				DB	"RUQLIOEUROIQEWURIODSMSADFJKSDJVXCMJASDKFVSALKFJKLSADNFLKSDUU"
				DB	"ASKCFJKALSDJFLKASDJFLKSAJDFLKASJDKLFJSALIKFJLSDKAJKESASLKAHH"
				DB	"RQWEIRUQWEISDFJHSADJFHSAUIFUIWQUERIUEWASDDJSATKLFJRDOKJFSSEE"
				DB	"ASDTFPOASIDFOPSAIDFOPAISDOPFIASOPFISAPODEIOPASDIFOPSAIFOOFHH"
				DB	"ASDFASDKFLSADKFLASKDFCLSAIDOFRIEJJVDFSAIOOSADIFOSDIOPFISDODD"
				DB	"ASPDFIASPOAFIPAOSDFIPACOMPUTADORFOPSADIFOPSDIFOPSDAOPFDSATAA"
				DB	"ASDFIEWOPRIEWOIREWOPQIROQWEIROPEWQIRPOWQEIOPRIWQORIWQEPOIREE"
				DB	"ASDFASDJRKASDJFKLASDJFLKDSAJFLKSDAJFASLKCDJFLKCSADFDSKSLADEE"
				DB	"ASDFASDOISADFISOADIFASDFISAODIFOSADIFSAODPIFPOSADIFOPDSIISAA"
				DB	"ASDOPFSADFINVNCXJDFSIFDSNFLSDAFUSADFUSDAIFUISADUFIODSAUISDDD"
				DB	"QWERUSIOWERUIOQWEURIOWEQUIRWEQUIORUQWOEIUSNVDMSADFKLSJDALKBB"
				DB	"LSKDEPOWELNVMXNCFDSLKLSEYEFMDSHVAFDJNFSYFDSNFSDAYUEQSDSAAACC"
				DB	"ALSRKLASDKLCASDLIURIWEURIEWQURIOQEWURIOFDSHFJSADHFJKSDADDDDD"
				DB	"VXPMZXESUOMXZNCVMIEOIOPDSIFOSDIOFISDAOFIOSADIFODSIFOSDAIODDD"
				DB	"QMIERUQIWERUIQWEURIOQWEURIQWUERIUQWEIRUQWIOERUIQWEURIEWUUQAA"
				DB	"IWERQUWIRUQWEIORUQIWOERUOIQWEUROIQWUEROIUQWOIEWRUIWSDVFSDHQQ",0
    msgDigitePalavra db "Digite a palavra a ser procurada:",13,10,"$"
    quebraLinha DB 13,10,"$"  
    palavraAtual DB "palavra de teste"
    caractereEncontrado DB ?
    posicaoAtualDaBusca DW ?
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
    
    
    
    ;call lerPalavra
    ;call printaCacaPalavras        
    
    
    percorreCacaPalavras:
        jmp procuraPalavraHorizontalDireita
        ;mov bx,di
        ;mov dl, [si+bx]
        ;mov ah, 2
        ;int 21h
        call vaiParaProximaLetra
    jmp percorreCacaPalavras
    
       
    mov ax, 4c00h ; exit to operating system.
    int 21h                                                                                         
    fimPrograma:
    jmp fimPrograma
    
    ;---------------Rotulos:                                                                                                                     '
    
    procuraPalavraHorizontalDireita:
        lea bx,CACA_PALAVRAS
        add bx,di
        add bx,si      
        mov ax,[bx]
        inc ax
        loopProcuraPalavraHorizontalDireita:
            ;mov bx,ax
            ;mov [posicaoAtualDaBusca],ax
                 
            mov bx,ax
            lea dx, bx
            mov ah, 9
            int 21h  
           
            inc ax
            mov [posicaoAtualDaBusca],ax
        
        
        jmp loopProcuraPalavraHorizontalDireita:     
    
    fimProcuraPalavraHorizontalDireita:
    
    ret
    
    
    comparaPalavra: 
        lea ax,palavraAtual   
        
    
    
    
    ret  
    
    buscaCaractereDireita:
            
    
    
    
    ret
    
    
    ;-----------------------------------------------Pula para proxima letra
    vaiParaProximaLetra:
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
       je fimPrograma
    ret
    ;-----------------------------------------------
    
    
     
   
   
    printaCacaPalavras:
        lea dx, CACA_PALAVRAS
        mov ah, 9
        int 21h
    ret
    
       
    
    lerPalavra:  
        lea dx, msgDigitePalavra
        mov ah, 9
        int 21h        ; output string at ds:dx
        ;AQUI LER A PALAVRA DO USUARIO       
        ;SALVAR A ENTRADA EM palavraAtual
    ret
     
ends

end start ; set entry point and stop the assembler.
