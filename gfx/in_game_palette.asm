LoadInGamePalettes:
  LDA #.LOBYTE(InGamePaletteData)
  STA palettePointerLo       ; put the low byte of the address of background into pointer
  LDA #.HIBYTE(InGamePaletteData)
  STA palettePointerHi       ; put the high byte of the address into pointer

  LDX winCondition
  BNE :+
    LDA #$00
  :

  CPX #$01
  BNE :+
    LDA #$18
  :

  CPX #$02
  BNE :+
    LDA #$2f
  :

  CPX #$03
  BNE :+
    LDA #$1c
  :

  CPX #$04
  BNE :+
    LDA #$09
  :

  JSR LoadPalettes

  RTS
