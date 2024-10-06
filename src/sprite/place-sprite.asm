place_sprite:
    // x:
    lda xpostile, x
    asl 
    asl 
    asl 
    clc 
    adc #$0c // border offset
    sta xpos, x

    // y:
    lda ypostile, x 
    asl 
    asl 
    asl 
    asl 
    clc 
    adc #$32 // border offset
    sta ypos,x 
    // inx 
    // cpx #$08 
    // bne place_sprite
    rts