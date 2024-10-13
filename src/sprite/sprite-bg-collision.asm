sprite_bg_collsion:

// x:
    lda dx 
    bne !+
    jmp collision_y 
!:
    lda dx 
    bpl collision_right
    jmp collision_left 

collision_right:
    // right:

    lda xpos
    clc 
    adc dx
    adc #$07 // width
    sta tempx 
    lda ypos 
    sta tempy 
    jsr get_tile_position
    jsr check_collision
    lda #%00000010
    and bool
    beq !return+
    lda collision_flag
    and #%00000001
    lda #%11111101  // deactivate collision
    and bool 
    sta bool
    lda #0
    sta dx
    ldx tempx 
    dex 
    stx xpostile 
    lda tempy 
    sta ypostile 
    ldx #0
    jsr place_sprite
    jmp return

!return:
    rts

collision_left:
    lda dx 
    bpl collision_y

    lda xpos 
    clc 
    adc dx
    sta tempx 
    lda ypos 
    sta tempy 
    jsr get_tile_position
    jsr check_collision
    lda #%00000010
    and bool
    beq !return-
    // collison happened:
    lda #%11111101  // deactivate collision
    and bool 
    sta bool
    lda #0
    sta dx
    ldx tempx 
    inx 
    stx xpostile 
    lda tempy 
    sta ypostile 
    ldx #0 
    jsr place_sprite
    jmp return

collision_y:
    lda dy 
    bne collision_down
    jmp return 
collision_down:
    lda dy 
    bpl !continue+
    jmp collision_up
!continue:
    lda xpos 
    sta tempx 
    lda ypos 
    clc 
    adc dy 
    adc #$0f
    sta tempy 
    jsr get_tile_position
    jsr check_collision
    lda #%00000010
    and bool
    beq return 
    // collison happened:
    lda #%11111101  // deactivate collision
    and bool 
    sta bool
    lda #0
    sta dy
    ldx tempx 
    stx xpostile 
    ldx tempy 
    dex
    stx ypostile 
    ldx #0 
    jsr place_sprite
    jmp return

collision_up:
    lda dy 
    bmi !continue+
    jmp return
!continue:
    lda xpos 
    sta tempx 
    lda ypos 
    clc 
    adc dy 
    sta tempy 
    jsr get_tile_position
    jsr check_collision
    lda #%00000010
    and bool
    beq return 
    // collison happened:
    lda #%11111101  // deactivate collision
    and bool 
    sta bool
    lda #0
    sta dy
    ldx tempx 
    stx xpostile 
    ldx tempy 
    inx
    stx ypostile 
    ldx #0 
    jsr place_sprite
    jmp return

    // display debug coordinates:
        // lda tempx 
        // clc 
        // adc #$d0 
        // sta $0400
        // lda tempy 
        // clc 
        // adc #$d0 
        // sta $0402

    // read map: 
    // use 'y * 20 + x' as index
    
return:
    rts

check_collision:
    ldx tempy
    lda rowtable,x 
    clc 
    adc tempx 
    tax 
    lda map_data,x
    tax 
    lda collision_data,x 
    sta collision_flag
    // display on screen:
    //     pha 
    //     clc 
    //     adc #$d0
    //     sta $0404
    // pla 
    beq !skip+
    // collision happened
    lda #%11111110  // player can move
    and bool 
    sta bool
    lda #%00000010  // collision happened
    ora bool 
    sta bool 

!skip: 
    rts

collision_flag:
    .byte %00000000
    // bits:
    // - 0: solid
    // - 1: goal
    // - 2: damage
    // - 3: button
    // - 4: 
    // - 5:
    // - 6:
    // - 7:

// easy lookup table to check if map boundary is hit:
rowtable:
    .byte 0,20,40,60,80,100
    .byte 120,140,160,180
    .byte 200,220,240