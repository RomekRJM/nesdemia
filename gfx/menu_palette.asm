LoadMenuPalettes:
  LDA #.LOBYTE(MenuPaletteData)
  STA palettePointerLo       ; put the low byte of the address of background into pointer
  LDA #.HIBYTE(MenuPaletteData)
  STA palettePointerHi       ; put the high byte of the address into pointer

  LDA #$1c
  JSR LoadPalettes

  RTS
