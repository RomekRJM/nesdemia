RenderPreLevelBackground:
  LDA #$00
  STA $2000
  STA $2001

  LDA #$20
  STA ppuHigh
  LDA #$00
  STA ppuLow

  LDA #.LOBYTE(PreLevelBackground)
  STA backgroundPointerLo
  LDA #.HIBYTE(PreLevelBackground)
  STA backgroundPointerHi
  LDA #.LOBYTE(BackgroundLLClear)
  STA backgroundLLPointerLo
  LDA #.HIBYTE(BackgroundLLClear)
  STA backgroundLLPointerHi

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
