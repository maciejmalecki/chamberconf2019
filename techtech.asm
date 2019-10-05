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
.label IRQ_HANDLER = irqHandler
.label RASTER_IRQ_POS = $62

*=$0801 "Basic Upstart"
BasicUpstart(start)
*=$080d "Program"
start:
        jsr init
        jsr setupScreen
        jsr installIrq
mainLoop:
        inc BORD_COL
        dec BORD_COL
        jmp mainLoop
        
irqHandler: {
        pha

        .for (var i = 0; i < 20; i++) {        
                nop
        }
        
        lda #WHITE
        sta BG_COL
        .for (var i = 0; i < 7; i++) {        
                nop
        }
        lda #BLACK
        sta BG_COL
        dec IRR
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

setupScreen: {
        lda #BLACK
        sta BORD_COL
        sta BG_COL
        
        ldx #$00
        loop:
                lda screenData, x
                sta SCREEN, x
                lda screenData + $100, x
                sta SCREEN + $100, x
                lda screenData + $200, x
                sta SCREEN + $200, x
                lda screenData + $300, x
                sta SCREEN + $300, x

                lda colorData, x
                sta COLOR_RAM, x
                lda colorData + $100, x
                sta COLOR_RAM + $100, x
                lda colorData + $200, x
                sta COLOR_RAM + $200, x
                lda colorData + $300, x
                sta COLOR_RAM + $300, x
                inx
                bne loop
        
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

screenData:
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$55,$40,$49,$20,$6E,$20,$70,$20,$55,$43,$49,$20,$70,$49,$55,$6E,$20,$70,$43,$49,$20,$70,$43,$6E,$20,$70,$43,$49,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$42,$20,$20,$20,$42,$20,$42,$20,$42,$20,$42,$20,$42,$42,$42,$42,$20,$42,$20,$42,$20,$42,$20,$20,$20,$42,$20,$42,$20,$03,$0F,$0E,$06,$20,$20,$20,$20,$20
.byte $20,$20,$42,$20,$20,$20,$6B,$43,$73,$20,$6B,$43,$73,$20,$42,$4A,$4B,$42,$20,$6B,$43,$49,$20,$6B,$43,$20,$20,$6B,$43,$49,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$42,$20,$20,$20,$42,$20,$42,$20,$42,$20,$42,$20,$42,$20,$20,$42,$20,$42,$20,$42,$20,$42,$20,$20,$20,$42,$20,$42,$20,$20,$20,$20,$20,$32,$30,$31,$39,$20
.byte $20,$20,$4A,$40,$4B,$20,$7D,$20,$6D,$20,$7D,$20,$6D,$20,$7D,$20,$20,$6D,$20,$6D,$43,$4B,$20,$6D,$43,$7D,$20,$7D,$20,$4A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$42,$62,$79,$6F,$64,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$42,$77,$E2,$F9,$E2,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$42,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$42,$E9,$DF,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$E9,$A0,$A0,$DF,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$E9,$A0,$69,$5F,$A0,$DF,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$A0,$20,$20,$DC,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$A0,$20,$20,$DC,$A0,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$A0,$A0,$A0,$A0,$A0,$DC,$61,$20,$DC,$61,$20,$DC,$61,$20,$DC,$61,$20,$DC,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A0,$A0,$A0,$A0,$A0,$A0,$DC,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$DC,$A0,$A0,$A0,$A0,$A0,$DC,$A0,$A0,$A0,$A0,$E2,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$DC,$A0,$A0,$A0,$A0,$A0,$DC,$A0,$A0,$A0,$61,$20,$E1,$A0,$A0,$A0,$A0,$A0,$A0,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$E6,$A0,$A0,$A0,$A0,$A0,$DC,$A0,$A0,$A0,$61,$20,$E1,$A0,$A0,$A0,$A0,$A0,$A0,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$E6,$E6,$E8,$A0,$A0,$A0,$DC,$A0,$A0,$A0,$FC,$62,$FE,$A0,$A0,$A0,$A0,$A0,$A0,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.fill 24, $00

colorData:
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$01,$0F,$0C,$0E,$01,$0E,$0F,$0E,$01,$0F,$0C,$0E,$01,$0F,$01,$0F,$0E,$01,$0F,$0C,$0E,$01,$0F,$0C,$0E,$01,$0F,$0C,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0F,$0E,$0E,$0E,$0F,$0E,$0F,$0E,$0F,$0E,$0C,$0E,$0F,$0C,$0F,$0C,$0E,$0F,$0E,$0B,$0E,$0F,$0E,$0E,$0E,$0F,$0E,$0B,$0E,$0F,$0F,$0F,$0F,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0C,$0E,$0E,$0E,$0C,$0C,$0C,$0E,$0C,$0C,$0B,$0E,$0C,$0C,$0B,$0B,$0E,$0C,$0C,$0B,$0E,$0C,$0C,$0E,$0E,$0C,$0C,$0B,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0C,$0E,$0E,$0E,$0C,$0E,$0B,$0E,$0C,$0E,$0B,$0E,$0C,$0E,$0E,$0B,$0E,$0C,$0E,$0B,$0E,$0C,$0E,$0E,$0E,$0C,$0E,$0B,$0E,$0E,$0E,$0E,$0E,$0D,$07,$0A,$02,$0E
.byte $0E,$0E,$0B,$0B,$0B,$0E,$0B,$0E,$0B,$0E,$0B,$0E,$0B,$0E,$0B,$0E,$0E,$0B,$0E,$0B,$0B,$0B,$0E,$0B,$0B,$0B,$0E,$0B,$0E,$0B,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0C,$02,$02,$02,$02,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0C,$02,$02,$02,$02,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0C,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0C,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.byte $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
.fill 24, $00