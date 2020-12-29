RenderCursor:
  LDX spriteCounter
  LDY #$00
LoadCursorSprite:
  LDA MainMenuCursor, Y
  CPX #$00
  BNE :+
    CLC
    ADC menuCursorTop
  :

  STA $0200, X
  INY
  INX
  CPY #$04
  BNE LoadCursorSprite
  STX spriteCounter

  RTS
