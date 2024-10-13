input: 
    
    lda bool 
    and #%00000001
    bne button

    lda #0 
    sta dx 
    sta dy 

    up:
        lda #1
        and $dc00 
        bne down 
        lda #$fe
        sta dy
        jsr activate_movement

    down: 
        lda #2
        and $dc00 
        bne left 

        lda #$02 
        sta dy 
        jsr activate_movement
    left: 
        lda #4
        and $dc00 
        bne right 

        lda #$ff 
        sta dx 
        jsr activate_movement
    right:
        lda #8
        and $dc00 
        bne button 

        lda #$01 
        sta dx
        jsr activate_movement

    button: 
        lda #16
        and $dc00 
        bne noinput 
        // stop player movement
        lda #%11111110
        and bool 
        sta bool
noinput: 
    rts

activate_movement:
    lda #%00000001
    ora bool 
    sta bool
    rts