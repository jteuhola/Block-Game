draw_screen:
    ldx #0
    stx counter 
    stx PENLO 
    lda #$04
    sta PENHI 
    

!loop: 
    ldx counter 
    lda map_data,x 
    asl // * 2
    asl // * 2  because tiles are 4 chars
    tax 
    lda chartileset_data,x 
    ldy #0 
    sta (PENLO),y 
    lda #$01 
    jsr inc_pen 
    inx 
    lda chartileset_data,x 
    sta (PENLO),y 
    lda #$27
    jsr inc_pen 
    inx 
    lda chartileset_data,x 
    sta (PENLO),y 
    lda #$01 
    jsr inc_pen 
    inx 
    lda chartileset_data,x 
    sta (PENLO),y 
    lda counter 
    cmp #$f0
    beq draw_hud 

    inc colcounter 
    lda colcounter 
    cmp #$14
    bne skiprowinc 
    lda #$00 
    sta colcounter 
    lda #$28 
    jsr inc_pen 

skiprowinc:
    inc counter 
    lda #$27
    sta temp 
    jsr dec_pen
    jmp !loop-

draw_hud:
    ldx #$28
!loop:
    lda hud_data,x
    sta $07c0,x
    dex
    bne !loop- 

quitdraw:
rts





