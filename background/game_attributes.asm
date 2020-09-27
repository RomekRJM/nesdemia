LoadGameAttributes:
  LDA #.LOBYTE(GameAttribute)
  STA attributePointerLo
  LDA #.HIBYTE(GameAttribute)
  STA attributePointerHi

  JSR LoadAttributes
  RTS
