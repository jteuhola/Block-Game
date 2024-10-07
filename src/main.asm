//
// Example
//

.const V        = $d000
.const SCREEN   = $0400

.var PENLO    = $fb
.var PENHI    = $fc

*=$0801 "Main"
// basic call
.byte $0c,$08,$b5,$07,$9e,$20,$32,$30,$36,$32,$00,$00,$00
jmp init


init:
    lda #147
    jsr $ffd2

    // screen color
    lda #$0e; sta $d020
    lda #$00; sta $d021

    lda #%11011000
    sta $d016   // multicolor on
    lda #2
    sta $d022
    lda #10
    sta $d023
    // chr and screen memory
    lda #%00011000 // chr mem -> $2000-$27ff, screen -> $0400-$07ff
    sta $d018
    // position sprites at $2800 ->
    // #$a0 * #$40 = #$2800
    // 160 * 64 = 10 240

    jsr draw_screen
    jsr setup_sprite

    lda #$01 
    sta $d800 
    sta $d802

main:
    jsr raster
    jsr input
    jsr update_sprite
    ldx #00
    jsr draw_sprite
    jmp main 


raster:
    lda $d012
    cmp #$ff
    bne raster
    rts

#import "./sprite/sprite-setup.asm" 


*=$2000 "Chars"
#import "src/assets/graphics/block-game-chars.asm"

*=$2900 "Sprites"
#import "src/assets/graphics/block-game-sprites.asm"

*=$2a00 "RAM"
#import "common/input.asm"
#import "screen/pen.asm"
#import "screen/draw-screen.asm"
#import "sprite/get-tile-position.asm"

*=$8000 "Maps"
#import "assets/maps/map0.asm"

// TILES:
#import "assets/block-tileset.asm"

//### COMMON VARIABLES #########################

bool:
    .byte %00000000
     // bits:
     // 0 - player moving
     // 1 -
     // 2 -
     // 3 -
     // 4 -
     // 5 -
     // 6 -
     // 7 -

temp:       .byte 0
tempx:      .byte 0
tempy:      .byte 0
counter:    .byte 0
colcounter: .byte 0


