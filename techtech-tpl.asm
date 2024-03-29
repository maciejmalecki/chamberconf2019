.label CONTROL_1 = $d011
.label RASTER = $d012
.label CONTROL_2 = $d016
.label IRR = $d019
.label IMR = $d01a
.label BORD_COL = $d020
.label BG_COL = $d021
.label CIA1_ICR = $dc0d
.label CIA2_ICR = $dd0d
.label SCREEN = $0400
.label COLOR_RAM = $d800
.label IO_REG = $01
.label NMI_LO = $fffa
.label NMI_HI = $fffb
.label IRQ_LO = $fffe
.label IRQ_HI = $ffff
.label TECH_TECH_WIDTH = 11*8

.label IRQ_HANDLER = irqTechTech
.label RASTER_IRQ_POS = $32

*=$0801 "Basic Upstart"
BasicUpstart(start)
*=$080d "Program"
start:
        jsr init
        jsr installIrq
mainLoop:
        jmp mainLoop
        
techTechData:  .fill TECH_TECH_WIDTH, round(3.5 + 3.5*sin(toRadians(i*360/TECH_TECH_WIDTH))) ; .byte 0; .byte $ff

irqTechTech: {

          pha
          txa
          pha
          tya
          pha
          
          lda CONTROL_2
          and #$11111000
          ora #1
          sta CONTROL_2
          
          ldx #$00
        loop:
          lda CONTROL_2
          and #%11111000
          ora techTechData, x
          cmp #$ff
          beq endTechTech
          ldy RASTER
          cmpAgain: cpy RASTER
          beq cmpAgain
          sta CONTROL_2
          inx
          jmp loop
        endTechTech:
          
          lda CONTROL_2
          and #$11111000
          ora #0
          sta CONTROL_2
          
          lda techTechData
          pha
  
          .for(var i = 0; i < TECH_TECH_WIDTH - 1; i++) {
                lda techTechData + i + 1
                sta techTechData + i
          }
  
          pla
          sta techTechData + TECH_TECH_WIDTH - 1
          
          pla
          tay
          pla
          tax
          pla
          dec $d019
          rti
          }   

irqGoodLine: {
        pha
        lda #BLACK
        .for(var i = 0; i < 28; i++) {
                nop
        }
        sta BG_COL
        .for(var i = 0; i < 20; i++) {
                nop
        }
        lda #BLUE
        sta BG_COL
        dec $d019
        pla
        rti
}

irqBadLine: {
        pha
        lda #BLACK
        .for(var i = 0; i < 19; i++) {
                nop
        }
        sta BG_COL
        .for(var i = 0; i < 17; i++) {
                nop
        }
        lda #BLUE
        sta BG_COL
        dec $d019
        pla
        rti
}

installIrq: {
        sei
        lda #RASTER_IRQ_POS
        sta RASTER
        lda CONTROL_1
        and #%01111111
        sta CONTROL_1
        lda #$01
        sta IMR
        cli
        rts
}

init: {
        sei
        lda IO_REG
        and #%11111000
        ora #%00000101
        sta IO_REG
        
        lda #<IRQ_HANDLER
        sta NMI_LO
        sta IRQ_LO
        lda #>IRQ_HANDLER
        sta NMI_HI
        sta IRQ_HI
        
        lda #$7f
        sta CIA1_ICR
        sta CIA2_ICR
        lda CIA1_ICR
        lda CIA2_ICR
        
        cli
        rts
}
