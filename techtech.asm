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
.label TECH_TECH_WIDTH = 9*8

*=$0801 "Basic Upstart"
BasicUpstart(start)
*=$080d "Program"
start:
        jsr init
mainLoop:
        inc BORD_COL
        dec BORD_COL
        jmp mainLoop
        
irq: {
        rti
}

init: {
        lda #BLACK
        sta BORD_COL
        
        sei
        lda IO_REG
        and #%11111000
        ora #%00000101
        sta IO_REG
        
        lda #<irq
        sta NMI_LO
        sta IRQ_LO
        lda #>irq
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
