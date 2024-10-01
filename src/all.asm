v        = $d000
screen   = $0400

penlo    = $fb
penhi    = $fc


         *= $0810

         lda #<32768 ;callback
         sta $0318
         lda #>32768
         sta $0319

         lda #147    ;clear screen
         jsr $ffd2

         lda #21
         sta 53272


         lda #$0e    ;border color
         sta $d020

         lda #13    ;13 * 64 = 832
         sta 2040
         lda #1
         sta v+21   ;spr 0 enable
         lda #8
         sta v+39   ;spr 0 color

         jsr setupspr

         ldx #0          ;draw screen
         stx counter
         stx penlo
         lda #$04
         sta penhi
         jsr drawscreen

         ldx #$00       ;color screen
         jsr colorscreen

         ldx #0
         jsr positionsprite

         lda #$01
         sta $d800
         sta $d804
         sta $d828

main
         jsr raster
         jsr input
         jsr moveplayer
         ldx #$00
         jsr drawsprite

         lda bool
         sta $0404

         jmp main

;-.MOVE.PLAYER.-------------------------
moveplayer
         jsr sprbgcoll
         lda xpos
         clc
         adc dx
         sta xpos
         lda ypos
         clc
         adc dy
         sta ypos

         rts

sprbgcoll

         lda #$04       ;print x and y:
         sta penhi
         lda #$00
         sta penlo
         lda xpos
         sta tempx
         lda ypos
         sta tempy
         jsr gettilepos
         lda tempx
         jsr printnum
         lda #$28
         jsr incpen
         lda tempy
         jsr printnum

         .block

    ;collision

      ;x

         lda dx
         beq y
         bmi left
         bpl right
         jmp y
left
         lda xpos        ;get tile locs
         clc
         adc dx
         sta tempx
         lda ypos
         sta tempy
         jsr gettilepos
         jsr checkcoll
         lda #%00000001
         and collflags
         beq y
         inc tempx
         jsr stopplr
         jmp y

right
         lda xpos
         clc
         adc dx
         adc #8
         sta tempx
         lda ypos
         sta tempy
         jsr gettilepos
         jsr checkcoll
         lda #%00000001
         and collflags
         beq up
         dec tempx
         jsr stopplr

y
         lda dy
         bmi up
         bpl down
up

down

         rts


checkcoll
         ldx tempy
         lda rowtable,x
         clc
         adc tempx
         tax
         ldy map,x
         lda flags,y
         sta collflags

         rts
         .bend

stopplr
         lda tempx
         sta xpostile
         lda tempy
         sta ypostile
         jsr positionsprite

         lda #0
         sta dx
         sta dy
         sta bool

         lda #%11111110
     ;   and bool
     ;   sta bool

         inc $d020

         rts

;-.GET.TILE.POSITION.-------------------
gettilepos
         lda tempx
         sec
         sbc #$0c
         lsr a
         lsr a
         lsr a
         sta tempx
         lda tempy
         sec
         sbc #$32
         lsr a
         lsr a
         lsr a
         lsr a
         sta tempy
         rts



;---------------------------------------

drawsprite
         lda ypos,x
         sta v+1,x
         lda xpos,x
         asl a
         ror $d010
         sta v,x
         inx
         inx
         cpx #16
         bne drawsprite

         rts



;-.POSITION.SPRITES.--------------------

positionsprite
         lda xpostile,x
         asl a
         asl a
         asl a
         clc
         adc #$0c
         sta xpos,x
         lda ypostile,x
         asl a
         asl a
         asl a
         asl a
         clc
         adc #$32
         sta ypos,x
         inx
         cpx #$08
         bne positionsprite
         rts

;-.INPUT.-------------------------------
input
         lda #%00000001
         and bool
         bne noinput

         lda #0
         sta dx
         sta dy
up
         lda #1
         and $dc00
         bne down
         lda #$ff
         sta dy
         lda #%00000001
         ora bool
         sta bool
         jmp button
down
         lda #2
         and $dc00
         bne left
         lda #$01
         sta dy
         lda #%00000001
         ora bool
         sta bool
         jmp button

left
         lda #4
         and $dc00
         bne right
         lda #$ff
         sta dx
         lda #%00000001
         ora bool
         sta bool
         jmp button

right
         lda #8
         and $dc00
         bne button
         lda #$01
         sta dx
         lda #%00000001
         ora bool
         sta bool


button
         lda #16
         and $dc00
         bne noinput
         jsr stopplr


noinput
         rts


;-.DRAW.SCREEN.-------------------------
drawscreen
         .block
loop
         ldx counter
         lda map,x
         asl a    ; * 2
         asl a    ; * 2
         tax
         lda tiles,x
         ldy #0
         sta (penlo),y
         lda #$01
         jsr incpen
         inx
         lda tiles,x
         sta (penlo),y
         lda #$27
         jsr incpen
         inx
         lda tiles,x
         sta (penlo),y
         lda #$01
         jsr incpen
         inx
         lda tiles,x
         sta (penlo),y
         lda counter
         cmp #$77       ;3b  ,77
         beq quitdraw

         inc colcounter
         lda colcounter
         cmp #$14
         bne skiprowinc
         lda #$00
         sta colcounter
         lda #$28
         jsr incpen

skiprowinc

         inc counter
         lda #$27
         sta temp
         jsr decpen
         jmp loop

quitdraw
         rts

         .bend

;---------------------------------------
incpen
         clc
         adc penlo
         sta penlo
         lda penhi
         adc #0
         sta penhi
         rts

decpen
         lda penlo
         sec
         sbc temp
         sta penlo
         lda penhi
         sbc #0
         sta penhi
         rts

;-.COLOR.SCREEN.------------------------
colorscreen
         ldy screen,x
         lda colors,y
         sta $d800,x
         ldy screen+$0100,x
         lda colors,y
         sta $d900,x
         ldy screen+$0200,x
         lda colors,y
         sta $da00,x

         inx
         bne colorscreen
         rts

;---------------------------------------
setupspr
         lda #%00000001
         sta $d01c      ;multicolor
         lda #$02
         sta $d025
         lda #$07
         sta $d026

         ldx #47
sprloop  lda sprite,x
         sta 832,x
         dex
         bpl sprloop

         rts

;---------------------------------------
printnum
         clc
         adc #$30
         ldy #$00
         sta (penlo),y
         rts

;-.RASTER.------------------------------
raster
         lda $d012
         cmp #$ff
         bne raster
         rts

;---------------------------------------
bool
         .byte %00000000
     ; bits:
     ; 0 - player moving
     ; 1 -
     ; 2 -
     ; 3 -
     ; 4 -
     ; 5 -
     ; 6 -
     ; 7 -

temp
         .byte $00
counter
         .byte $00,$00    ;lo, hi
colcounter
         .byte $00

dx       .byte $00
dy       .byte $00
tempx    .byte $00
tempy    .byte $00

xpostile
         .byte $03,$00,$00,$00
         .byte $00,$00,$00,$00
ypostile
         .byte $03,$00,$00,$00
         .byte $00,$00,$00,$00
xposhi
         .byte 0,0,0,0,0,0,0,0
xpos
         .byte 0,0,0,0,0,0,0,0
ypos
         .byte 0,0,0,0,0,0,0,0

collflags
         .byte %00000000
     ; bits:
     ; 0 - solid
     ; 1 -
     ; 2 -
     ; 3 -
     ; 4 -
     ; 5 -
     ; 6 -
     ; 7 -

;---------------------------------------
sprite
         .byte $aa,$aa,$00,$aa,$aa,$00
         .byte $a5,$56,$00,$a7,$f6,$00
         .byte $9b,$fe,$00,$b9,$fe,$00
         .byte $b6,$fe,$00,$be,$7e,$00
         .byte $bd,$be,$00,$bf,$9e,$00
         .byte $bf,$6e,$00,$9f,$e6,$00
         .byte $97,$da,$00,$95,$5a,$00
         .byte $aa,$aa,$00,$aa,$aa,$00


;-.TILES.-------------------------------
tiles
         .byte $20,$20,$20,$20
         .byte $01,$02,$03,$04
         .byte 83,90,65,88

colors
         .byte $00
         .byte $02,$05,$06,$07
         .byte $0e,$06,$06,$0e
         .byte $0a,$02,$02,$0e

flags
         .byte %00000000
         .byte %00000001

;---------------------------------------
map
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$01
         .byte $01,$00,$01,$01,$01,$00
         .byte $00,$00,$00,$00,$00,$01
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$01
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$00
         .byte $01,$00,$01,$00,$00,$00
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$00,$00,$00,$00,$00
         .byte $00,$01
         .byte $01,$01,$01,$01,$01,$01
         .byte $01,$01,$01,$01,$01,$01
         .byte $01,$01,$01,$01,$01,$01
         .byte $01,$01

;-.ROW.MULTIPLICATION.TABLE.------------
rowtable
         .byte 0,20,40,60,80,100
         .byte 120,140,160,180
         .byte 200,220,240