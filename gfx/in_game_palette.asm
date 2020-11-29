LoadInGamePalettes:
  LDA #.LOBYTE(InGamePaletteData)
  STA palettePointerLo       ; put the low byte of the address of background into pointer
  LDA #.HIBYTE(InGamePaletteData)
  STA palettePointerHi       ; put the high byte of the address into pointer

  JSR LoadPalettes

  RTS
