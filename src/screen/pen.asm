inc_pen:
    // argument:
    // - accumulator -> increment amount
    clc 
    adc PENLO 
    sta PENLO 
    lda PENHI 
    adc #0
    sta PENHI 
    rts

dec_pen:
    // argument:
    // - temp -> decrement amount
    lda PENLO 
    sec 
    sbc temp 
    sta PENLO
    lda PENHI 
    sbc #0
    sta PENHI 
    rts 
