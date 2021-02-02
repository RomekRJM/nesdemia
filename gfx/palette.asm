; A - contains color for background
LoadPalettes:
  STA $00
  LDY #$00
  LDX #$00
LoadPalettesLoop:
  LDA (palettePointerLo), Y
  ; swap background color
  CPY #$10
  BNE :+
    LDA $00
  :
  STA paletteUpdateMemory, X
  INY
  INX
  CPY #$20
  BNE LoadPalettesLoop

  LDA #$01
  STA refreshPalette

  RTS
