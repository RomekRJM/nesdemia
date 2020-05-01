NMI:
  ; reload attribute table
  LDA attributesNeedReloading
  BNE :+
    JMP CopySpriteDataToPPU
  :

  ; Attributes
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDA #$00
  STA attributesNeedReloading

CopyAttributeDataToPPU:
  LDA #$ff
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  LDA $d2
  STA $2007
  LDA $d3
  STA $2007
  LDA $d4
  STA $2007
  LDA $d5
  LDA #$ff
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  LDA $da
  STA $2007
  LDA $db
  STA $2007
  LDA $dc
  STA $2007
  LDA $dd
  STA $2007
  LDA #$ff
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  LDA $e2
  STA $2007
  LDA $e3
  STA $2007
  LDA $e4
  STA $2007
  LDA $e5
  STA $2007
  LDA #$ff
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007
  STA $2007

CopySpriteDataToPPU:
  ; copy sprite data from $0200 => PPU memory for display
  LDA #$02
  STA $4014

  INC frame
  INC nmiTimer

  RTI
