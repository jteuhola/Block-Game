//
// Example
//

.const V        = $d000
.const SCREEN   = $0400

.const PENLO    = $fb
.const PENHI    = $fc

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

    // chr and screen memory
    //lda #%00011000 // chr mem -> $2000-$27ff, screen -> $0400-$07ff
    //sta $d018
    // position sprites at $2800 ->
    // #$a0 * #$40 = #$2800
    // 160 * 64 = 10 240

    jsr setup_sprite


main:
    jsr raster
    jsr input
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

