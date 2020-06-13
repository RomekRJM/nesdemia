RenderCursor:
  LDX #$00
LoadCursorSprite:
  LDA MainMenuCursor, X
  CPX #$00
  BNE :+
    CLC
    ADC menuCursorTop
  :

  STA $0200, X
  INX
  CPX #$04
  BNE LoadCursorSprite

  RTS
