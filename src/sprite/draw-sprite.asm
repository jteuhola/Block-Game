draw_sprite: 
    lda ypos, x 
    sta V+1,x 
    lda xpos,x 
    asl 
    ror $d010 
    sta V,x 
    inx 
    inx 
    cpx #16 
    bne draw_sprite
    rts 