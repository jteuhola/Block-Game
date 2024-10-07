get_tile_position:
    // parameters:
    // - tempx -> x coordinate
    // - tempy -> y-coordinate
    // use these as return values also

    lda tempx 
    sec 
    sbc #$0c // border offset 
    lsr 
    lsr 
    lsr 
    sta tempx 
    lda tempy 
    sec 
    sbc #$32 
    lsr 
    lsr 
    lsr 
    lsr 
    sta tempy

    rts 