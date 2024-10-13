color_screen: 

    ldx #0
!loop:
    ldy SCREEN,x 
    lda char_attribute_data,y 
    sta SCREEN_ATTRIBUTES,x 
    ldy SCREEN+$100,x 
    lda char_attribute_data,y 
    sta SCREEN_ATTRIBUTES+$100,x 
    ldy SCREEN+$200,x 
    lda char_attribute_data,y 
    sta SCREEN_ATTRIBUTES+$200,x 
    ldy SCREEN+$2e8,x 
    lda char_attribute_data,y 
    sta SCREEN_ATTRIBUTES+$2e8,x 
    inx 
    bne !loop-
    rts