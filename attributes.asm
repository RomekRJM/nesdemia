LoadAttributes:
  LDA attributesNeedReloading
  BNE :+
    RTS
  :

  LDX #$00
  LDY health

  CPY #$00
  BEQ LoadAttributesLoop0

  CPY #$01
  BEQ LoadAttributesLoop1

  CPY #$02
  BEQ LoadAttributesLoop2

  CPY #$03
  BEQ LoadAttributesLoop3

  CPY #$04
  BEQ LoadAttributesLoop4

LoadAttributesLoop0:
  LDA Attribute0, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$41
  BNE LoadAttributesLoop0
  RTS

LoadAttributesLoop1:
  LDA Attribute1, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$41
  BNE LoadAttributesLoop1
  RTS

LoadAttributesLoop2:
  LDA Attribute2, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$41
  BNE LoadAttributesLoop2
  RTS

LoadAttributesLoop3:
  LDA Attribute3, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$41
  BNE LoadAttributesLoop3
  RTS

LoadAttributesLoop4:
  LDA Attribute4, X
  STA BEGIN_OF_ATTRIBUTES_MEMORY, X
  INX
  CPX #$41
  BNE LoadAttributesLoop4
  RTS
