LoadAttributes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDY #$00              ; start out at 0

LoadAttributesLoop:
  LDA (attributePointerLo), Y
  STA $2007
  INY
  CPY #$40
  BNE LoadAttributesLoop
  RTS
