//
// Example
//

.const V        = $d000
.const SCREEN   = $0400
.const SCREEN_ATTRIBUTES = $d800

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
    lda #$06; sta $d020
    lda #$00; sta $d021

    lda #%11011000
    sta $d016   // multicolor on
    lda #6
    sta $d022   // multicolor 1
    lda #3
    sta $d023   // multicolor 2
    // chr and screen memory
    lda #%00011000 // chr mem -> $2000-$27ff, screen -> $0400-$07ff
    sta $d018
    // position sprites at $2800 ->
    // #$a0 * #$40 = #$2800
    // 160 * 64 = 10 240

    jsr draw_screen
    jsr color_screen
    jsr setup_sprite


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
charset_data:
.import binary "src/assets/graphics/block-game-chars.bin"

*=$2900 "Sprites"
#import "src/assets/graphics/block-game-sprites.asm"

*=$2a00 "Char Attribute Data"
char_attribute_data:
.import binary "src/assets/graphics/block-game-char-attributes.bin"

*=$2b00 "RAM"
#import "common/input.asm"
#import "screen/pen.asm"
#import "screen/draw-screen.asm"
#import "screen/color-screen.asm"
#import "sprite/get-tile-position.asm"

*=$8000 "Maps"
map_data:
.import binary "assets/maps/map0.bin"

// TILES:
#import "assets/block-tileset.asm"
#import "assets/tileset-collision-flags.asm"
// HUD:
hud_data:
.import binary "assets/hud.bin"

//### COMMON VARIABLES #########################

bool:
    .byte %00000000
     // bits:
     // 0 - player moving
     // 1 - collision occurred
     // 2 -
     // 3 -
     // 4 -
     // 5 -
     // 6 -
     // 7 -

level:      .byte 4
buttons:    .byte 10     // press buttons to spawn a portal

temp:       .byte 0
tempx:      .byte 0
tempy:      .byte 0
counter:    .byte 0
colcounter: .byte 0


