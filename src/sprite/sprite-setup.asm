setup_sprite:
    // only first sprite
    lda #%00000001
    sta $d015   // enable
    sta $d01c   // multicolor
    lda #%00000000
    sta $d017 // y-expansion
    sta $d01b // sprite behind bg
    sta $d01d // x-expansion
    lda #02 ; sta $d025 // extra color 1
    lda #07 ; sta $d026 // extra color 2

    ldy #$a4 // #$a0 * #$40 = #$2800
    ldx #$00
!loop:
    tya
    sta $07f8,x   // sprite pointers
    lda sprite_colors,x 
    sta $d027,x
    inx 
    iny 
    cpx #$04
    bne !loop-

    ldx #$00
    jsr place_sprite



    rts

#import "place-sprite.asm"
#import "draw-sprite.asm"
#import "update-sprite.asm"
#import "sprite-bg-collision.asm"

xpostile: 
    .byte $03,$00,$00,$00
    .byte $00,$00,$00,$00
ypostile:   
    .byte $00,$00,$00,$00
    .byte $00,$00,$00,$00
xposhi:
    .byte 0,0,0,0,0,0,0,0
xpos:
    .byte 0,0,0,0,0,0,0,0
ypos:
    .byte 0,0,0,0,0,0,0,0
dx:
    .byte 0,0,0,0,0,0,0,0
dy:
    .byte 0,0,0,0,0,0,0,0

sprite_colors:
    .byte 8,6,0,0,0,0,0,0