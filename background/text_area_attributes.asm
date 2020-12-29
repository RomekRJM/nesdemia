LoadTextAreaAttributes:
  LDA #.LOBYTE(MenuAttribute)
  STA attributePointerLo
  LDA #.HIBYTE(MenuAttribute)
  STA attributePointerHi
  JSR LoadAttributes
  RTS
