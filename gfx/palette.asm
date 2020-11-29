LoadPalettes:
  LDY #$00
  LDX #$00
LoadPalettesLoop:
  LDA (palettePointerLo), Y
  STA paletteUpdateMemory, X
  INY
  INX
  CPY #$20
  BNE LoadPalettesLoop

  LDA #$01
  STA refreshPalette

  RTS
