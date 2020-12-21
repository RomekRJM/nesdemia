LoadPasswordAttributes:
  LDA #.LOBYTE(PasswordAttribute)
  STA attributePointerLo
  LDA #.HIBYTE(PasswordAttribute)
  STA attributePointerHi
  JSR LoadAttributes
  RTS
