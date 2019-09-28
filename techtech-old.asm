.label TECH_TECH_WIDTH = 9*8

*=$0801 "Basic Upstart"
BasicUpstart(start)
*=$080d "Program"
start:

          jsr initialize
          jsr prepareScreen
          jsr installIrq

// keep it busy
          lda #01
          sta $d020
mainLoop:
         // inc $d020
         // dec $d020
         // nop
          jmp mainLoop
          
          
installIrq:
          sei
          lda #$42
          sta $d012
          lda $d011
          and #%0111111
          sta $d011
          
          lda #$01
          sta $d01a
          cli
          rts          

prepareScreen: {         
          
// turn 38 columns          
       
          lda $d016          
          and #%11110111
          sta $d016
          
// black background
          lda #BLACK
          sta $d021

// fill screen with text
          lda #'i'
          ldx #0
        loopScreen:
          sta $0400, x
          sta $0500, x
          sta $0600, x
          sta $0700, x
          inx
          bne loopScreen

          lda #WHITE
          ldx #0
        loopColor:
          sta $d800, x
          sta $d900, x
          sta $da00, x
          sta $db00, x
          inx
          bne loopColor

          rts          
        }
          
initialize:          
          
          sei        
          // disable BASIC and KERNAL
          lda $01
          and #%11111000
          ora #%00000101
          sta $01
          
          // set NMI dummy handler
          lda #<nmiHandler
          sta $fffa
          lda #>nmiHandler
          sta $fffb
          // set IRQ handler
          lda #<irqHandler
          sta $fffe
          lda #>irqHandler
          sta $ffff
          // turn off CIA interrupts
          lda #$7f
          sta $dc0d
          sta $dd0d
          lda $dc0d
          lda $dd0d
          cli
          rts          
          
irqHandler: {

          pha
          txa
          pha
          tya
          pha
          
          lda #BLUE
          sta $d021
          
          lda $d016
          and #$11111000
          ora #1
          sta $d016
          
          ldx #$00
        loop:
          lda $d016
          and #%11111000
          ora techTechData, x
          cmp #$ff
          beq endTechTech
          ldy $d012
          cmpAgain: cpy $d012
          beq cmpAgain
          sta $d016
          inx
          jmp loop
        endTechTech:
          
          lda $d016
          and #$11111000
          ora #0
          sta $d016
          
          lda #BLACK
          sta $d021
          
          pla
          tay
          pla
          tax
          pla
          dec $d019
          rti
          }   
          
nmiHandler:
          rti
          
techTechData:  .fill TECH_TECH_WIDTH, round(3.5 + 3.5*sin(toRadians(i*360/TECH_TECH_WIDTH))) ; .byte 0; .byte $ff

          