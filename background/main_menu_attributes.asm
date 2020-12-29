LoadMainMenuAttributes:
  LDA #.LOBYTE(MainMenuAttribute)
  STA attributePointerLo
  LDA #.HIBYTE(MainMenuAttribute)
  STA attributePointerHi
  JSR LoadAttributes
  RTS
