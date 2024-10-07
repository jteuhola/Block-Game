sprite_bg_collsion:

    // right:
    lda xpos
    clc 
    adc dx
    adc #$07 // width
    sta tempx 
    lda ypos 
    sta tempy 
    jsr get_tile_position

    // display debug coordinates:
    lda tempx 
    clc 
    adc #$d0 
    sta $0400
    lda tempy 
    clc 
    adc #$d0 
    sta $0402

    // read map: 
    // use 'y * 20 + x' as index

    ldx tempy
    lda rowtable,x 
    clc 
    adc tempx 
    tax 
    lda map_data,x
    pha 
    clc 
    adc #$d0
    sta $0404
    pla 
    cmp #$10
    bne !skip+
    lda #0 
    sta bool
    sta dx
    ldx tempx 
    dex 
    stx xpostile 
    lda tempy 
    sta ypostile 
    ldx #0
    jsr place_sprite
    inc $d020 
!skip: 



    rts

rowtable:
    .byte 0,20,40,60,80,100
    .byte 120,140,160,180
    .byte 200,220,240