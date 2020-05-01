LoadAttributes:
  LDA attributesNeedReloading
  BNE :+
    RTS
  :

  LDY health
  LDA LungHealthLevels, Y
  STA $01
  LDA #LUNG_HEALTHY_ATTRIBUTE
  LDX #$00
LoadAttributesLoop:
  CPX $01
  BCC :+
    LDA #LUNG_SICK_ATTRIBUTE
  :
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$41
  BNE LoadAttributesLoop

  RTS
