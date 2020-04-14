LoadPalettes:
  LDA PaletteData, X
  STA $2007 ; $3F00, $3F01, $3F02 => $3F1F
  INX
  CPX #$20
  BNE LoadPalettes

  ; Enable interrupts
  CLI

  LDA #%10010000 ; enable NMI change background to use second chr set of tiles ($1000)
  STA $2000
  ; Enabling sprites and background for left-most 8 pixels
  ; Enable sprites and background
  LDA #%00011110
  STA $2001
  JMP MainGameLoop
