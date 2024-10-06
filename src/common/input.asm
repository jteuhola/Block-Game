input: 
    
    up:
        lda #1
        and $dc00 
        bne down 

    down: 
        lda #2
        and $dc00 
        bne left 
    left: 
        lda #4
        and $dc00 
        bne right 
    right:
        lda #8
        and $dc00 
        bne button 
    button: 
        lda #16
        and $dc00 
        bne noinput 

        inc $d020
noinput: 
    rts