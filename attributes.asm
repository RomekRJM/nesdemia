LoadAttributes:
  LDA attributesNeedReloading
  BNE :+
    RTS
  :
  ; Attributes
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$33
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDA #$00
  STA attributesNeedReloading
  LDA #LUNG_HEALTHY_ATTRIBUTE
  STA $00
  LDX #$00
  ; TEST CODE !!! ; #$00, #$16, #$20, #$30
  LDY health
LoadAttributesLoop:
  LDA LungHealthLevels, Y
  STA $01
  CPX $01
  BCC :+
    LDA #LUNG_SICK_ATTRIBUTE
    STA $00
  :
  LDA $00
  STA $2007          ; write to PPU
  INX
  CPX #$41
  BNE LoadAttributesLoop

  RTS
