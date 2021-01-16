LoadGameCompletedAttributes:
  LDA #.LOBYTE(GameCompletedAttribute)
  STA attributePointerLo
  LDA #.HIBYTE(GameCompletedAttribute)
  STA attributePointerHi

  JSR LoadAttributes
  RTS
