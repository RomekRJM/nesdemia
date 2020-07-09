LoadAttributes:
  LDA $2002             ; read PPU status to reset the high/low latch

  LDY #$00              ; start out at 0

LoadAttributesLoop:
  LDA (attributePointerLo), Y
  STA $2007
  INY
  CPY #$40
  BNE LoadAttributesLoop
  RTS
