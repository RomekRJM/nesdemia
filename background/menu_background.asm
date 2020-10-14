RenderMenuBackground:
  LDA #$00
  STA $2000
  STA $2001

  LDA #$20
  STA ppuHigh
  LDA #$00
  STA ppuLow

  LDA #.LOBYTE(MenuBackground)
  STA backgroundPointerLo
  LDA #.HIBYTE(MenuBackground)
  STA backgroundPointerHi
  LDA #.LOBYTE(BackgroundLLClear)
  STA backgroundLLPointerLo       ; put the low byte of the address of background's last line into pointer
  LDA #.HIBYTE(BackgroundLLClear)
  STA backgroundLLPointerHi       ; put the high byte of the address into pointer

  JSR RenderBackground
  JSR LoadMenuAttributes

  LDA #$00
  STA $2005
  STA $2005

  LDA #%10010000 ; enable NMI change background to use second chr set of tiles
  STA $2000
  ; Enabling sprites and background for left-most 8 pixels
  ; Enable sprites and background
  LDA #%00011110
  STA $2001
