LoadAttributes:
  LDA attributesNeedReloading
  BNE :+
    RTS
  :
  LDA #$00
  STA attributesNeedReloading
  LDA #LUNG_HEALTHY_ATTRIBUTE
  STA $00
  LDX #$00
  ; TEST CODE !!! ; #$00, #$16, #$20, #$30
  LDY health
LoadAttributesLoop:
  LDA $00;Attribute, X
  STA $2007          ; write to PPU
  INX
  TXA
  CMP #$30
  BCC :+
    LDA #LUNG_SICK_ATTRIBUTE
    STA $00
  :
  LDA LungHealthLevels, Y
  STA dbg1
  STY dbg2
  CPX #$40
  BNE LoadAttributesLoop

  RTS
