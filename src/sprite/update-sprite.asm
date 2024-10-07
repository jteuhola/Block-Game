update_sprite: 
    jsr sprite_bg_collsion
    lda xpos 
    clc 
    adc dx 
    sta xpos 
    lda ypos 
    clc 
    adc dy 
    sta ypos
    rts